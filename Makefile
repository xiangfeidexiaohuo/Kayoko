export ARCHS = arm64 arm64e
export TARGET = iphone:clang:latest:14.0
export DEBUG=0
FINALPACKAGE=1

INSTALL_TARGET_PROCESSES = SpringBoard Preferences
SUBPROJECTS = Tweak/Core Tweak/Helper Daemon Preferences

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

ifeq ($(THEOS_PACKAGE_SCHEME), roothide)
stage::
	plutil -replace Program -string $(THEOS_PACKAGE_INSTALL_PREFIX)/usr/libexec/kayokod $(THEOS_STAGING_DIR)/Library/LaunchDaemons/codes.aurora.kayokod.plist
endif
