ESP_HOSTED_NG_VERSION = 1.0
ESP_HOSTED_NG_SITE = ~/esp-hosted-ng
ESP_HOSTED_NG_SITE_METHOD = local

define KERNEL_MODULE_BUILD_CMDS
        $(MAKE) -C '$(@D)' LINUX_DIR='$(LINUX_DIR)' CC='$(TARGET_CC)' LD='$(TARGET_LD)' modules
endef

$(eval $(kernel-module))
$(eval $(generic-package))