#!/usr/bin/env bash

export DRONE_HOME=/drone/src
mkdir -p $DRONE_HOME/compiler/
mkdir $DRONE_HOME/install
mkdir $DRONE_HOME/dist

yum install epel-release -y
yum groupinstall 'Development Tools' -y
yum install wget git which make cmake automake autoconf glibc-devel.i686 libstdc++.i686 libgcc.i686 -y

cd $DRONE_HOME/compiler/
# git clone https://github.com/rvagg/rpi-newer-crosstools .
# export PATH=$DRONE_HOME/compiler/x64-gcc-4.9.4-binutils-2.28/arm-rpi-linux-gnueabihf/bin:$PATH
git clone https://github.com/MatteoRagni/arm-rpi-linux-gnueabi-toolchain .
export PATH=$DRONE_HOME/compiler/arm-rpi-linux-gnueabi/bin:$PATH



# ls -l $HOME/bin/arm-none-eabi-gcc/
# which arm-rpi-linux-gnueabihf-gcc
# which arm-rpi-linux-gnueabihf-g++

# arm-rpi-linux-gnueabihf-gcc --verbose

cd $DRONE_HOME
# download and extract version tarball
wget -q https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz
tar xJf node-v$NODE_VERSION.tar.xz
cd $DRONE_HOME/node-v$NODE_VERSION

# build
# CC="arm-rpi-linux-gnueabihf-gcc -march=armv7-a" CXX="arm-rpi-linux-gnueabihf-g++ -march=armv7-a" CC_host="gcc -m32" CXX_host="g++ -m32" ./configure --prefix=$DRONE_HOME/install --dest-cpu=arm --cross-compiling --dest-os=linux --with-arm-float-abi=hard --with-arm-fpu=neon
CC="arm-linux-gnueabihf-gcc -march=armv7-a" CXX="arm-linux-gnueabihf-g++ -march=armv7-a" CC_host="gcc -m32" CXX_host="g++ -m32" ./configure --prefix=node-v$NODE_VERSION --dest-cpu=arm --cross-compiling --dest-os=linux --with-arm-float-abi=hard --with-arm-fpu=neon

make -j 8
make install DESTDIR=$DRONE_HOME/install/ PORTABLE=1
tar -zcf $DRONE_HOME/dist/node-v$NODE_VERSION-linux-armv7l.tar.gz $DRONE_HOME/install/node-v$NODE_VERSION
ls -l $DRONE_HOME/dist
