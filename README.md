# STM32MP151 Dev Board Buildroot
A Buildroot external tree for a custom PCB based on an [MYiR SoM](https://www.myirtech.com/list.asp?id=658). This project, along with the PCB design below, were an educational experience to learn the Buildroot system, Linux kernel, and a bit of PCB design. It currently boots to Linux 5.1x with a minimal collection of packages, and has a demo of [LVGL](https://github.com/lvgl/lv_port_linux_frame_buffer) using the framebuffer.
* [PCB Design Files](https://github.com/BasicCode/STM32MP151_Dev_Board_PCB)
  
**NOTE:** This is currently in development. While it does work, in that it compiles and boots, it doesn't do anything else.

## Current State
The build is very similar to the mainline STM32MP157c-DK2 device tree however there are some minor changes due to the pinout of the SoM, and the RAM configuration. Not all of module-specific pinouts have been implemented yet.
* Uses Linux kernel 5.1
* Tested with Buildroot 2023.04
* Tested with ATF 2.7
* Uses mainline STM32 dtsi where possible, and ARM Trusted Firmware with *sp_min* for BL2.
* Custom dts and dtsi are included for board specific changes. Not all of the SoM specific pinouts are reflected in the files.
* Includes a file system overlay with some configuration, but ```boot/extlinux.conf``` is the only file which is actually required.
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

## Trips and Tricks
Some things that caught me out, or helped me out, along the way:
* I had trouble figuring out how to convince ARM Trusted Firmwawre to build a FIP package from within Buildroot. For reference, or if you want, or need, to create one manually you can do so from within the *buildroot/output/build/arm-trusted-firmware/build/stm32mp1/debug* directory:<br />
```
fiptool create --tos-fw bl32.bin --fw-config fdts/stm32mp151_dev_board-tf-a-fw-config.dtb --hw-config u-boot.dtb --nt-fw u-boot.bin --tos-fw-config fdts/stm32mp151_dev_board-tf-a-bl32.dtb fip.bin
```
  
Where the *u-boot.bin*, and *u-boot.dtb* files are found in the *buildroot/output/build/uboot* directory.

* Remember that the FIP package contains the second stage bootloader, and loads the U-Boot DTB file. So if you modify the device tree you will need to manually rebuild U-Boot, **and** ARM Trusted Firmware, and probably the Linux kernel as well depending on your changes. 
 1. ```make linux-rebuild```
 2. ```make uboot-rebuild```
 3. ```make arm-trusted-firmware-rebuild```
 4. Finally; ```make``` to generate the image.

 * This seems to boot on the STM32MP157c-DK2 development kit, however the STM32MP157c-DK2 default build does **not** boot on this board because the RAM timing seems to be different or something. Of course the pin configuration for peripherals are different, in particular the *MMC_DETECT* signal is *ACTIVE_HIGH* on this board, but *ACTIVE_LOW* on the STM32MP157c-DK2.