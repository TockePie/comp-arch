#!/bin/bash
set -e

apt-get update
apt-get install -y \
    git \
    vim \
    tree \
    curl \
    ccache \
    wget \
    make \
    libncurses-dev \
    libssl-dev \
    bc \
    bison \
    flex \
    xz-utils \
    gcc-9 \
    libgnutls28-dev \
    g++ \
    libmpc-dev \
    libmpfr-dev \
    libgmp-dev \
    gcc-arm-linux-gnueabihf \
    g++-arm-linux-gnueabihf \
    bzip2 \
    kmod \
    qemu-system-arm \
    cpio

update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 9

git config --global user.name "Lab3 User"
git config --global user.email "lab3@example.com"

ccache -M 5G



mkdir -p /workspace/repos
cd /workspace/repos

EABI_ARCHIVE=gcc-arm-8.3-2019.03-x86_64-arm-eabi.tar.xz
GNUEABI_ARCHIVE=gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf.tar.xz

if [ ! -d "/opt/gcc-arm-8.3-2019.03-x86_64-arm-eabi" ]; then
    if [ ! -f "$EABI_ARCHIVE" ]; then
        wget https://developer.arm.com/-/media/Files/downloads/gnu-a/8.3-2019.03/binrel/$EABI_ARCHIVE
    fi
    tar xJvf $EABI_ARCHIVE -C /opt/
fi

if [ ! -d "/opt/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf" ]; then
    if [ ! -f "$GNUEABI_ARCHIVE" ]; then
        wget https://developer.arm.com/-/media/Files/downloads/gnu-a/8.3-2019.03/binrel/$GNUEABI_ARCHIVE
    fi
    tar xJvf $GNUEABI_ARCHIVE -C /opt/
fi



if [ ! -d "u-boot" ]; then
    git clone https://gitlab.denx.de/u-boot/u-boot.git
fi

cd /workspace/repos/u-boot

LAST_TAG=$(git tag | grep -v rc | tail -n 1)
git checkout "$LAST_TAG"

curl https://patchwork.ozlabs.org/series/130450/mbox/ | git am



cd /workspace/repos

if [ ! -d "linux-stable" ]; then
    git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
fi

cd /workspace/repos/linux-stable
git checkout linux-4.19.y



cd /workspace/repos

if [ ! -d "busybox" ]; then
    git clone git://git.busybox.net/busybox
fi

cd /workspace/repos/busybox
git checkout 1_31_stable



cd /workspace/repos

exec bash
