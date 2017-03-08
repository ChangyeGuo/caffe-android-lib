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
CAFFE_ROOT=${WD}/caffe
BUILD_DIR=${CAFFE_ROOT}/build

ANDROID_LIB_ROOT=${WD}/android_lib
BOOST_HOME=${ANDROID_LIB_ROOT}/boost
GFLAGS_HOME=${ANDROID_LIB_ROOT}/gflags
GLOG_ROOT=${ANDROID_LIB_ROOT}/glog
OPENCV_ROOT=${ANDROID_LIB_ROOT}/opencv/sdk/native/jni
PROTOBUF_ROOT=${ANDROID_LIB_ROOT}/protobuf
export LMDB_DIR=${ANDROID_LIB_ROOT}/lmdb
export OpenBLAS_HOME="${ANDROID_LIB_ROOT}/openblas"
export OPENCL_DIR="${ANDROID_LIB_ROOT}/OpenCL"
export VIENNACL_HOME="${ANDROID_LIB_ROOT}/VIENNACL"
export CLBLAS_HOME="${ANDROID_LIB_ROOT}/clblas"
CLBLAST=""
CLBLAS=""
BLISBLAS=""
USE_CLBLAST=0
USE_CLBLAS=0
USE_BLIS=0

if [ "$USE_BLIS" -eq 1 ]; then
    CLBLAST="-DUSE_BLIS=1"  
    CLBLAST="$CLBLAST -Dblis_INCLUDE_DIR=${ANDROID_LIB_ROOT}/blis/include" 
    CLBLAST="$CLBLAST -Dblis_LIB=${ANDROID_LIB_ROOT}/blis/lib/${ANDROID_ABI}/libblis.a" 
fi

if [ "$USE_CLBLAST" -eq 1 ]; then
    CLBLAST="-DUSE_CLBLAST=1"  
    CLBLAST="$CLBLAST -DCLBLAST_INCLUDE=${ANDROID_LIB_ROOT}/clblast/include" 
    CLBLAST="$CLBLAST -DCLBLAST_LIB=${ANDROID_LIB_ROOT}/clblast/lib/${ANDROID_ABI}" 
    CLBLAST="$CLBLAST -DCPPSHAREDLIB=$NDK_ROOT/sources/cxx-stl/llvm-libc++/libs/$ANDROID_ABI/libc++_shared.so"
fi

if [ "$USE_CLBLAS" -eq 1 ]; then
    CLBLAS="-DUSE_CLBLAS=1"  
    CLBLAS="$CLBLAS -DCLBLAS_INCLUDE=${ANDROID_LIB_ROOT}/clblas/include" 
    CLBLAS="$CLBLAS -DCLBLAS_LIB=${ANDROID_LIB_ROOT}/clblas/lib/${ANDROID_ABI}" 
    CLBLAST="$CLBLAST -DCPPSHAREDLIB=$NDK_ROOT/sources/cxx-stl/llvm-libc++/libs/$ANDROID_ABI/libc++_shared.so"
fi


rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

cmake -DCMAKE_TOOLCHAIN_FILE="${WD}/android-cmake/android.toolchain.cmake" \
      -DANDROID_NDK="${NDK_ROOT}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DANDROID_ABI="${ANDROID_ABI}" \
      -DANDROID_NATIVE_API_LEVEL=21 \
      -DANDROID_USE_OPENMP=ON \
      -DADDITIONAL_FIND_PATH="${ANDROID_LIB_ROOT}" \
      -DBUILD_python=OFF \
      -DBUILD_docs=OFF \
      -DUSE_GREENTEA=1 \
      -DVIENNACL_DIR="../ViennaCL" $CLBLAST $CLBLAS \
      -DUSE_LMDB=ON \
      -DUSE_LIBDNN=OFF \
      -DUSE_LEVELDB=OFF \
      -DUSE_HDF5=OFF \
      -DBLAS=open \
      -DBOOST_ROOT="${BOOST_HOME}" \
      -DGFLAGS_INCLUDE_DIR="${GFLAGS_HOME}/include" \
      -DGFLAGS_LIBRARY="${GFLAGS_HOME}/lib/libgflags.a" \
      -DGLOG_INCLUDE_DIR="${GLOG_ROOT}/include" \
      -DGLOG_LIBRARY="${GLOG_ROOT}/lib/libglog.a" \
      -DOpenCV_DIR="${OPENCV_ROOT}" \
      -DPROTOBUF_PROTOC_EXECUTABLE="${ANDROID_LIB_ROOT}/protobuf_host/bin/protoc" \
      -DPROTOBUF_INCLUDE_DIR="${PROTOBUF_ROOT}/include" \
      -DPROTOBUF_LIBRARY="${PROTOBUF_ROOT}/lib/libprotobuf.a" \
      -DCMAKE_INSTALL_PREFIX="${ANDROID_LIB_ROOT}/caffe" \
      ..

make clean
make -j${N_JOBS}
rm -rf "${ANDROID_LIB_ROOT}/caffe"
make install/strip

cd "${WD}"
