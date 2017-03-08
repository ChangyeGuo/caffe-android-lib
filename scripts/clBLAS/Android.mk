# Copyright (C) 2010 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES:= \
	include/AutoGemmIncludes/AutoGemmClKernels.cpp    \
	include/AutoGemmIncludes/AutoGemmKernelBuildOptionsSource.cpp  \
	include/AutoGemmIncludes/AutoGemmKernelSources.cpp  \
	include/AutoGemmIncludes/AutoGemmKernelBinaries.cpp \
	include/AutoGemmIncludes/AutoGemmKernelSelection.cpp\
	include/AutoGemmIncludes/AutoGemmKernelBuildOptionsBinary.cpp  \
	include/AutoGemmIncludes/AutoGemmKernelSelectionSpecific.cpp  \
	src/library/blas/specialCases/GemmSpecialCases.cpp \
	src/library/blas/AutoGemm/UserGemmKernelSources/UserGemmClKernels.cc \
	src/library/common/clkern.c    \
	src/library/common/kern_cache.c  \
	src/library/common/kgen_guard.c  \
	src/library/common/md5sum.c  \
	src/library/common/rwlock.c  \
	src/library/common/devinfo-cache.c  \
	src/library/common/kerngen_core.c  \
	src/library/common/kgen_loop_helper.c  \
	src/library/common/misc.c    \
	src/library/common/trace_malloc.c \
	src/library/common/devinfo.c    \
	src/library/common/kgen_basic.c  \
	src/library/common/list.c  \
	src/library/common/mutex.c \
	src/library/common/gens/dblock_kgen.c \
	src/library/blas/impl.c    \
	src/library/blas/xcopy.c   \
	src/library/blas/xhemv.c   \
	src/library/blas/xrot.c    \
	src/library/blas/xswap.c   \
	src/library/blas/xtbmv.c   \
	src/library/blas/init.c    \
	src/library/blas/xdot.c    \
	src/library/blas/xher.c    \
	src/library/blas/xrotg.c   \
	src/library/blas/xsymm.c   \
	src/library/blas/xtbsv.c   \
	src/library/blas/ixamax.c  \
	src/library/blas/xgbmv.c   \
	src/library/blas/xher2.c   \
	src/library/blas/xrotm.c   \
	src/library/blas/xsymv.c   \
	src/library/blas/xtrmm.c   \
	src/library/blas/matrix.c  \
	src/library/blas/xgemm2.c  \
	src/library/blas/xher2k.c  \
	src/library/blas/xrotmg.c  \
	src/library/blas/xsyr.c    \
	src/library/blas/xtrmv.c   \
	src/library/blas/scimage.c \
	src/library/blas/xgemv.c   \
	src/library/blas/xherk.c   \
	src/library/blas/xscal.c   \
	src/library/blas/xsyr2.c   \
	src/library/blas/xtrsv.c   \
	src/library/blas/xasum.c   \
	src/library/blas/xger.c    \
	src/library/blas/xhpmv.c   \
	src/library/blas/xshbmv.c  \
	src/library/blas/xsyr2k.c  \
	src/library/blas/xaxpy.c   \
	src/library/blas/xhemm.c   \
	src/library/blas/xnrm2.c   \
	src/library/blas/xspmv.c   \
	src/library/blas/xsyrk.c   \
	src/library/blas/fill.cc   \
	src/library/blas/xgemm.cc  \
	src/library/blas/xscal.cc  \
	src/library/blas/xtrsm.cc  \
	src/library/blas/functor/functor_selector.cc \
	src/library/blas/functor/bonaire.cc    \
	src/library/blas/functor/hawaii.cc     \
	src/library/blas/functor/functor.cc    \
	src/library/blas/functor/functor_fill.cc   \
	src/library/blas/functor/functor_xgemm.cc  \
	src/library/blas/functor/functor_xscal.cc   \
	src/library/blas/functor/functor_xscal_generic.cc  \
	src/library/blas/functor/functor_xtrsm.cc  \
	src/library/blas/functor/tahiti.cc \
	src/library/blas/generic/blas_funcs.c  \
	src/library/blas/generic/kdump.c  \
	src/library/blas/generic/matrix_props.c   \
	src/library/blas/generic/solution_seq.c  \
	src/library/blas/generic/common.c   \
	src/library/blas/generic/kernel_extra.c  \
	src/library/blas/generic/problem_iter.c   \
	src/library/blas/generic/solution_seq_make.c \
	src/library/blas/generic/events.c    \
	src/library/blas/generic/matrix_dims.c   \
	src/library/blas/generic/solution_assert.c \
	src/library/blas/generic/binary_lookup.cc  \
	src/library/blas/generic/common2.cc  \
	src/library/blas/generic/functor_cache.cc \
	src/library/blas/gens/blas_kgen.c   \
	src/library/blas/gens/gemm.c   \
	src/library/blas/gens/symv.c   \
	src/library/blas/gens/tilemul.c  \
	src/library/blas/gens/trxm_common.c \
	src/library/blas/gens/blas_subgroup.c  \
	src/library/blas/gens/gemv.c   \
	src/library/blas/gens/syrxk.c  \
	src/library/blas/gens/trmm.c   \
	src/library/blas/gens/tuned_numbers.c \
	src/library/blas/gens/decomposition.c  \
	src/library/blas/gens/gen_helper.c  \
	src/library/blas/gens/tile.c    \
	src/library/blas/gens/trsm.c   \
	src/library/blas/gens/xxmv_common.c  \
	src/library/blas/gens/fetch.c   \
	src/library/blas/gens/gen_init.c  \
	src/library/blas/gens/tile_iter.c  \
	src/library/blas/gens/trsm_kgen.c  \
	src/library/blas/gens/asum.cpp   \
	src/library/blas/gens/gemm_cached.cpp   \
	src/library/blas/gens/iamax.cpp      \
	src/library/blas/gens/rotm_reg.cpp   \
	src/library/blas/gens/syr2_lds.cpp   \
	src/library/blas/gens/axpy_reg.cpp  \
	src/library/blas/gens/gemm_tail_cached.cpp  \
	src/library/blas/gens/kprintf.cpp    \
	src/library/blas/gens/rotmg_reg.cpp    \
	src/library/blas/gens/syr_lds.cpp  \
	src/library/blas/gens/copy_reg.cpp  \
	src/library/blas/gens/ger_lds.cpp   \
	src/library/blas/gens/nrm2.cpp    \
	src/library/blas/gens/scal_reg.cpp   \
	src/library/blas/gens/trmv_reg.cpp  \
	src/library/blas/gens/dot.cpp    \
	src/library/blas/gens/her2_lds.cpp   \
	src/library/blas/gens/reduction.cpp  \
	src/library/blas/gens/swap_reg.cpp    \
	src/library/blas/gens/trsv_gemv.cpp   \
	src/library/blas/gens/gbmv.cpp    \
	src/library/blas/gens/her_lds.cpp   \
	src/library/blas/gens/rotg_reg.cpp  \
	src/library/blas/gens/symm_cached.cpp  \
	src/library/blas/gens/trsv_trtri.cpp  \
	src/library/blas/gens/legacy/blas_kgen_legacy.c  \
	src/library/blas/gens/legacy/gemm_lds.c     \
	src/library/blas/gens/legacy/trmm_lds.c     \
	src/library/blas/gens/legacy/trsm_kgen_legacy.c \
	src/library/blas/gens/legacy/blkmul.c     \
	src/library/blas/gens/legacy/gen_helper_legacy.c  \
	src/library/blas/gens/legacy/trsm_cached_lds.c  \
	src/library/blas/gens/legacy/trsm_lds.c \
	src/library/blas/gens/legacy/gemm_img.c    \
	src/library/blas/gens/legacy/trmm_img.c    \
	src/library/blas/gens/legacy/trsm_img.c    \
	src/library/blas/gens/legacy/trxm_common_legacy.c \
	src/library/tools/tune/dimension.c  \
	src/library/tools/tune/storage_data.c  \
	src/library/tools/tune/storage_io.c  \
	src/library/tools/tune/toolslib.c  \
	src/library/tools/tune/fileio.c    \
	src/library/tools/tune/storage_init.c  \
	src/library/tools/tune/subdim.c   \
	src/library/tools/tune/tune.c




LOCAL_MODULE:= libclBLAS

LOCAL_C_INCLUDES += $(LOCAL_PATH) \
		    $(LOCAL_PATH)/include \
                    $(LOCAL_PATH)/../android_lib/OpenCL/include \
		    $(LOCAL_PATH)/src/include \
		    $(LOCAL_PATH)/src \
		    $(LOCAL_PATH)/src/library/blas/include \
		    $(LOCAL_PATH)/src/library/tools/tune \
		    $(LOCAL_PATH)/src/library/blas/gens \
		    $(LOCAL_PATH)/src/library/blas/functor/include \
		    $(LOCAL_PATH)/src/library/blas/specialCases/include \
		    $(LOCAL_PATH)/src/library/blas/trtri \
		    $(LOCAL_PATH)/src/library/blas/AutoGemm \
		
LOCAL_CFLAGS :=-fexceptions  -DANDROID -DHAVE_ANDROID_OS  -DOPENCL_VERSION=\"1.2\"  

include $(BUILD_STATIC_LIBRARY)


