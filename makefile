ARCHS = arm64 armv7
#TARGET = iphone:clang:11.2:7.0
DEBUG = 0
#CFLAGS = -fobjc-arc
#THEOS_PACKAGE_DIR_NAME = debs

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FolderController
FolderController_FILES = Tweak.xm
FolderController_FRAMEWORKS = UIKit Foundation

FolderController_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += FolderController
include $(THEOS_MAKE_PATH)/aggregate.mk
