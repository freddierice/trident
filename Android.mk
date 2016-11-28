LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

TARGET_ARCH := arm
TARGET_ARCH_ABI := arm64-v8a
LOCAL_SRC_FILES := \
  dirtycow.c \
  shared.c \
  load.c

LOCAL_MODULE := load
LOCAL_LDFLAGS   += -llog
LOCAL_CFLAGS    += -fPIE
LOCAL_LDFLAGS   += -fPIE -pie
LOCAL_C_INCLUDES += $(ANDROID_NDK_HOME)/platforms/android-23/arch-arm/usr/include

include $(BUILD_EXECUTABLE)
include $(CLEAR_VARS)

TARGET_ARCH := arm
TARGET_ARCH_ABI := arm64-v8a
LOCAL_SRC_FILES := \
  dirtycow.c \
  shared.c \
  stage.c

LOCAL_MODULE := stage
LOCAL_LDFLAGS   += -llog
LOCAL_CFLAGS    += -fPIE
LOCAL_LDFLAGS   += -fPIE -pie
LOCAL_C_INCLUDES += $(ANDROID_NDK_HOME)/platforms/android-23/arch-arm/usr/include

include $(BUILD_EXECUTABLE)
include $(CLEAR_VARS)

TARGET_ARCH := arm
TARGET_ARCH_ABI := arm64-v8a
LOCAL_SRC_FILES := \
  reverse.c

LOCAL_MODULE := reverse
LOCAL_CFLAGS    += -fPIE
LOCAL_LDFLAGS   += -fPIE -pie -llog
LOCAL_C_INCLUDES += $(ANDROID_NDK_HOME)/platforms/android-23/arch-arm/usr/include

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
