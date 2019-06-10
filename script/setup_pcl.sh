#!/bin/bash
set -e

LIB_NAME=pcl
SRC_VER=1.7.2
SRC_DIR=${LIB_NAME}-pcl-${SRC_VER}
ARC_NAME=${LIB_NAME}_${SRC_VER}.orig.tar.gz
SRC_ARC=${ARC_DIR}/${ARC_NAME}

CMAKE_LOG=log_cmake_${LIB_NAME}.log
MAKE_LOG=log_make_${LIB_NAME}.log
INST_LOG=log_install_${LIB_NAME}.log

if [ -d ${PWD}/${SRC_DIR} ]; then
    rm -rf ${PWD}/${SRC_DIR}
fi
tar xf ${SRC_ARC}

patch -u -N -t -p1 -d ${SRC_DIR} < patch_pcl-1.7.2_emcos.patch

if [ -d ${PWD}/build ]; then
    rm -rf ${PWD}/build
fi
mkdir build; cd $_

cmake -DCMAKE_FIND_DEBUG_MODE=1 -DCMAKE_TOOLCHAIN_FILE=${BUILD_TOOLCHAIN_PATH} -DCMAKE_INSTALL_PREFIX=${BUILD_LIB_PREFIX} -D_CMAKE_MCOS_ROS_RTL=1 -DQHULL_USE_STATIC=1 ../${SRC_DIR} > ../${CMAKE_LOG} 2>&1

make -j${BUILD_PROC_NUM} > ../${MAKE_LOG} 2>&1
make install > ../${INST_LOG} 2>&1
