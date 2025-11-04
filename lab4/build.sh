#!/bin/bash
set -e

# U-Boot
cd /workspace/repos/u-boot

export PATH=/opt/gcc-arm-8.3-2019.03-x86_64-arm-eabi/bin:$PATH
export CROSS_COMPILE='ccache arm-eabi-'
export ARCH=arm

make am335x_boneblack_defconfig

make -j4



# Linux kernel
cd /workspace/repos/linux-stable

export PATH=/opt/gcc-arm-8.3-2019.03-x86_64-arm-eabi/bin:$PATH
export CROSS_COMPILE='ccache arm-eabi-'
export ARCH=arm

mkdir -p fragments

cat > fragments/bbb.cfg <<'EOF'
# Use multi_v7_defconfig as a base for merge_config.sh
# --- USB ---
# Enable USB on BBB (AM335x)
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_AM335X_PHY_USB=y
CONFIG_USB_MUSB_TUSB6010=y
CONFIG_USB_MUSB_OMAP2PLUS=y
CONFIG_USB_MUSB_HDRC=y
CONFIG_USB_MUSB_DSPS=y
CONFIG_USB_MUSB_AM35X=y
CONFIG_USB_CONFIGFS=y
CONFIG_NOP_USB_XCEIV=y
# For USB keyboard and mouse
CONFIG_USB_HID=y
CONFIG_USB_HIDDEV=y
# For PL2303, FTDI, etc
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_PL2303=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_SIMPLE=y
CONFIG_USB_SERIAL_FTDI_SIO=y
# For USB mass storage devices (like flash USB stick)
CONFIG_USB_ULPI=y
CONFIG_USB_ULPI_BUS=y
# --- Networking ---
CONFIG_BRIDGE=y
# --- Device Tree Overlays (.dtbo support) ---
CONFIG_OF_OVERLAY=y
EOF

./scripts/kconfig/merge_config.sh \
arch/arm/configs/multi_v7_defconfig fragments/bbb.cfg

make -j4 zImage modules am335x-boneblack.dtb



# Busybox
cd /workspace/repos/busybox

export ARCH=arm
export PATH=/opt/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin:$PATH
export CROSS_COMPILE="ccache arm-linux-gnueabihf-"

make defconfig

make -j4

make install

mkdir -p _install/{boot,dev,etc\/init.d,lib,proc,root,sys\/kernel\/debug,tmp}
mkdir -p _install/etc/init.d

cat > _install/etc/init.d/rcS << 'EOF'
#!/bin/sh
mount -t sysfs none /sys
mount -t proc none /proc
mount -t debugfs none /sys/kernel/debug
echo /sbin/mdev > /proc/sys/kernel/hotplug
mdev -s
EOF

chmod +x _install/etc/init.d/rcS
ln -s bin/busybox _install/init

INST_DIR="/workspace/repos/linux-stable"
cd _install/boot
cp ${INST_DIR}/arch/arm/boot/zImage .
cp ${INST_DIR}/arch/arm/boot/dts/am335x-boneblack.dtb .
cp ${INST_DIR}/System.map .
cp ${INST_DIR}/.config ./config
cd -

cd /workspace/repos/linux-stable
export INSTALL_MOD_PATH=/workspace/repos/busybox/_install
export ARCH=arm
make modules_install
cd -

${CROSS_COMPILE}readelf -d _install/bin/busybox | grep NEEDED

cd _install/lib
libc_dir=$(${CROSS_COMPILE}gcc -print-sysroot)/lib
cp -a $libc_dir/*.so* .
cd -

echo '$MODALIAS=.* root:root 660 @modprobe "$MODALIAS"' > \
_install/etc/mdev.conf

echo 'root:x:0:' > _install/etc/group
echo 'root:x:0:0:root:/root:/bin/sh' > _install/etc/passwd
echo 'root::10933:0:99999:7:::' > _install/etc/shadow
echo "nameserver 8.8.8.8" > _install/etc/resolv.conf



# Flashing
cd /workspace/repos/busybox
cd _install
find . | cpio -o -H newc | gzip > ../rootfs.cpio.gz
cd ..

#  Run the kernel
qemu-system-arm -kernel _install/boot/zImage -initrd rootfs_new.cpio.gz \
-machine virt -nographic -m 512 \
--append "root=/dev/ram0 rw console=ttyAMA0,115200 mem=512M"
