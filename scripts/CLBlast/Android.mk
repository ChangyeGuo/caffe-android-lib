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
	src/cache.cpp \
	src/clblast.cpp \
	src/clblast_c.cpp \
	src/clblast_netlib_c.cpp \
	src/routine.cpp \
	src/utilities/clblast_exceptions.cpp \
	src/utilities/utilities.cpp \
	src/routines/common.cpp  \
	src/routines/level1/xamax.cpp  \
	src/routines/level1/xaxpy.cpp  \
	src/routines/level1/xdot.cpp   \
	src/routines/level1/xdotu.cpp  \
	src/routines/level1/xscal.cpp  \
	src/routines/level1/xasum.cpp  \
	src/routines/level1/xcopy.cpp  \
	src/routines/level1/xdotc.cpp  \
	src/routines/level1/xnrm2.cpp  \
	src/routines/level1/xswap.cpp  \
	src/routines/level2/xgbmv.cpp  \
	src/routines/level2/xgeru.cpp  \
	src/routines/level2/xher2.cpp  \
	src/routines/level2/xsbmv.cpp  \
	src/routines/level2/xsymv.cpp  \
	src/routines/level2/xtpmv.cpp  \
	src/routines/level2/xgemv.cpp  \
	src/routines/level2/xhbmv.cpp  \
	src/routines/level2/xhpmv.cpp  \
	src/routines/level2/xspmv.cpp  \
	src/routines/level2/xsyr.cpp   \
	src/routines/level2/xtrmv.cpp  \
	src/routines/level2/xger.cpp   \
	src/routines/level2/xhemv.cpp  \
	src/routines/level2/xhpr.cpp   \
	src/routines/level2/xspr.cpp   \
	src/routines/level2/xsyr2.cpp  \
	src/routines/level2/xgerc.cpp  \
	src/routines/level2/xher.cpp   \
	src/routines/level2/xhpr2.cpp  \
	src/routines/level2/xspr2.cpp  \
	src/routines/level2/xtbmv.cpp  \
	src/routines/level3/xgemm.cpp  \
	src/routines/level3/xher2k.cpp  \
	src/routines/level3/xsymm.cpp   \
	src/routines/level3/xsyrk.cpp  \
	src/routines/level3/xhemm.cpp  \
	src/routines/level3/xherk.cpp  \
	src/routines/level3/xsyr2k.cpp \
	src/routines/level3/xtrmm.cpp  \
	src/routines/levelx/xomatcopy.cpp \
	src/database/database.cpp \


LOCAL_MODULE:= libclblast

LOCAL_C_INCLUDES += ./include \
                    $(LOCAL_PATH)/../android_lib/OpenCL/include \
		    $(LOCAL_PATH)/src \
		
LOCAL_CFLAGS :=-fexceptions -std=c++11 -DANDROID -DHAVE_ANDROID_OS  

include $(BUILD_STATIC_LIBRARY)


