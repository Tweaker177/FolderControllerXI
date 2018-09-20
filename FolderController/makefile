ARCHS = armv7 arm64 armv7s
TARGET= iphone:clang:9.2:7.0
include theos/makefiles/common.mk

BUNDLE_NAME = FolderController
FolderController_FILES = FolderController.mm
FolderController_INSTALL_PATH = /Library/PreferenceBundles
FolderController_FRAMEWORKS = UIKit
FolderController_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/FolderController.plist$(ECHO_END)
