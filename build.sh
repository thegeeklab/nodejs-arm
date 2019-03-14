#!/usr/bin/env bash

# yum install epel-release -y
# yum groupinstall 'Development Tools' -y
# yum install wget git which make cmake automake autoconf glibc-devel.i686 libstdc++.i686 libgcc.i686 -y
yum install wget git which

mkdir -p $HOME/compiler/
cd $HOME/compiler/
git clone https://github.com/raspberrypi/tools .
export PATH=$HOME/compiler/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin:$PATH

# ls -l $HOME/bin/arm-none-eabi-gcc/
which arm-linux-gnueabihf-gcc
which arm-linux-gnueabihf-g++

arm-linux-gnueabihf-gcc --verbose

# mkdir install

# # download and extract version tarball
# wget -q https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz
# tar xJf node-v$NODE_VERSION.tar.xz
# cd node-v$NODE_VERSION

# # build
# CC=arm-none-eabi-gcc CXX=arm-none-eabi-g++ CC_host="gcc -m32" CXX_host="g++ -m32" ./configure --prefix=../install --dest-cpu=arm --cross-compiling --dest-os=linux --with-arm-float-abi=hard --with-arm-fpu=neon
# make -j4
# make install

# ls -l ../install
