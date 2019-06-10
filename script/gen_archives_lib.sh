#!/bin/bash

set -e

ARC_DIR=/work/share/archives
LIB_DIR=${ARC_DIR}/lib

BOOST_MD5SUM='41d7542ce40e171f3f7982aff008ff0d'
BZIP2_MD5SUM='2a1df12bd405cc86790291797673753c'
CONSOL_BRIDGE_MD5SUM='6c525353efe6f386fa25d58eafa72869'
EIGEN_MD5SUM='a7aab9f758249b86c93221ad417fbe18'
FLANN_MD5SUM='4897773f78ed74ac26e79b9e32ee86f3'
GOOGLETEST_MD5SUM='5df5464821825959e3dba5fdcd3e4991'
LZ4_MD5SUM='42b09fab42331da9d3fb33bd5c560de9'
PCL_MD5SUM='02c72eb6760fcb1f2e359ad8871b9968'
POCO_MD5SUM='aca03a31a0f0fbfbc133f42e53a8586a'
QHULL_MD5SUM='e6270733a826a6a7c32b796e005ec3dc'
TINYXML_MD5SUM='c1b864c96804a10526540c664ade67f0'
TINYXML2_MD5SUM='3c7a9191c8f26e4f056a89902ac848b1'
URDFDOM_MD5SUM='a22a87c5f75c38822c5ae8d07c9903f7'
URDFDOM_HEADERS_MD5SUM='73cfc08b936231a78dc899df5ebd269d'
PACKAGE_MD5SUM='37216444915c891575542e27ab380da0'
RTEMS_MD5SUM='b973b5108bf908d373b1540bde54a713'


function get_archive() {
    DL_URL=${1}
    MD5_VALUE=${2}

    file_name=${DL_URL##*/}
    wget ${DL_URL} -P ${LIB_DIR}
    get_md5_value=$(md5sum ${LIB_DIR}/${file_name} | cut -d " " -f 1)

    if [ ${get_md5_value} = ${MD5_VALUE} ]; then
        echo "${file_name} :verify success" >&1
    else
        echo "${file_name} :verify error" >&2
        exit
    fi
}


rm -rf ${LIB_DIR}
mkdir -p ${LIB_DIR}

get_archive https://dl.bintray.com/boostorg/release/1.65.1/source/boost_1_65_1.tar.bz2 ${BOOST_MD5SUM}
get_archive http://archive.ubuntu.com/ubuntu/pool/main/b/bzip2/bzip2_1.0.6.orig.tar.bz2 ${BZIP2_MD5SUM}
get_archive http://archive.ubuntu.com/ubuntu/pool/universe/c/console-bridge/console-bridge_0.3.2.orig.tar.gz ${CONSOL_BRIDGE_MD5SUM}
get_archive http://bitbucket.org/eigen/eigen/get/3.3.4.tar.bz2 ${EIGEN_MD5SUM}
get_archive http://archive.ubuntu.com/ubuntu/pool/universe/f/flann/flann_1.8.4.orig.tar.gz ${FLANN_MD5SUM}
get_archive https://github.com/google/googletest/archive/3c5e064ca089cbe3e89278e16c2c6cc3a97dba1f.zip ${GOOGLETEST_MD5SUM}
get_archive http://archive.ubuntu.com/ubuntu/pool/main/l/lz4/lz4_0.0~r131.orig.tar.gz ${LZ4_MD5SUM}
get_archive http://archive.ubuntu.com/ubuntu/pool/universe/p/pcl/pcl_1.7.2.orig.tar.gz ${PCL_MD5SUM}
get_archive http://archive.ubuntu.com/ubuntu/pool/universe/p/poco/poco_1.8.0.1.orig.tar.bz2 ${POCO_MD5SUM}
get_archive http://archive.ubuntu.com/ubuntu/pool/universe/q/qhull/qhull_2015.2.orig.tar.gz ${QHULL_MD5SUM}
get_archive http://archive.ubuntu.com/ubuntu/pool/main/t/tinyxml/tinyxml_2.6.2.orig.tar.gz ${TINYXML_MD5SUM}
get_archive http://archive.ubuntu.com/ubuntu/pool/universe/t/tinyxml2/tinyxml2_2.2.0.orig.tar.gz ${TINYXML2_MD5SUM}
get_archive http://archive.ubuntu.com/ubuntu/pool/universe/u/urdfdom/urdfdom_0.4.1.orig.tar.gz ${URDFDOM_MD5SUM}
get_archive http://archive.ubuntu.com/ubuntu/pool/universe/u/urdfdom-headers/urdfdom-headers_0.4.1.orig.tar.gz ${URDFDOM_HEADERS_MD5SUM}
get_archive https://raw.github.com/ros-gbp/urdfdom_headers-release/debian/hydro/precise/urdfdom_headers/package.xml ${PACKAGE_MD5SUM}
get_archive https://git.rtems.org/rtems/snapshot/rtems-4.10.2.tar.bz2 ${RTEMS_MD5SUM}

tar xjf ${LIB_DIR}/rtems-4.10.2.tar.bz2
cp -af rtems-4.10.2/cpukit/libmisc/uuid/ .
rm -rf rtems-4.10.2
tar czf uuid_rtems_4.10.2.orig.tar.gz uuid
rm -rf uuid
mv uuid_rtems_4.10.2.orig.tar.gz ${LIB_DIR}

mv ${LIB_DIR}/3c5e064ca089cbe3e89278e16c2c6cc3a97dba1f.zip ${LIB_DIR}/googletest_3c5e064.zip
mv ${LIB_DIR}/3.3.4.tar.bz2 ${LIB_DIR}/eigen_3.3.4.orig.tar.bz2
