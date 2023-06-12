XYZ_VERSION = 0f40f6ee64d93c850db6722b8b3cd4e4f1c2ea32
XYZ_SITE = $(call github,raashidmuhammed,esp8266,$(XYZ_VERSION))
XYZ_LICENSE = GPLv2
XYZ_LICENSE_FILES = COPYING
 
define KERNEL_MODULE_BUILD_CMDS
        $(MAKE) -C '$(@D)' LINUX_DIR='$(LINUX_DIR)' CC='$(TARGET_CC)' LD='$(TARGET_LD)' modules
endef
 
$(eval $(kernel-module))
$(eval $(generic-package))