#!/bin/bash -e
rm -rf test-reports

mkdir -p prebuilts/libbzip2-1.0.6
curl -sL http://ossnexus/repository/unsupported/pitchfork/gcc-4.9.2/libbzip2-1.0.6.tgz \
| tar zxf - -C prebuilts/libbzip2-1.0.6
if [ ! -e .distfiles/gtest/release-1.7.0.tar.gz ]; then
  mkdir -p .distfiles/gtest
  curl -sL http://ossnexus/repository/unsupported/distfiles/googletest/release-1.7.0.tar.gz \
    -o .distfiles/gtest/release-1.7.0.tar.gz
fi

type module >& /dev/null || . /mnt/software/Modules/current/init/bash
module load git/2.8.3
module load gcc/4.9.2
module load ccache/3.2.3
cat > pitchfork/settings.mk << EOF
PREFIX            = $PWD/deployment
DISTFILES         = $PWD/.distfiles
# from Herb
HAVE_OPENSSL      = /mnt/software/o/openssl/1.0.2a
HAVE_PYTHON       = /mnt/software/p/python/2.7.9/bin/python
HAVE_BOOST        = /mnt/software/b/boost/1.58.0
HAVE_ZLIB         = /mnt/software/z/zlib/1.2.8
HAVE_SAMTOOLS     = /mnt/software/s/samtools/1.3.1mobs
HAVE_NCURSES      = /mnt/software/n/ncurses/5.9
# from MJ
HAVE_HDF5         = /mnt/software/a/anaconda2/4.2.0
HAVE_OPENBLAS     = /mnt/software/o/openblas/0.2.14
HAVE_CMAKE        = /mnt/software/c/cmake/3.2.2/bin/cmake
HAVE_LIBBZIP2     = $PWD/prebuilts/libbzip2-1.0.6
#
bax2bam_REPO      = $PWD/bax2bam
htslib_REPO       = $PWD/htslib
pbbam_REPO        = $PWD/pbbam
blasr_libcpp_REPO = $PWD/blasr_libcpp
EOF
echo y | make -C pitchfork _startover
cd pitchfork
VERBOSE=1 make bax2bam -j8
