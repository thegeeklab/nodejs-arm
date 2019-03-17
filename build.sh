#!/usr/bin/env bash
set -o pipefail
set -o errtrace
set -o nounset
set -o errexit

DRONE_HOME=/drone/src
DRONE_INSTALL="${DRONE_INSTALL:=$DRONE_HOME/install}"
DRONE_DIST="${DRONE_DIST:=$DRONE_HOME/dist}"
COMPILER_CC="${COMPILER_CC:=arm-rpi-linux-gnueabihf-gcc -march=armv7-a}"
COMPILER_CXX="${COMPILER_CXX:=arm-rpi-linux-gnueabihf-g++ -march=armv7-a}"
COMPILER_ARM_FPU="${COMPILER_ARM_FPU:=vfpv3}"
NODE_ARM_VERSION="${NODE_ARM_VERSION:=7}"

mkdir -p $DRONE_INSTALL
mkdir -p $DRONE_DIST

# download and extract version tarball
curl https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz -o $DRONE_HOME/node.tar.xz -s
tar xJf $DRONE_HOME/node.tar.xz -C $DRONE_HOME
cd $DRONE_HOME/node-v$NODE_VERSION

# build
CC="${COMPILER_CC}" CXX="${COMPILER_CXX}" CC_host="gcc -m32" CXX_host="g++ -m32" ./configure  --prefix=/node-v$NODE_VERSION --dest-cpu=arm --cross-compiling --dest-os=linux --with-arm-float-abi=hard --with-arm-fpu=$COMPILER_ARM_FPU

make -j 8
make install DESTDIR="${DRONE_INSTALL}" PORTABLE=1
tar -zcf $DRONE_DIST/node-v$NODE_VERSION-linux-armv$NODE_ARM_VERSION.tar.gz -C $DRONE_INSTALL node-v$NODE_VERSION

# create release notes file
cat >$DRONE_HOME/NOTE.md <<EOF
Target system:
- ARM_VERSION=\`${NODE_ARM_VERSION}\`
- ARM_FPU=\`${COMPILER_ARM_FPU}\`

Compiler options:
- CC=\`${COMPILER_CC}\`
- CXX=\`${COMPILER_CXX}\`
EOF
