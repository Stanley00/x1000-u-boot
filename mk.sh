make distclean
time make halley2_v10_uImage_sfc_nor -j8 V=1

CROSS_COMPILE="ccache /home/yong/poky/build/tmp/sysroots/x86_64-linux/usr/bin/mipsel-poky-linux/mipsel-poky-linux-" make V=1

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



