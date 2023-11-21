#!/bin/sh

# pkg-config wrapper script for macOS cross compilation (x86_64).
#
# pkgconfig .pc files are found in two locations:
# * /macos/usr/lib/pkgconfig for Autobrew libs
# * /opt/R/x86_64/lib/pkgconfig for CRAN's macOS libs
# * /osxcross/macports/pkgs/opt/local for osxcross's MacPorts libs
#
# New pkg-config search directories should be added to PKG_CONFIG_LIBDIR here (colon-separated).
#
# Neither of these variables should be set:
# * PKG_CONFIG_PATH: keeps Linux host pkg-config dir on search path, which will cause issues
# * PKG_CONFIG_SYSROOT_DIR: unnecessary with PKG_CONFIG_LIBDIR, will prepend an extra path
# 
# https://linux.die.net/man/1/pkg-config
# https://autotools.info/pkgconfig/cross-compiling.html

export PKG_CONFIG_LIBDIR=/macos/usr/lib/pkgconfig:/opt/R/x86_64/lib/pkgconfig:/opt/R/x86_64/share/pkgconfig:/opt/X11/lib/pkgconfig:/opt/X11/share/pkgconfig

exec /usr/bin/pkg-config --static "$@"
