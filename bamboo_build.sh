#!/bin/bash -e
mkdir -p .distfiles/gtest
if [ ! -e .distfiles/gtest/release-1.7.0.tar.gz ]; then
  curl -sL http://ossnexus/repository/unsupported/distfiles/googletest/release-1.7.0.tar.gz \
    -o .distfiles/gtest/release-1.7.0.tar.gz
fi
tar zxf .distfiles/gtest/release-1.7.0.tar.gz
ln -sfn googletest-release-1.7.0 gtest

set +x
type module >& /dev/null || . /mnt/software/Modules/current/init/bash
module load git
module load gcc
module load ccache
[[ $USER == "bamboo" ]] && export CCACHE_DIR=/mnt/secondary/Share/tmp/bamboo.mobs.ccachedir || true
module load boost
if [[ $BOOST_ROOT =~ /include ]]; then
  set -x
  BOOST_ROOT=$(dirname $BOOST_ROOT)
  set +x
fi
module load ninja
module load cmake
module load zlib
module load hdf5-tools
module load htslib
set -x

rm -rf prebuilt
mkdir -p prebuilt
tar zxvf pbbam-*.tgz --strip-components 3 -C prebuilt
tar zxvf blasr_libcpp-*.tgz --strip-components 3 -C prebuilt
sed -i -e "s|prefix=|prefix=$PWD/prebuilt|" prebuilt/lib/pkgconfig/pbbam.pc
PREBUILT=$PWD/prebuilt

cd bax2bam
export CCACHE_BASEDIR=$PWD
mkdir -p build
cd build && rm -rf *
cmake \
        -DBoost_INCLUDE_DIRS=$BOOST_ROOT/include \
              -DHDF5_RootDir=$(pkg-config --libs-only-L hdf5|awk '{print $1}'|sed -e 's/^-L//'|xargs dirname) \
    -DPacBioBAM_INCLUDE_DIRS=$PREBUILT/include \
       -DPacBioBAM_LIBRARIES=$PREBUILT/lib/libpbbam.so \
             -DGTEST_SRC_DIR=$PWD/../../gtest \
            -DZLIB_LIBRARIES=$ZLIB_ROOT/lib/libz.so \
         -DZLIB_INCLUDE_DIRS=$ZLIB_ROOT/include \
           -DPBDATA_ROOT_DIR=$PREBUILT/include \
        -DBLASR_INCLUDE_DIRS=$PREBUILT/include/alignment \
       -DPBIHDF_INCLUDE_DIRS=$PREBUILT/include/hdf \
       -DPBDATA_INCLUDE_DIRS=$PREBUILT/include/pbdata \
           -DBLASR_LIBRARIES=$PREBUILT/lib/liblibcpp.a \
          -DPBIHDF_LIBRARIES=$PREBUILT/lib/liblibcpp.a \
          -DPBDATA_LIBRARIES=$PREBUILT/lib/liblibcpp.a \
  ..
make VERBOSE=1
