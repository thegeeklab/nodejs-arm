#!/usr/bin/env bash

# yum install epel-release -y
# yum groupinstall 'Development Tools' -y
# yum install wget git which make cmake automake autoconf glibc-devel.i686 libstdc++.i686 libgcc.i686 -y
# # yum install wget git which -y

# mkdir -p $HOME/compiler/
# cd $HOME/compiler/
# git clone https://github.com/rvagg/rpi-newer-crosstools .
# export PATH=$HOME/compiler/x64-gcc-4.9.4-binutils-2.28/arm-rpi-linux-gnueabihf/bin:$PATH

# # ls -l $HOME/bin/arm-none-eabi-gcc/
# which arm-rpi-linux-gnueabihf-gcc
# which arm-rpi-linux-gnueabihf-g++

# arm-rpi-linux-gnueabihf-gcc --verbose

cd
mkdir install
mkdir dist
echo "testfile" dist/test.txt

# # download and extract version tarball
# wget -q https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz
# tar xJf node-v$NODE_VERSION.tar.xz
# cd node-v$NODE_VERSION

# # build
# CC="arm-rpi-linux-gnueabihf-gcc -march=armv7-a" CXX="arm-rpi-linux-gnueabihf-g++ -march=armv7-a" CC_host="gcc -m32" CXX_host="g++ -m32" ./configure --prefix=../install --dest-cpu=arm --cross-compiling --dest-os=linux --with-arm-float-abi=hard --with-arm-fpu=neon
# make -j 8
# make install

# cd ../install
# ls -l
# tar -zcvf ../dist/node-v$NODE_VERSION-linux-armv7.tar.gz .

# ls -l ../dist
