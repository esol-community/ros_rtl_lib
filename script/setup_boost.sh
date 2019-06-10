#!/bin/bash
set -e

MY_DIR="$(cd "$(dirname "${BASH_SOURCE:-$0}")"; pwd)"
BOOST_ARC=/work/share/archives/lib/boost_1_65_1.tar.bz2
WORK_ROOT="${MY_DIR}/work"
BUILD_ROOT="${WORK_ROOT}/build"
SRC_ROOT="${WORK_ROOT}/boost_1_65_1"
JAM_OPS=""

if [ -d ${SRC_ROOT} ]; then
    rm -fr ${SRC_ROOT}
fi
if [ -d ${BUILD_ROOT} ]; then
    rm -fr ${BUILD_ROOT}
fi
mkdir -p "${BUILD_ROOT}"

cd "${WORK_ROOT}"
tar xf ${BOOST_ARC}

 cd "${SRC_ROOT}"
./bootstrap.sh

if [ -f "${MY_DIR}/user-config.jam" ]; then
    JAM_OPS="--user-config=${MY_DIR}/user-config.jam"
fi
./b2 install \
    -j${BUILD_PROC_NUM} \
    link=static \
    toolset=gcc \
    architecture=arm \
    abi=aapcs \
    address-model=64 \
    cxxflags=\"-std=c++11\" \
    --without-python --without-test --without-log --without-context --without-coroutine --without-fiber \
    --prefix=/opt/aarch64_mcos/aarch64-elf-mcos \
    ${JAM_OPS} \
    --build-dir=${BUILD_ROOT} -d+2 2>&1 | tee ../boost_build.log
