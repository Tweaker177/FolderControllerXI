ARCHS = arm64 arm64e
TARGET= iphone:clang:11.2:7.0
DEBUG = 0
include $(THEOS)/makefiles/common.mk

#import <Cephei/CepheiPrefs.framework>

BUNDLE_NAME = FolderController
FolderController_FILES = FolderController.mm FCXIIAboutListController.m
FolderController_INSTALL_PATH = /Library/PreferenceBundles
FolderController_FRAMEWORKS = UIKit
FolderController_PRIVATE_FRAMEWORKS = Preferences
FolderController_EXTRA_FRAMEWORKS += CepheiPrefs
FolderController_LDFLAGS += -lCSColorPicker
FolderController_CFLAGS = -fobjc-arc


include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/FolderController.plist$(ECHO_END)
