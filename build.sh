#!/usr/bin/env bash

yum install epel-release -y
yum groupinstall 'Development Tools' -y
yum install wget git which make cmake automake autoconf glibc-devel.i686 libstdc++.i686 libgcc.i686 -y
# yum install wget git which -y

mkdir -p $HOME/compiler/
cd $HOME/compiler/
git clone https://github.com/rvagg/rpi-newer-crosstools .
export PATH=$HOME/compiler/x64-gcc-4.9.4-binutils-2.28/arm-rpi-linux-gnueabihf/bin:$PATH

# ls -l $HOME/bin/arm-none-eabi-gcc/
which arm-rpi-linux-gnueabihf-gcc
which arm-rpi-linux-gnueabihf-g++

arm-rpi-linux-gnueabihf-gcc --verbose

cd
mkdir install

# download and extract version tarball
wget -q https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz
tar xJf node-v$NODE_VERSION.tar.xz
cd node-v$NODE_VERSION

# build
CC=arm-rpi-linux-gnueabihf-gcc CXX=arm-rpi-linux-gnueabihf-g++ CCFLAGS="-march=armv7-a" CXXFLAGS="-march=armv7-a"  CC_host="gcc -m32" CXX_host="g++ -m32" ./configure --prefix=../install --dest-cpu=arm --cross-compiling --dest-os=linux --with-arm-float-abi=hard --with-arm-fpu=neon
# make --j
# make install

ls -l ../install
