#!/bin/bash
#set -e

LIB_NAME=tinyxml2
SRC_VER=2.2.0
SRC_DIR=${LIB_NAME}-${SRC_VER}
ARC_NAME=${LIB_NAME}_${SRC_VER}.orig.tar.gz
SRC_ARC=${ARC_DIR}/${ARC_NAME}

CMAKE_LOG=log_cmake_${LIB_NAME}.log
MAKE_LOG=log_make_${LIB_NAME}.log
INST_LOG=log_install_${LIB_NAME}.log

if [ -d ${PWD}/${SRC_DIR} ]; then
    rm -rf ${PWD}/${SRC_DIR}
fi
tar xf ${SRC_ARC}

if [ -d ${PWD}/build ]; then
    rm -rf ${PWD}/build
fi
mkdir build; cd $_

cmake -DCMAKE_FIND_DEBUG_MODE=1 -DCMAKE_TOOLCHAIN_FILE=${BUILD_TOOLCHAIN_PATH} -DCMAKE_INSTALL_PREFIX=${BUILD_LIB_PREFIX} -D_CMAKE_MCOS_ROS_RTL=1 ../${SRC_DIR} > ../${CMAKE_LOG} 2>&1

set +e
COUNTER=0
for ((COUNTER=0; COUNTER < 5; COUNTER++)); do
    make -j${BUILD_PROC_NUM} > ../${MAKE_LOG} 2>&1 && true
    if [ $? -eq 0 ]; then
        break
    fi
done
if [ ${COUNTER} -ge 5 ]; then
    exit 1
fi
make install > ../${INST_LOG} 2>&1
