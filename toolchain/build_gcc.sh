#!/bin/bash
set -e

_LIBTAPI_VERSION=1100.0.11
_GCC_TRIPLE=arm64-apple-darwin22

ln -s /osxcross/SDK/MacOSX13.sdk/ /sdk

# git clone https://github.com/tpoechtrager/xar /xar-src && \
#     cd /xar-src/xar && \
#     mkdir /libxar && \
#     CFLAGS+=" -w" ./configure --prefix=/libxar && \
#     make -j && \
#     make install

# git clone --branch $_LIBTAPI_VERSION https://github.com/tpoechtrager/apple-libtapi /apple-libtapi && \
#     cd /apple-libtapi && \
#     INSTALLPREFIX=/libtapi ./build.sh && \
#     INSTALLPREFIX=/libtapi ./install.sh

git clone --depth=1 https://github.com/iains/gcc-12-branch /gcc-12-branch && \
    mkdir -p /gcc-12-branch/build && \
    ldconfig && \
    cd /gcc-12-branch/build && \
    ../configure \
        --target=$_GCC_TRIPLE \
        --with-sysroot="/osxcross/SDK/MacOSX13.sdk" \
        --disable-nls \
        --enable-languages=c,c++,fortran,objc,obj-c++ \
        --without-headers \
        --enable-lto \
        --enable-checking=release \
        --disable-libstdcxx-pch \
        --prefix=/gcc \
        --with-system-zlib \
        --disable-multilib \
        --with-ld=/osxcross/bin/$_GCC_TRIPLE-ld \
        --with-as=/osxcross/bin/$_GCC_TRIPLE-as
    make -j4 && \
    make install

