#!/usr/bin/env bash

yum install epel-release -y
yum groupinstall 'Development Tools' -y
yum install wget git which make cmake automake autoconf glibc-devel.i686 libstdc++.i686 libgcc.i686 -y

mkdir -p $HOME/bin/arm-none-eabi-gcc/
wget https://github.com/gnu-mcu-eclipse/arm-none-eabi-gcc/releases/download/v8.2.1-1.4/gnu-mcu-eclipse-arm-none-eabi-gcc-8.2.1-1.4-20190214-0604-centos32.tgz -q
tar -C $HOME/bin/arm-none-eabi-gcc/ -xzf gnu-mcu-eclipse-arm-none-eabi-gcc-8.2.1-1.4-20190214-0604-centos32.tgz --strip-components 3
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
