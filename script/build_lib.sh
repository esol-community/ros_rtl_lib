#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "please set parallel job num by arg1."
    exit
fi

export BUILD_PROC_NUM=$1
export PATH=/opt/aarch64_mcos/bin/:${PATH}
export BUILD_TOOLCHAIN_PATH=/opt/aarch64_mcos/aarch64-elf-mcos/cmake/aarch64_elf_mcos_ros_toolchain.cmake
export BUILD_LIB_PREFIX=/opt/aarch64_mcos/aarch64-elf-mcos
export ARC_DIR=/work/share/archives/lib

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE:-$0}")"; pwd)"
REPO_BASE=${SCRIPT_DIR}/../../ros_rtl_lib
RTL_LOG_BASE=${REPO_BASE}/log
RTL_SRC_BASE=${REPO_BASE}/source
PATCH_DIR=${REPO_BASE}/patch
FILE_DIR=${REPO_BASE}/file
RTL_LIBRARY_BASE=${RTL_SRC_BASE}/lib

function exec_with_errproc ()
{
    set +e
    $1 > $2 2>&1
    if [ $? -ne 0 ]; then
        echo "ERROR(${?}) : ${1}"
        exit 1
    fi
    set -e
}
function recreate_dir ()
{
    if [ -e $1 ]; then
        rm -rf $1
    fi
    mkdir -p $1
}
function build_lib ()
{
    echo "building the ${1} library."
    RTL_LIB_DIR=${RTL_LIBRARY_BASE}/$1
    recreate_dir ${RTL_LIB_DIR}

    if [ -d ${PATCH_DIR}/${1} ]; then
        cp -af ${PATCH_DIR}/${1}/* ${RTL_LIB_DIR}
    fi
    if [ -d ${FILE_DIR}/${1} ]; then
        cp -af ${FILE_DIR}/${1}/* ${RTL_LIB_DIR}
    fi

    cp -af ./setup_$1.sh ${RTL_LIB_DIR}
    pushd ${RTL_LIB_DIR} > /dev/null
    exec_with_errproc "./setup_${1}.sh ${BUILD_PROC_NUM}" "${RTL_LOG_BASE}/build_${1}.log"
    popd > /dev/null
    echo "building the ${1} library is complete."
}

if [ ! -d ${RTL_LOG_BASE} ]
then
    mkdir ${RTL_LOG_BASE}
fi

build_lib boost
build_lib console_bridge
build_lib bzip2
build_lib lz4
build_lib eigen
build_lib flann
build_lib qhull
build_lib pcl
build_lib tinyxml
build_lib tinyxml2
build_lib urdfdom_headers
build_lib urdfdom
build_lib uuid
build_lib poco
build_lib googletest
