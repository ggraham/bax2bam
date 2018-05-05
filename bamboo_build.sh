#!/usr/bin/env bash
set -e

echo "################"
echo "# DEPENDENCIES #"
echo "################"

echo "## Load modules"
type module >& /dev/null || . /mnt/software/Modules/current/init/bash

module purge

module load gcc
module load ccache

module load meson
module load ninja

module load boost
module load gtest
module load cram

module load libblasr

BOOST_ROOT="${BOOST_ROOT%/include}"
# unset these variables to have meson discover all
# boost-dependent variables from BOOST_ROOT alone
unset BOOST_INCLUDEDIR
unset BOOST_LIBRARYDIR

export CC="ccache gcc"
export CXX="ccache g++"
export CCACHE_BASEDIR="${PWD}"

if [[ $USER == bamboo ]]; then
  export CCACHE_DIR=/mnt/secondary/Share/tmp/bamboo.${bamboo_shortPlanKey}.ccachedir
  export CCACHE_TEMPDIR=/scratch/bamboo.ccache_tempdir
fi


echo "#########"
echo "# BUILD #"
echo "#########"

CURRENT_BUILD_DIR="build"

# 1. configure
# '--wrap-mode nofallback' prevents meson from downloading
# stuff from the internet or using subprojects.
echo "## Configuring source (${CURRENT_BUILD_DIR})"
CPPFLAGS="${HDF5_CFLAGS}" \
LDFLAGS="${HDF5_LIBS}" \
  meson \
    --wrap-mode nofallback \
    --strip \
    -Dtests=true \
    "${CURRENT_BUILD_DIR}" .

# 2. build
echo "## Building source (${CURRENT_BUILD_DIR})"
ninja -C "${CURRENT_BUILD_DIR}" -v

# 3. tests
echo "## Tests (${CURRENT_BUILD_DIR})"
ninja -C "${CURRENT_BUILD_DIR}" -v test
