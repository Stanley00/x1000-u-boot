export PATH=/usr/lib/ccache:/home/yong/mips/prebuilts/toolchains/mips-gcc472-glibc216/bin:$PATH

make distclean

time CROSS_COMPILE=mips-linux-gnu- make halley2_v10_uImage_sfc_nor -j4 V=1

time make halley2_v10_uImage_sfc_nor -j8 V=1

CROSS_COMPILE="ccache /home/yong/poky/build/tmp/sysroots/x86_64-linux/usr/bin/mipsel-poky-linux/mipsel-poky-linux-" make V=1

# generate u-boot.bin command
mips-linux-gnu-gcc   -D__ASSEMBLY__ -g  -Os   -ffunction-sections -fdata-sections -D__KERNEL__ -DCONFIG_SYS_TEXT_BASE=0x80100000 -DCONFIG_SPL_TEXT_BASE=0xf4001800 -DCONFIG_SPL_PAD_TO=16384 -I/home/yong/mips/u-boot/include -fno-builtin -ffreestanding -nostdinc -isystem /home/yong/mips/prebuilts/toolchains/mips-gcc472-glibc216/bin/../lib/gcc/mips-linux-gnu/4.7.2/include -pipe  -DCONFIG_MIPS -D__MIPS__ -G 0 -EL -msoft-float -fpic -mabicalls -march=mips32 -mabi=32 -DCONFIG_32BIT -mno-branch-likely   -o start.o start.S -c

mips-linux-gnu-ld.bfd  -G 0 -static -n -nostdlib -EL -m elf32ltsmip -T u-boot.lds --gc-sections -pie -Bstatic -Ttext 0x80100000 arch/mips/cpu/xburst/start.o --start-group api/libapi.o arch/mips/cpu/xburst/libxburst.o arch/mips/cpu/xburst/x1000/libx1000.o arch/mips/lib/libmips.o common/libcommon.o disk/libdisk.o drivers/bios_emulator/libatibiosemu.o drivers/block/libblock.o drivers/crypto/libcrypto.o drivers/dfu/libdfu.o drivers/dma/libdma.o drivers/fpga/libfpga.o drivers/gpio/libgpio.o drivers/hwmon/libhwmon.o drivers/i2c/libi2c.o drivers/input/libinput.o drivers/misc/libmisc.o drivers/mmc/libmmc.o drivers/mtd/libmtd.o drivers/mtd/nand/libnand.o drivers/mtd/onenand/libonenand.o drivers/mtd/spi/libspi_flash.o drivers/mtd/ubi/libubi.o drivers/net/libnet.o drivers/net/phy/libphy.o drivers/pci/libpci.o drivers/pcmcia/libpcmcia.o drivers/power/battery/libbattery.o drivers/power/fuel_gauge/libfuel_gauge.o drivers/power/libpower.o drivers/power/pmic/libpmic.o drivers/pwm/libpwm.o drivers/regulator/libregulator.o drivers/rtc/librtc.o drivers/serial/libserial.o drivers/sound/libsound.o drivers/spi/libspi.o drivers/tpm/libtpm.o drivers/twserial/libtws.o drivers/usb/eth/libusb_eth.o drivers/usb/gadget/libusb_gadget.o drivers/usb/host/libusb_host.o drivers/usb/musb-new/libusb_musb-new.o drivers/usb/musb/libusb_musb.o drivers/usb/phy/libusb_phy.o drivers/usb/ulpi/libusb_ulpi.o drivers/video/libvideo.o drivers/watchdog/libwatchdog.o fs/cbfs/libcbfs.o fs/cramfs/libcramfs.o fs/ext4/libext4fs.o fs/fat/libfat.o fs/fdos/libfdos.o fs/jffs2/libjffs2.o fs/libfs.o fs/reiserfs/libreiserfs.o fs/sandbox/libsandboxfs.o fs/ubifs/libubifs.o fs/yaffs2/libyaffs2.o fs/zfs/libzfs.o lib/libfdt/libfdt.o lib/libgeneric.o lib/lzma/liblzma.o lib/lzo/liblzo.o lib/rsa/librsa.o lib/zlib/libz.o net/libnet.o post/libpost.o test/libtest.o board/ingenic/burner_x1000/libburner_x1000.o --end-group -L /home/yong/mips/prebuilts/toolchains/mips-gcc472-glibc216/bin/../lib/gcc/mips-linux-gnu/4.7.2/soft-float -lgcc -Map u-boot.map -o u-boot
mips-linux-gnu-objcopy -O srec u-boot u-boot.srec
mips-linux-gnu-objcopy --remove-section=.dynsym --gap-fill=0xff -O binary u-boot u-boot.bin

# generate SPL u-boot command
mips-linux-gnu-gcc   -D__ASSEMBLY__ -g  -Os   -ffunction-sections -fdata-sections -D__KERNEL__ -ffunction-sections -fdata-sections -DCONFIG_SYS_TEXT_BASE=0x80100000 -DCONFIG_SPL_TEXT_BASE=0xf4001800 -DCONFIG_SPL_PAD_TO=16384 -DCONFIG_SPL_BUILD -I/home/yong/mips/u-boot/include -fno-builtin -ffreestanding -nostdinc -isystem /home/yong/mips/prebuilts/toolchains/mips-gcc472-glibc216/bin/../lib/gcc/mips-linux-gnu/4.7.2/include -pipe  -DCONFIG_MIPS -D__MIPS__ -G 0 -EL -msoft-float -fno-pic -mno-abicalls -march=mips32 -mabi=32 -DCONFIG_32BIT -mno-branch-likely   -o /home/yong/mips/u-boot/spl/arch/mips/cpu/xburst/x1000/start.o start.S -c

mips-linux-gnu-ld.bfd  -G 0 -static -n -nostdlib -EL -m elf32ltsmip -T /home/yong/mips/u-boot/spl/u-boot-spl.lds --gc-sections --gc-sections -Bstatic -Ttext 0xf4001800 arch/mips/cpu/xburst/x1000/start.o --start-group arch/mips/cpu/xburst/libxburst.o arch/mips/cpu/xburst/x1000/libx1000.o arch/mips/lib/libmips.o board/ingenic/burner_x1000/libburner_x1000.o common/spl/libspl.o drivers/gpio/libgpio.o drivers/serial/libserial.o lib/libgeneric.o tools/ingenic-tools/lib_ddr_params_creator.o --end-group -L /home/yong/mips/prebuilts/toolchains/mips-gcc472-glibc216/bin/../lib/gcc/mips-linux-gnu/4.7.2/soft-float -lgcc -Map u-boot-spl.map -o u-boot-spl

mips-linux-gnu-objcopy --remove-section=.dynsym --gap-fill=0xff -O binary /home/yong/mips/u-boot/spl/u-boot-spl /home/yong/mips/u-boot/spl/u-boot-spl.bin

mips-linux-gnu-objcopy --remove-section=.dynsym --gap-fill=0xff --pad-to=16384 -I binary -O binary spl/u-boot-spl.bin spl/u-boot-spl-pad.bin
cat spl/u-boot-spl-pad.bin u-boot.bin > u-boot-with-spl.bin
rm spl/u-boot-spl-pad.bin


mips-linux-gnu-gcc  -g  -Os   -ffunction-sections -fdata-sections 
-D__KERNEL__ 
-ffunction-sections -fdata-sections 
-DCONFIG_SYS_TEXT_BASE=0x80100000 
-DCONFIG_SPL_TEXT_BASE=0xf4001000 
-DCONFIG_SPL_PAD_TO=12288 
-DCONFIG_SPL_BUILD 
-I/home/yong/mips/u-boot/include 
-fno-builtin -ffreestanding -nostdinc 
-isystem /home/yong/mips/prebuilts/toolchains/mips-gcc472-glibc216/bin/../lib/gcc/mips-linux-gnu/4.7.2/include -pipe  
-DCONFIG_MIPS 
-D__MIPS__ -G 0 -EL -msoft-float -fno-pic -mno-abicalls -march=mips32r2 -mabi=32 
-DCONFIG_32BIT -mno-branch-likely 
-Wall -Wstrict-prototypes -fno-stack-protector -Wno-format-nonliteral -Wno-format-security -fstack-usage     
-o /home/yong/mips/u-boot/spl/arch/mips/cpu/xburst/x1000/soc.o soc.c -c


mips-linux-gnu-objdump -D -m mips -b binary  u-boot-with-spl.bin

# SD boot 
CROSS_COMPILE=mips-linux-gnu- make phoenix_v10_uImage_msc0  V=1

/home/yong/mips/u-boot/tools/ingenic-tools/gpt_creator  "/home/yong/mips/u-boot/board/ingenic/phoenix"/partitions.tab mbr-of-gpt.bin gpt.bin
mips-linux-gnu-objcopy --remove-section=.dynsym --gap-fill=0xff --pad-to=12288 -I binary -O binary spl/u-boot-spl.bin spl/u-boot-spl-pad.bin
cat spl/u-boot-spl-pad.bin u-boot.bin > u-boot-with-spl.bin
cat tools/ingenic-tools/mbr-gpt.bin u-boot-with-spl.bin > u-boot-with-spl-mbr-gpt.bin


# burner boot log

CROSS_COMPILE=mips-linux-gnu- make burner_x1000_lpddr V=1

 preloader_console_init U-Boot SPL 2013.07-00002-gfcf43c7-dirty (Oct 22 2016 - 15:54:31)
apll = 576000000
 mpll = 600000000
cpccr = 95752210
CLK init
SDRAM init
run firmware finished

U-Boot 2013.07-00002-gfcf43c7-dirty (Oct 22 2016 - 15:54:31)

Board: burner_x1000 (Ingenic XBurst X1000 SoC)
DRAM:  32 MiB
board_init_f Top of RAM usable for U-Boot at: 82000000
Reserving 4642k for U-Boot at: 81b74000
Reserving 16384k for malloc() at: 80b73e00
Reserving 32 Bytes for Board Info at: 80b73de0
Reserving 124 Bytes for Global Data at: 80b73d64
Reserving 128k for boot params() at: 80b53d64
Stack Pointer at: 80b53d48
Now running in RAM - U-Boot at: 81b74000
NAND:  0 MiB
MMC:   board.c-board_mmc_init
jz_mmc_init_one(0, 0, b3450000, 5)
msc: 0
Using default environment

In:    serial
Out:   serial
Err:   serial
SPI:   this will be an error that the ssi rate is 0
ready
USB_udc_probe
jz_dwc2_udc_v1.1
Hit any key to stop autoboot:  0
usb_gadget_register_driver 81bc6d58
extend policy manager register
expy efuse register
expy file register
expy test register
burner_x1000# cloner->full_size = 393b4
MMC write: dev # 0, block # 0, count 128 ...

vendor=[Man 000002 Snr 03efb000] product=[SA08G] revison=[2.4]

mmc_init: 0, time 303
128 blocks write: OK
MMC write: dev # 0, block # 128, count 128 ...
128 blocks write: OK
MMC write: dev # 0, block # 256, count 128 ...
128 blocks write: OK
MMC write: dev # 0, block # 384, count 74 ...
74 blocks write: OK
reset in 4ms
U-Boot SPL 2013.07-00045-gf117c74-dirty (Oct 17 2016 - 16:45:28)
ERROR EPC 81b746e8
Timer init
CLK stop
PLL init
CPM_CPAPCR:a9008520
CPM_CPMPCR:98000083
CPM_CPCCR:9a052210
CLK init
SDRAM init
sdram init start
controller_reset_phy enter.
ddr_phy_init enter.
ddr_phy_param_config enter.
ddr_phy_init_dram enter.
DDRP_PGSR:00000006
ddr_training_hardware enter.
DTDR0-1: dd22ee11 7788bb44
DDRP_PGSR:0000000e
ddr_controller_init enter.
DDRC_STATUS: 80000003
DDRC_DLP:0000f003
sdram init finished
soc.c-board_init_f
>>spl:board_init_r()
SPL:boot device - 7
SPL: Jumping to U-Boot
image entry point: 0x80100000


U-Boot 2013.07-00045-gf117c74-dirty (Oct 17 2016 - 16:45:28)

Board: Halley2 (Ingenic XBurst X1000 SoC)
DRAM: board_type=0 32 MiB
Top of RAM usable for U-Boot at: 82000000
Reserving 0k for U-Boot at: 81fc6000
Reserving 412k for U-Boot at: 81f5c000
Reserving 8196k for malloc() at: 8175b000
Reserving 32 Bytes for Board Info at: 8175afe0
Reserving 128 Bytes for Global Data at: 8175af60
Reserving 128k for boot params() at: 8173af60
Stack Pointer at: 8173af48
Now running in RAM - U-Boot at: 81f5c000
MMC:   jz_mmc_init
msc: 0
set quad mode is enable.the buf = 2
*** Warning - bad CRC, using default environment

pixel_clock = 6912
gpio_request lable = lcd_cs gpio = 50
gpio_request lable = lcd_rd gpio = 48
gpio_request lable = lcd_rst gpio = 96
gpio_request lable = lcd_bl gpio = 97
truly_tft240240_2_e panel display pin init
truly_tft240240_2_e panel display on
dump_lcdc_registers
the slcd slcd_cfg_new is 00000100
dump_lcdc_registers
Net:   =======>MacBase = 0xb34b0000, DmaBase = 0xb34b1000 PhyBase = 0x00000000
GMAC-9162
Hit any key to stop autoboot:  0
halley2-sfcnor#

# SD boot log 
U-Boot SPL 2013.07-00046-ga7e31a9-dirty (Oct 20 2016 - 15:19:26)
ERROR EPC 81f6de18
Timer init
CLK stop
PLL init
CPM_CPAPCR:a9008520
CPM_CPMPCR:98000083
CPM_CPCCR:9a052210
CLK init
SDRAM init
sdram init start
controller_reset_phy enter.
ddr_phy_init enter.
ddr_phy_param_config enter.
ddr_phy_init_dram enter.
DDRP_PGSR:00000006
ddr_training_hardware enter.
DTDR0-1: dd22ee11 7788bb44
DDRP_PGSR:0000000e
ddr_controller_init enter.
DDRC_STATUS: 80000003
DDRC_DLP:0000f003
sdram init finished
soc.c-board_init_f
>>spl:board_init_r()
SPL:boot device - 0
SPL: Jumping to U-Boot
image entry point: 0x80100000


U-Boot 2013.07-00046-ga7e31a9-dirty (Oct 20 2016 - 15:19:26)

Board: Phoenix (Ingenic XBurst X1000 SoC)
DRAM: board_type=0 32 MiB
Top of RAM usable for U-Boot at: 82000000
Reserving 0k for U-Boot at: 81fc6000
Reserving 409k for U-Boot at: 81f5c000
Reserving 8224k for malloc() at: 81754000
Reserving 32 Bytes for Board Info at: 81753fe0
Reserving 128 Bytes for Global Data at: 81753f60
Reserving 128k for boot params() at: 81733f60
Stack Pointer at: 81733f48
Now running in RAM - U-Boot at: 81f5c000
gpio_request lable = soft_i2c gpio = 90
gpio_request lable = soft_i2c gpio = 91
i2c probe:1, addr:32
probe richo61x error, i2c addr ox32
MMC:   jz_mmc_init
msc: 0
*** Warning - bad CRC, using default environment

pixel_clock = 6912
gpio_request lable = lcd_cs gpio = 50
gpio_request lable = lcd_rd gpio = 48
gpio_request lable = lcd_rst gpio = 96
gpio_request lable = lcd_bl gpio = 97
truly_tft240240_2_e panel display pin init
truly_tft240240_2_e panel display on
dump_lcdc_registers
the slcd slcd_cfg_new is 00000100
dump_lcdc_registers
Net:   =======>MacBase = 0xb34b0000, DmaBase = 0xb34b1000 PhyBase = 0x00000000
GMAC-9162
Hit any key to stop autoboot:  0
phoenix-msc0#
phoenix-msc0# version

U-Boot 2013.07-00046-ga7e31a9-dirty (Oct 20 2016 - 15:19:26)
mips-linux-gnu-gcc (Ingenic 2015.02) 4.7.2
GNU ld (Ingenic 2015.02) 2.24.51.20140512
phoenix-msc0# printenv
baudrate=115200
bootargs=console=ttyS2,115200n8 mem=32M@0x0 loglevel=7  root=/dev/mmcblk0p7 rootfstype=ext4 rootdelay=1 rw
bootcmd=mmc dev 0;mmc read 0x80600000 0x1800 0x3000; bootm 0x80600000
bootdelay=1
ethact=GMAC-9162
ethaddr=00:11:22:33:44:55
gatewayip=192.168.4.1
ipaddr=192.168.4.90
loads_echo=1
netmask=255.255.255.0
serverip=192.168.4.13

Environment size: 370/32764 bytes
phoenix-msc0# 
 
# MSC0 boot log
phoenix-msc0#
U-Boot SPL 2013.07 (Sep 29 2016 - 17:38:05)
apll = 1008000000
 mpll = 600000000
cpccr = 9a752210


U-Boot 2013.07 (Sep 29 2016 - 17:38:05)

Board: Phoenix (Ingenic XBurst X1000 SoC)
DRAM:  32 MiB
Top of RAM usable for U-Boot at: 82000000
Reserving 0k for U-Boot at: 81fc6000
Reserving 409k for U-Boot at: 81f5c000
Reserving 8224k for malloc() at: 81754000
Reserving 32 Bytes for Board Info at: 81753fe0
Reserving 128 Bytes for Global Data at: 81753f60
Reserving 128k for boot params() at: 81733f60
Stack Pointer at: 81733f48
Now running in RAM - U-Boot at: 81f5c000
gpio_request lable = soft_i2c gpio = 90
gpio_request lable = soft_i2c gpio = 91
i2c probe:1, addr:32
probe richo61x error, i2c addr ox32
MMC:   msc: 0
*** Warning - bad CRC, using default environment

pixel_clock = 6912
gpio_request lable = lcd_cs gpio = 50
gpio_request lable = lcd_rd gpio = 48
gpio_request lable = lcd_rst gpio = 96
gpio_request lable = lcd_bl gpio = 97
truly_tft240240_2_e panel display pin init
truly_tft240240_2_e panel display on
dump_lcdc_registers
the slcd slcd_cfg_new is 00000100
dump_lcdc_registers
Net:   =======>MacBase = 0xb34b0000, DmaBase = 0xb34b1000 PhyBase = 0x00000000
GMAC-9162
Hit any key to stop autoboot:  0
phoenix-msc0# version

U-Boot 2013.07 (Sep 29 2016 - 17:38:05)
mips-linux-gnu-gcc (Ingenic 2015.02) 4.7.2
GNU ld (Ingenic 2015.02) 2.24.51.20140512
phoenix-msc0# printenv
baudrate=115200
bootargs=console=ttyS2,115200n8 mem=31M@0x0  root=/dev/mmcblk0p7 rootfstype=ext4 rootdelay=1 rw
bootcmd=mmc dev 0;mmc read 0x80600000 0x1800 0x3000; bootm 0x80600000
bootdelay=1
ethact=GMAC-9162
ethaddr=00:11:22:33:44:55
gatewayip=192.168.4.1
ipaddr=192.168.4.90
loads_echo=1
netmask=255.255.255.0
serverip=192.168.4.13

Environment size: 359/32764 bytes
phoenix-msc0#
 
 
baudrate=115200
bootargs=console=ttyS2,115200n8 mem=31M@0x0 ip=off rootfstype=ext4 root=/dev/mmcblk0p2 rootwait rw debug
bootargs-nfs=console=ttyS2,115200n8 mem=31M@0x0 ip=dhcp root=/dev/nfs rw nfsroot=192.168.0.71:/home/yong/mips/rootfs debug
bootargs-tf=console=ttyS2,115200n8 mem=31M@0x0 ip=off rootfstype=ext4 root=/dev/mmcblk0p2 rootwait rw
bootcmd=sfcnor read 0x40000 0x3c0000 0x80800000 ;bootm 0x80800000
bootdelay=1
ethact=GMAC-9162
ethaddr=00:11:22:33:44:55
gatewayip=192.168.4.1
ipaddr=192.168.4.90
loads_echo=1
netmask=255.255.255.0
serverip=192.168.4.13



