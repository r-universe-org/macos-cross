# Cross compile testing

The CI first runs [build.sh](build.sh) in the `r-4.3-x86_64` container on Ubuntu to compile a hand full of R packages to MacOS. A few packages with broken configure scripts or flags fail to build, this is expected. The important thing is that they do really error, such that we do not ship broken packages.

The binary packages are then copied to a MacOS runner and test-loaded there. This should not fail, the packages that we built should be loadable.


