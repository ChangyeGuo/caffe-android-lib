#!/usr/bin/env sh

WD=$(readlink -f "`dirname $0`/..")
ANDROID_LIB_ROOT=${WD}/android_lib

rm -r ${ANDROID_LIB_ROOT}/OpenCL
cp -r ${WD}/OpenCL ${ANDROID_LIB_ROOT}
