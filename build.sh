#!/usr/bin/env bash

DRONE_HOME="${DRONE_HOME:=/drone/src}"
DRONE_INSTALL="${DRONE_INSTALL:=$DRONE_HOME/install}"
DRONE_DIST="${DRONE_DIST:=$DRONE_HOME/dist}"
COMPILER_CC="${COMPILER_CC:=arm-rpi-linux-gnueabihf-gcc -march=armv7-a}"
COMPILER_CXX="${COMPILER_CXX:=arm-rpi-linux-gnueabihf-g++ -march=armv7-a}"
COMPILER_ARM_FPU="${COMPILER_ARM_FPU:=vfpv3}"
NODE_ARM_VERSION="${NODE_ARM_VERSION:=7}"

cd $DRONE_HOME
# download and extract version tarball
wget -q https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz
tar xJf node-v$NODE_VERSION.tar.xz
cd $DRONE_HOME/node-v$NODE_VERSION

# build
CC="$COMPILER_CC" CXX="$COMPILER_CXX" CC_host="gcc -m32" CXX_host="g++ -m32" ./configure  --prefix=node-v$NODE_VERSION --dest-cpu=arm --cross-compiling --dest-os=linux --with-arm-float-abi=hard --with-arm-fpu=$COMPILER_ARM_FPU

make -j 8
make install DESTDIR=$DRONE_INSTALL PORTABLE=1
tar -zcf $DRONE_DIST/node-v$NODE_VERSION-linux-armv$NODE_ARM_VERSION.tar.gz -C $DRONE_INSTALL node-v$NODE_VERSION
