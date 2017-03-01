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

if [ "$(uname)" = "Darwin" ]; then
    OS=darwin
elif [ "$(expr substr $(uname -s) 1 5)" = "Linux" ]; then
    OS=linux
elif [ "$(expr substr $(uname -s) 1 10)" = "MINGW32_NT" ||
       "$(expr substr $(uname -s) 1 9)" = "CYGWIN_NT" ]; then
    OS=windows
else
    echo "Unknown OS"
    exit 1
fi

if [ "$(uname -m)" = "x86_64"  ]; then
    BIT=x86_64
else
    BIT=x86
fi

if [ `expr substr "${ANDROID_ABI}" 1 7` = "armeabi" ]; then
    ANDROID_TOOLCHAIN=$NDK_ROOT/toolchains/arm-linux-androideabi-4.9/prebuilt/${OS}-${BIT}/bin
elif [ "${ANDROID_ABI}" = "arm64-v8a" ]; then
    ANDROID_TOOLCHAIN=$NDK_ROOT/toolchains/aarch64-linux-android-4.9/prebuilt/${OS}-${BIT}/bin
elif [ "${ANDROID_ABI}" = "x86" ]; then
    ANDROID_TOOLCHAIN=$NDK_ROOT/toolchains/x86-4.9/prebuilt/${OS}-${BIT}/bin
elif [ "${ANDROID_ABI}" = "x86_64" ]; then
    ANDROID_TOOLCHAIN=$NDK_ROOT/toolchains/x86_64-4.9/prebuilt/${OS}-${BIT}/bin
else
    echo "Error: not support LMDB for ABI: ${ANDROID_ABI}"
    exit 1
fi

WD=$(readlink -f "`dirname $0`/..")
OPENCV_ROOT=${WD}/ffmpeg-2.1.4.android
INSTALL_DIR=${WD}/android_lib

cd ffmpeg-2.1.4.android
${NDK_ROOT}/ndk-build  NDK_ROOT=$NDK_ROOT ANDROID_TOOLCHAIN=$ANDROID_TOOLCHAIN NDK_PROJECT_PATH=. APP_BUILD_SCRIPT=./Android.mk NDK_APPLICATION_MK=./Application.mk -j8

rm -rf ${INSTALL_DIR}/ffmpeg/lib
mkdir -p ${INSTALL_DIR}/ffmpeg/lib
mkdir -p ${INSTALL_DIR}/ffmpeg/include
mkdir -p ${INSTALL_DIR}/ffmpeg/include/libavcodec
mkdir -p ${INSTALL_DIR}/ffmpeg/include/libavformat
mkdir -p ${INSTALL_DIR}/ffmpeg/include/libavutil
mkdir -p ${INSTALL_DIR}/ffmpeg/include/libswscale
cp -rf obj/local/${ANDROID_ABI}/*.a ${INSTALL_DIR}/ffmpeg/lib
cp -rf libavcodec/*.h ${INSTALL_DIR}/ffmpeg/include/libavcodec
cp -rf libavformat/*.h ${INSTALL_DIR}/ffmpeg/include/libavformat
cp -rf libavutil/*.h ${INSTALL_DIR}/ffmpeg/include/libavutil
cp -rf android/-/libavutil/*.h  ${INSTALL_DIR}/ffmpeg/include/libavutil
cp -rf libswscale/*.h  ${INSTALL_DIR}/ffmpeg/include/libswscale

cd "${WD}"

