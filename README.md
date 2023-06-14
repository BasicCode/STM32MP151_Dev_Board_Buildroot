# STM32MP151 Dev Board Buildroot
This is a work-in-progress for a custom PCB based on an [MYiR SoM](https://www.myirtech.com/list.asp?id=658).
* [PCB Design Files](https://github.com/BasicCode/STM32MP151_Dev_Board_PCB)
  
**NOTE:** This is currently in development. While it does work, in that it compiles and boots, it doesn't do anything else. Read on.

## Current State
Currently, this is just a proof of concept. It currently boots to Linux 5.1x with a minimal collection of packages, and has a demo of [LVGL](https://github.com/lvgl/lv_port_linux_frame_buffer) using the framebuffer.
* Uses Linux kernel 5.1
* Tested with Buildroot 2023.04
* Uses mainline STM32 dtsi, and ARM Trusted Firmware with *sp_min* for BL2.
* Custom dts and dtsi are included for board specific changes. Not all of the SoM-specific pinouts are reflected in the files.
* Includes an overlay with some configuration, but ```boot/extlinux.conf``` is the only file which is actually required.
* Includes an external package for the ESP8089 WiFi Chipset.

## Usage
This *should* behave like any external buildroot tree. General steps for use:
* Clone this repository, as well as Buildroot.
* In the **Buildroot** directory, create a config file based on this external tree:
```
BR2_EXTERNAL=../STM32MP151_Dev_Board_Buildroot make stm32mp151_dev_board_defconfig
```
* Review or modify the system in ```make menuconfig```.
* Build the image using ```make```.
* **NOTE:** There is an issue with UBoot the first time you try to build, see below.
* Use **dd**, **Rufus**, or your software of choice to image an SD card with the *output/images/sdcard.img* file.

## Issues
There are so many! But some big ones:
* U-Boot does not include the custom DTB file in the Makefile when building for the first time. If you get errors about the dtb not being correctly specified, manually adding the dtb filename to the file *buildroot/output/build/uboot-2023.04/arch/arm/dts/Makefile*: <br />
```
stm32mp151_dev_board.dtb
```

* The *X11* package is included, and it tries to run as a service at startup. However the default configuration is incorrect and it only shows a black screen. To prevent X11 from starting, remove the file */etc/init.d/S40xorg*, or add a working *xorg.conf* file to the *overlay* folder.