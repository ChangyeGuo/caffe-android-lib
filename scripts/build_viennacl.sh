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
N_JOBS=${N_JOBS:-4}
VIENNACL_ROOT=${WD}/viennacl
BUILD_DIR=${VIENNACL_ROOT}/build

ANDROID_LIB_ROOT=${WD}/android_lib
BOOST_HOME=${ANDROID_LIB_ROOT}/boost
OPENCL_DIR="${ANDROID_LIB_ROOT}/OpenCL/"
export OPENCLROOT=${OPENCL_DIR}
export VIENNACL_HOME="${ANDROID_LIB_ROOT}/viennacl"

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

cmake -DCMAKE_TOOLCHAIN_FILE="${WD}/android-cmake/android.toolchain.cmake" \
      -DANDROID_NDK="${NDK_ROOT}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DANDROID_ABI="${ANDROID_ABI}" \
      -DANDROID_NATIVE_API_LEVEL=21 \
      -DANDROID_USE_OPENMP=ON \
      -DBUILD_TESTING=OFF \
      -DENABLE_UBLAS=OFF \
      -DOPENCL_LIB_SEARCH_PATH="${OPENCL_DIR}/lib/${ANDROID_ABI}" \
      -DBUILD_EXAMPLES=OFF \
      -DBOOSTPATH="${BOOST_HOME}" \
      -DADDITIONAL_FIND_PATH="${ANDROID_LIB_ROOT}" \
      -DCMAKE_INSTALL_PREFIX="${ANDROID_LIB_ROOT}/VIENNACL" \
      ..

make clean
make -j${N_JOBS}
rm -rf "${ANDROID_LIB_ROOT}/VIENNACL"
make install/strip

cd "${WD}"
