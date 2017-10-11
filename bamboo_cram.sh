#!/bin/bash

type module >& /dev/null || . /mnt/software/Modules/current/init/bash
module load gcc/6.4.0
module load hdf5-tools/1.8.19
module load zlib/1.2.11
module load htslib/1.5
module load cram/0.7

PATH=$PWD/bax2bam/bin:$PATH
LD_LIBRARY_PATH=$PWD/blasr_libcpp/alignment:$LD_LIBRARY_PATH
LD_LIBRARY_PATH=$PWD/blasr_libcpp/hdf:$LD_LIBRARY_PATH
LD_LIBRARY_PATH=$PWD/blasr_libcpp/pbdata:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH PATH
export BAX2BAM=`which bax2bam`

mkdir -p test-reports
grep BAX2BAM bax2bam/tests/bax2bam.t && \
cram \
    --xunit-file=$PWD/test-reports/bax2bam-cram_xunit.xml \
    bax2bam/tests/bax2bam.t || \
true
chmod +w -R .
