# STM32MP15x_Dev_Board
This is a work-in-progress for a custom PCB based on an *STM32MP15x* chip.<br />
<br />
**NOTE:** This is currently in development. While it does work, in that it compiles and boots, it doesn't do anything else. Read on.

## Current State
Currently, this is just an external Buildroot tree for the *STM32MP157c-DK2* development board. It is a convenient way to test modifications to the board without editing the original code. It currently boots to Linux 5.1x with a collection of packages (SDL, X11, chocolate-doom, etc.), and has a demo of [LVGL](https://github.com/lvgl/lv_port_linux_frame_buffer) using the framebuffer.

## Future
Eventually, and with any luck, this will become the Buildroot external tree for a development board using an *STM32MP151*, probably with a [MYiR SoM](https://www.myirtech.com/list.asp?id=658). Details to follow when, and if, it ever works.