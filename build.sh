#!/usr/bin/env bash

yum install epel-release -y
yum groupinstall 'Development Tools' -y
yum install wget git bunzip2 which make cmake automake autoconf glibc-devel.i686 libstdc++.i686 libgcc.i686 -y

mkdir -p $HOME/bin/arm-none-eabi-gcc/
wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/6-2017q2/gcc-arm-none-eabi-6-2017-q2-update-linux.tar.bz2
bunzip2 gcc-arm-none-eabi-6-2017-q2-update-linux.tar.bz2
tar -C $HOME/bin/arm-none-eabi-gcc/ -xvf gcc-arm-none-eabi-6-2017-q2-update-linux.tar --strip-components 1
chmod -R -w $HOME/bin/arm-none-eabi-gcc/
export PATH=$HOME/bin/arm-none-eabi-gcc/bin:$PATH

# ls -l $HOME/bin/arm-none-eabi-gcc/
which arm-none-eabi-gcc
which arm-none-eabi-g++

mkdir install

# download and extract version tarball
wget -q https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz
tar xJf node-v$NODE_VERSION.tar.xz
cd node-v$NODE_VERSION

# build
CC=arm-none-eabi-gcc CXX=arm-none-eabi-g++ CC_host="gcc -m32" CXX_host="g++ -m32" ./configure --prefix=../install --dest-cpu=arm --cross-compiling --dest-os=linux --with-arm-float-abi=hard --with-arm-fpu=neon
make -j4
make install

ls -l ../install
