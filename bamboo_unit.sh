#!/bin/bash
type module >& /dev/null || . /mnt/software/Modules/current/init/bash
module load gcc/6.4.0
module load hdf5-tools/1.8.19
module load zlib/1.2.11
module load htslib/1.3.1

PATH=$PWD/bax2bam/bin:$PATH
LD_LIBRARY_PATH=$PWD/blasr_libcpp/alignment:$LD_LIBRARY_PATH
LD_LIBRARY_PATH=$PWD/blasr_libcpp/hdf:$LD_LIBRARY_PATH
LD_LIBRARY_PATH=$PWD/blasr_libcpp/pbdata:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH PATH

rm -rf test-reports; mkdir -p test-reports

GTEST_OUTPUT="xml:$PWD/test-reports/bax2bam_results.xml" \
make -C bax2bam/build test
