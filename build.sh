#!/usr/bin/env bash

yum install epel-release -y
yum groupinstall 'Development Tools' -y
yum install wget git which make cmake gcc gcc-c++ automake autoconf binutils-arm-linux-gnu glibc-devel.i686 libstdc++.i686 gcc-c++-arm-linux-gnu libgcc.i686 -y

mkdir $HOME/bin/arm-none-eabi-gcc/
wget https://github.com/gnu-mcu-eclipse/arm-none-eabi-gcc/releases/download/v8.2.1-1.4/gnu-mcu-eclipse-arm-none-eabi-gcc-8.2.1-1.4-20190214-0604-centos32.tgz
tar -C $HOME/bin/arm-none-eabi-gcc/ -xzf gnu-mcu-eclipse-arm-none-eabi-gcc-8.2.1-1.4-20190214-0604-centos32.tgz --strip-components 3
chmod -R -w $HOME/bin/arm-none-eabi-gcc/
export PATH=$HOME/bin/arm-none-eabi-gcc:$PATH

ls -l $HOME/bin/arm-none-eabi-gcc/
which arm-none-eabi-gcc

# mkdir install

# # download and extract version tarball
# wget -q https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz
# tar xJf node-v$NODE_VERSION.tar.xz
# cd node-v$NODE_VERSION

# # build
# CC=arm-linux-gnu-gcc CXX=arm-linux-gnu-g++ CC_host="gcc -m32" CXX_host="g++ -m32" ./configure --prefix=../install --dest-cpu=arm --cross-compiling --dest-os=linux --with-arm-float-abi=hard --with-arm-fpu=neon
# make -j4
# make install

# ls -l ../install
