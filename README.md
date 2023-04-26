# STM32MP15x_Dev_Board
This is a work-in-progress for a custom PCB based on an *STM32MP15x* chip.<br />
<br />
**NOTE:** This is currently in development. While it does work, in that it compiles and boots, it doesn't do anything else. Read on.

## Current State
Currently, this is just an external Buildroot tree for the *STM32MP157c-DK2* development board. It is a convenient way to test modifications to the board without editing the original code. It currently boots to Linux 5.1x with a collection of packages (SDL, X11, chocolate-doom, etc.), and has a demo of [LVGL](https://github.com/lvgl/lv_port_linux_frame_buffer) using the framebuffer.
* Uses Linux kernel 5.1
* Tested with Buildroot 2022.11.1
* Uses mainline STM32 dtsi, and ARM Trusted Firmware where possible.
* Includes an overlay with some configuration, but ```boot/extlinux.conf``` is the only file which is actually required.

## Future
Eventually, and with any luck, this will become the Buildroot external tree for a development board using an *STM32MP151*, probably with a [MYiR SoM](https://www.myirtech.com/list.asp?id=658). Details to follow when, and if, it ever works.

## Usage
This *should* behave like any external buildroot tree, although it is the first time I've made one so who knows. General steps for use:
* Clone this repository, as well as Buildroot.
* In the **Buildroot** directory, create a config file based on this external tree:
```
BR2_EXTERNAL=../STM32MP15x_Dev_Board make stm32mp15x_dev_board_defconfig
```
* Review or modify the system in ```make menuconfig```, then build the image using ```make```.

## Issues
There are so many! But some big ones:
* The *X11* package is included, and it tries to run as a service at startup. However the default configuration is incorrect and it only shows a black screen. To prevent X11 from starting, remove the file **/etc/init.d/S40xorg**, or add a working **xorg.conf** file to the **overlay** folder.
* Linux *.config* **CONFIG_MACH_STM32MP157** changed to **CONFIG_MACH_STM32MP151**.
* Manually create fip package:
 * Copy the *u-boot.dtb*, and *u-boot.bin* files from *output/build/uboot-...* to *output/build/arm-trusted-firmware-v2.7/build/stm32mp1/debug* for convenience.
 * CD to *output\build\arm-trusted-firmware-v2.7\build\stm32mp1\debug* and generate the fip (below).
 * ```fiptool create --tos-fw bl32.bin --fw-config fdts/stm32mp151_dev_board-tf-a-fw-config.dtb --hw-config u-boot.dtb --nt-fw u-boot.bin --tos-fw-config fdts/stm32mp151_dev_board-tf-a-bl32.dtb fip.bin```