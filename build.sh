#!/usr/bin/env bash

yum install epel-release -y
yum groupinstall 'Development Tools' -y
yum install wget git which make cmake gcc gcc-c++ automake autoconf binutils-arm-linux-gnu glibc-devel.i686 libstdc++.i686 gcc-arm-linux-gnu gcc-c++-arm-linux-gnu libgcc.i686 -y

mkdir install

# download and extract version tarball
wget -q https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz
tar xJf node-v$NODE_VERSION.tar.xz
cd node-v$NODE_VERSION

# build
CC=arm-linux-gnueabihf-gcc CXX=arm-linux-gnueabihf-g++ CC_host="gcc -m32" CXX_host="g++ -m32" ./configure --prefix=../install --dest-cpu=arm --cross-compiling --dest-os=linux --with-arm-float-abi=hard --with-arm-fpu=neon
make
make install

ls -l ../install
