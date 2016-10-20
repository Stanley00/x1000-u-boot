export PATH=/usr/lib/ccache:/home/yong/mips/prebuilts/toolchains/mips-gcc472-glibc216/bin:$PATH

make distclean

time CROSS_COMPILE=mips-linux-gnu- make halley2_v10_uImage_sfc_nor -j4 V=1

time make halley2_v10_uImage_sfc_nor -j8 V=1

CROSS_COMPILE="ccache /home/yong/poky/build/tmp/sysroots/x86_64-linux/usr/bin/mipsel-poky-linux/mipsel-poky-linux-" make V=1

 mips-linux-gnu-objdump -D -m mips -b binary  u-boot-with-spl.bin

CROSS_COMPILE=mips-linux-gnu- make phoenix_v10_uImage_msc0  V=1
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



