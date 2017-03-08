#!/usr/bin/env sh
set -e

if [ -z "$NDK_ROOT" ] && [ "$#" -eq 0 ]; then
    echo 'Either $NDK_ROOT should be set or provided as argument'
    echo "e.g., 'export NDK_ROOT=/path/to/ndk' or"
    echo "      '${0} /path/to/ndk'"exit 1
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

WD=$(readlink -f "`dirname $0`/..")
OPENBLAS_ROOT=${WD}/blis
INSTALL_DIR=${WD}/android_lib
N_JOBS=${N_JOBS:-4}
CPU_ARCH=${ANDROID_ABI}

cd "${OPENBLAS_ROOT}"

if [ "${ANDROID_ABI}" = "armeabi-v7a" ]; then
    CROSS_SUFFIX=$NDK_ROOT/toolchains/arm-linux-androideabi-4.9/prebuilt/${OS}-${BIT}/bin/arm-linux-androideabi-
    SYSROOT=$NDK_ROOT/platforms/android-21/arch-arm
    CPU_ARCH=armv7a
    NO_LAPACK=${NO_LAPACK:-1}
	TARGET=ARMV7
	BINARY=32
elif [ "${ANDROID_ABI}" = "arm64-v8a"  ]; then
    CROSS_SUFFIX=$NDK_ROOT/toolchains/aarch64-linux-android-4.9/prebuilt/${OS}-${BIT}/bin/aarch64-linux-android-
    SYSROOT=$NDK_ROOT/platforms/android-21/arch-arm64
    CPU_ARCH=armv8a
    NO_LAPACK=${NO_LAPACK:-1}
	TARGET=ARMV8
	BINARY=64
elif [ "${ANDROID_ABI}" = "armeabi"  ]; then
    CROSS_SUFFIX=$NDK_ROOT/toolchains/arm-linux-androideabi-4.9/prebuilt/${OS}-${BIT}/bin/arm-linux-androideabi-
    SYSROOT=$NDK_ROOT/platforms/android-21/arch-arm
    NO_LAPACK=1
	TARGET=ARMV5
	BINARY=32
elif [ "${ANDROID_ABI}" = "x86"  ]; then
    CROSS_SUFFIX=$NDK_ROOT/toolchains/x86-4.9/prebuilt/${OS}-${BIT}/bin/i686-linux-android-
    SYSROOT=$NDK_ROOT/platforms/android-21/arch-x86
    NO_LAPACK=1
	TARGET=ATOM
	BINARY=32
elif [ "${ANDROID_ABI}" = "x86_64"  ]; then
    CROSS_SUFFIX=$NDK_ROOT/toolchains/x86_64-4.9/prebuilt/${OS}-${BIT}/bin/x86_64-linux-android-
    SYSROOT=$NDK_ROOT/platforms/android-21/arch-x86_64
    NO_LAPACK=1
	TARGET=ATOM
	BINARY=64
else
    echo "Error: not support OpenBLAS for ABI: ${ANDROID_ABI}"
    exit 1
fi

./configure -t openmp --enable-cblas $CPU_ARCH
make clean
make -j${N_JOBS} \
     CC="${CROSS_SUFFIX}gcc --sysroot=$SYSROOT" \
     FC="${CROSS_SUFFIX}gfortran --sysroot=$SYSROOT" \
     CROSS_SUFFIX=$CROSS_SUFFIX \
     NO_LAPACK=$NO_LAPACK TARGET=$TARGET BINARY=$BINARY

rm -rf "$INSTALL_DIR/blis"
mkdir -p $INSTALL_DIR/blis/include
mkdir -p $INSTALL_DIR/blis/lib/${ANDROID_ABI}
cp ${OPENBLAS_ROOT}/lib/${CPU_ARCH}/libblis.a $INSTALL_DIR/blis/lib/${ANDROID_ABI}
cp ${OPENBLAS_ROOT}/frame/compat/cblas/src/cblas.h $INSTALL_DIR/blis/include
cp ${OPENBLAS_ROOT}/frame/include/bli_system.h $INSTALL_DIR/blis/include
cp ${OPENBLAS_ROOT}/bli_config.h $INSTALL_DIR/blis/include
cp ${OPENBLAS_ROOT}/frame/include/bli_config_macro_defs.h $INSTALL_DIR/blis/include
cp ${OPENBLAS_ROOT}/frame/include/bli_type_defs.h $INSTALL_DIR/blis/include
cp ${OPENBLAS_ROOT}/frame/thread/bli_mutex.h $INSTALL_DIR/blis/include
cp ${OPENBLAS_ROOT}/frame/thread/bli_mutex_single.h $INSTALL_DIR/blis/include
cp ${OPENBLAS_ROOT}/frame/thread/bli_mutex_openmp.h $INSTALL_DIR/blis/include
cp ${OPENBLAS_ROOT}/frame/thread/bli_mutex_pthreads.h $INSTALL_DIR/blis/include
cp ${OPENBLAS_ROOT}/frame/base/bli_malloc.h $INSTALL_DIR/blis/include

cd "${WD}"
