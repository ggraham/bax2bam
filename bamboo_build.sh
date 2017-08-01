#!/bin/bash -e
mkdir -p .distfiles/gtest
if [ ! -e .distfiles/gtest/release-1.7.0.tar.gz ]; then
  curl -sL http://ossnexus/repository/unsupported/distfiles/googletest/release-1.7.0.tar.gz \
    -o .distfiles/gtest/release-1.7.0.tar.gz
  tar zxf .distfiles/gtest/release-1.7.0.tar.gz
  ln -sfn googletest-release-1.7.0 gtest
fi

set +x
type module >& /dev/null || . /mnt/software/Modules/current/init/bash
module load git/2.8.3
module load gcc/4.9.2
module load ccache/3.2.3
export CCACHE_DIR=/mnt/secondary/Share/tmp/bamboo.mobs.ccachedir
module load boost/1.60
if [[ $BOOST_ROOT =~ /include ]]; then
  set -x
  BOOST_ROOT=$(dirname $BOOST_ROOT)
  set +x
fi
module load ninja/1.7.1
module load cmake/3.7.2
module load hdf5-tools/1.8.16
module load zlib/1.2.8
module load htslib/1.3.1
set -x

cd pbbam
export CCACHE_BASEDIR=$PWD
mkdir build
cd build
rm -rf * && CFLAGS=-fPIC CXXFLAGS=-fPIC CMAKE_BUILD_TYPE=ReleaseWithAssert cmake -GNinja ..
ninja
cd ../../blasr_libcpp
rm -f defines.mk
python configure.py \
      PREFIX=dummy \
    HDF5_INC=$(pkg-config --cflags-only-I hdf5|awk '{print $1}'|sed -e 's/^-I//') \
    HDF5_LIB=$(pkg-config --libs-only-L hdf5|awk '{print $1}'|sed -e 's/^-L//') \
    ZLIB_LIB=$ZLIB_ROOT/lib \
   PBBAM_INC=$PWD/../pbbam/include \
   PBBAM_LIB=$PWD/../pbbam/build/lib \
   BOOST_INC=$BOOST_ROOT/include \
  HTSLIB_INC=$(pkg-config --cflags-only-I htslib|awk '{print $1}'|sed -e 's/^-I//') \
  HTSLIB_LIB=$(pkg-config --libs-only-L htslib|awk '{print $1}'|sed -e 's/^-L//')
make -j libpbdata LDLIBS=-lpbbam
make -j libpbihdf
make -j libblasr

cd ../bax2bam
export CCACHE_BASEDIR=$PWD
mkdir -p build
cd build && rm -rf *
cmake \
        -DBoost_INCLUDE_DIRS=$BOOST_ROOT/include \
              -DHDF5_RootDir=$(pkg-config --libs-only-L hdf5|awk '{print $1}'|sed -e 's/^-L//'|xargs dirname) \
    -DPacBioBAM_INCLUDE_DIRS=$PWD/../../pbbam/include \
       -DPacBioBAM_LIBRARIES=$PWD/../../pbbam/build/lib/libpbbam.a \
       -DHTSLIB_INCLUDE_DIRS=$(pkg-config --cflags-only-I htslib|awk '{print $1}'|sed -e 's/^-I//') \
          -DHTSLIB_LIBRARIES=$(pkg-config --libs-only-L htslib|awk '{print $1}'|sed -e 's/^-L//')/libhts.a \
             -DGTEST_SRC_DIR=$PWD/../../gtest \
            -DZLIB_LIBRARIES=$ZLIB_ROOT/lib/libz.a \
         -DZLIB_INCLUDE_DIRS=$ZLIB_ROOT/include \
        -DBLASR_INCLUDE_DIRS=$PWD/../../blasr_libcpp/alignment \
       -DPBIHDF_INCLUDE_DIRS=$PWD/../../blasr_libcpp/hdf \
       -DPBDATA_INCLUDE_DIRS=$PWD/../../blasr_libcpp/pbdata \
           -DBLASR_LIBRARIES=$PWD/../../blasr_libcpp/alignment/libblasr.a \
          -DPBIHDF_LIBRARIES=$PWD/../../blasr_libcpp/hdf/libpbihdf.a \
          -DPBDATA_LIBRARIES=$PWD/../../blasr_libcpp/pbdata/libpbdata.a \
  ..
make
