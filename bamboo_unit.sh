#!/bin/bash
type module >& /dev/null || . /mnt/software/Modules/current/init/bash
module load gcc
module load hdf5-tools
module load zlib
module load htslib

PATH=$PWD/bax2bam/bin:$PATH
LD_LIBRARY_PATH=$PWD/blasr_libcpp/alignment:$LD_LIBRARY_PATH
LD_LIBRARY_PATH=$PWD/blasr_libcpp/hdf:$LD_LIBRARY_PATH
LD_LIBRARY_PATH=$PWD/blasr_libcpp/pbdata:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH PATH

rm -rf test-reports; mkdir -p test-reports

GTEST_OUTPUT="xml:$PWD/test-reports/bax2bam_results.xml" \
make -C bax2bam/build test
