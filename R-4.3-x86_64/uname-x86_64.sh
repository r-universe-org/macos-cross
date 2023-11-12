#!/bin/bash

# Fake uname that reports info from a macOS x86_64 machine.
#
# Install this to /usr/local/bin/uname.

# https://ss64.com/osx/uname.html
# https://man7.org/linux/man-pages/man1/uname.1.html

flags="$1"

case $flags in
    "")
    echo 'Darwin'
    ;;
    -a|-all)
    # R calls 'uname -a' and requires it to match the host (Linux) to start up correctly.
    # Work around this by using the original uname for now. Some packages may require
    # 'uname -a' to report Darwin, but most packages seem to work fine.
    # echo 'Darwin builder 19.6.0 Darwin Kernel Version 19.6.0: Thu Oct 29 22:56:45 PDT 2020; root:xnu-6153.141.2.2~1/RELEASE_X86_64 x86_64'
    /usr/bin/uname -a
    ;;
    -s|--kernel-name)
    echo 'Darwin'
    ;;
    -n|--nodename)
    echo 'builder'
    ;;
    -r|--kernel-release)
    echo '19.6.0'
    ;;
    -v|--kernel-version)
    echo 'Darwin Kernel Version 19.6.0: Thu Oct 29 22:56:45 PDT 2020; root:xnu-6153.141.2.2~1/RELEASE_X86_64'
    ;;
    -m|--machine)
    echo 'x86_64'
    ;;
    -p|--processor)
    echo 'i386'
    ;;
    -i|--hardware-platform)
    # Non-portable, not on macOS
    # On Linux:
    # echo 'x86_64'
    exit 1
    ;;
    -o|--operating-system)
    # Non-portable, not on macOS
    # On Linux:
    # echo 'GNU/Linux'
    exit 1
    ;;
    *)
    exit 1
    ;;
esac
