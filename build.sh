#!/usr/bin/env bash

mkdir install

# download and extract version tarball
wget https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz
tar xvJf node-v$NODE_VERSION.tar.xz
cd node-v$NODE_VERSION

# build
./configure --prefix ../install
make
make install

ls -l ../install
