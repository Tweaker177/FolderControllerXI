ARCHS = armv7 arm64 armv7s
TARGET = iphone:clang:9.2:7.0
#CFLAGS = -fobjc-arc
#THEOS_PACKAGE_DIR_NAME = debs

include theos/makefiles/common.mk

TWEAK_NAME = FolderController
FolderController_FILES = Tweak.xm
FolderController_FRAMEWORKS = UIKit
FolderController_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += FolderController
include $(THEOS_MAKE_PATH)/aggregate.mk
