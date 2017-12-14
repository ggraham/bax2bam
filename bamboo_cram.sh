#!/bin/bash

type module >& /dev/null || . /mnt/software/Modules/current/init/bash
module load gcc
module load hdf5-tools
module load zlib
module load htslib
module load cram

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
