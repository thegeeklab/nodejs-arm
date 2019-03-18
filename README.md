# nodejs-arm

Node.js 10.x and higher requires as minimum GCC 4.9.4 but old stable distributions like CentOS 7 are still on 4.8.x. The pre-build Node.js ARM packages are cross compiled compiled with
Debian and a 4.9.x compiler, so they wont work on all target systems.

To get Node.js running on a Raspberry Pi (or other ARM devieses) running CentOS 7 you need to compile Node with GCC 4.9.x and a static libstdc++. You can do so by adding `-static-libstdc++` to the compiler command.

This repository automates the build process with Drone CI and append the release package to a github release. The docker image used for cross compiling can be found [here](https://hub.docker.com/r/xoxys/cc-arm)

You can download and use these packages the same way as the official Node.js packages.
