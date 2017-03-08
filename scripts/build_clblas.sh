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
CLBLAS_ROOT=${WD}/clBLAS/
BUILD_DIR=${CLBLAS_ROOT}
INSTALL_DIR=${WD}/android_lib
N_JOBS=${N_JOBS:-4}

rm -rf ${BUILD_DIR}/obj
mkdir -p "${BUILD_DIR}/include"
cp -rf scripts/clBLAS/* ${BUILD_DIR}
cd "${BUILD_DIR}"
g++ src/library/tools/tplgen/tplgen.cpp -o tplgen
${CLBLAS_ROOT}/tplgen -o include -i src/library/blas/gens/clTemplates/ gemm.cl gemm_helper.cl gbmv.cl ger.cl her.cl \
      symm_helper.cl syr2_her2.cl syr_her.cl trsv.cl her2.cl symm.cl syr2.cl syr.cl trmv.cl trsv_gemv.cl swap.cl \
      scal.cl copy.cl axpy.cl dot.cl reduction.cl rotg.cl rotmg.cl rotm.cl iamax.cl nrm2.cl asum.cl custom_gemm.cl \
      dgemm_hawai.cl dgemm_hawaiiChannelConfilct.cl dgemm_hawaiiSplitKernel.cl sgemm_hawaiiSplitKernel.cl dtrsm_gpu.cl \
      dtrsm_gpu192.cl dgemm_gcn_SmallMatrices.cl sgemm_gcn_SmallMatrices.cl sgemm_gcn_bigMatrices.cl sgemm_gcn.cl zgemm_gcn.cl
python ${CLBLAS_ROOT}/src/library/blas/AutoGemm/KernelsToPreCompile.py --output-path include
python ${CLBLAS_ROOT}/src/library/blas/AutoGemm/AutoGemm.py --output-path include --opencl-compiler-version 1.2 --architecture Hawaii
python ${CLBLAS_ROOT}/src/library/blas/AutoGemm/AutoGemmParameters.py  --output-path include
python ${CLBLAS_ROOT}/src/library/blas/AutoGemm/Common.py --output-path include
python ${CLBLAS_ROOT}/src/library/blas/AutoGemm/Includes.py --output-path include
python ${CLBLAS_ROOT}/src/library/blas/AutoGemm/KernelParameters.py --output-path include
python ${CLBLAS_ROOT}/src/library/blas/AutoGemm/KernelSelection.py --output-path include

echo "#define clblasVersionMajor 2
#define clblasVersionMinor 12
#define clblasVersionPatch 0" >include/clBLAS.version.h



$NDK_ROOT/ndk-build  NDK_PROJECT_PATH=. APP_BUILD_SCRIPT=./Android.mk NDK_APPLICATION_MK=./Application.mk -j${N_JOBS}

rm -rf "${INSTALL_DIR}/clblas"
mkdir -p "${INSTALL_DIR}/clblas/include"
mkdir -p "${INSTALL_DIR}/clblas/lib/$ANDROID_ABI"
cp ${BUILD_DIR}/obj/local/$ANDROID_ABI/libclBLAS.a ${INSTALL_DIR}/clblas/lib/$ANDROID_ABI
ln -s ${INSTALL_DIR}/clblas/lib/$ANDROID_ABI/libclBLAS.a ${INSTALL_DIR}/clblas/lib
cp ${BUILD_DIR}/src/clBLAS.h ${INSTALL_DIR}/clblas/include
cp ${BUILD_DIR}/src/clBLAS-complex.h ${INSTALL_DIR}/clblas/include

cd "${WD}"
