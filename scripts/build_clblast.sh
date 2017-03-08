#!/usr/bin/env sh
set -e

if [ -z "$NDK_ROOT" ] && [ "$#" -eq 0 ]; then
    echo 'Either $NDK_ROOT should be set or provided as argument'
    echo "e.g., 'export NDK_ROOT=/path/to/ndk' or"
    echo "      '${0} /path/to/ndk'"
    exit 1
else
    NDK_ROOT="${1:-${NDK_ROOT}}"
fi

ANDROID_ABI=${ANDROID_ABI:-"armeabi-v7a with NEON"}
WD=$(readlink -f "`dirname $0`/..")
CLBLAST_ROOT=${WD}/CLBlast/
BUILD_DIR=${CLBLAST_ROOT}
INSTALL_DIR=${WD}/android_lib
N_JOBS=${N_JOBS:-4}

mkdir -p "${BUILD_DIR}"
cp -f scripts/CLBlast/* ${BUILD_DIR}
cd "${BUILD_DIR}"


$NDK_ROOT/ndk-build  NDK_PROJECT_PATH=. APP_BUILD_SCRIPT=./Android.mk NDK_APPLICATION_MK=./Application.mk -j${N_JOBS}

rm -rf "${INSTALL_DIR}/clblast"
mkdir -p "${INSTALL_DIR}/clblast/include"
mkdir -p "${INSTALL_DIR}/clblast/lib/$ANDROID_ABI"
cp ${BUILD_DIR}/obj/local/$ANDROID_ABI/libclblast.a ${INSTALL_DIR}/clblast/lib/$ANDROID_ABI
cp ${BUILD_DIR}/include/clblast.h ${INSTALL_DIR}/clblast/include

cd "${WD}"
