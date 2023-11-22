#!/bin/sh
# This script is a workaround for: https://github.com/r-devel/r-svn/pull/146
# If that is merged we can just use R CMD INSTALL --build
set -e
pkg_src="$1"
pkg_name=$(basename "$pkg_src" | cut -d '_' -f1)
pkg_bin=$(basename "$pkg_src" | sed 's/.tar.gz/-apple-x86_64.tgz/')
pkg_lib="build_${pkg_name}"
rm -Rf $pkg_lib
mkdir -p $pkg_lib
R CMD INSTALL "$@" --library="${pkg_lib}" --no-test-load --configure-args="$R_CONFIGURE_FLAGS"
cd $pkg_lib
echo "Updating DESCRIPTION file"
sed -i 's/x86_64-pc-linux-gnu;/x86_64-apple-darwin20;/g' "$pkg_name/DESCRIPTION"
echo "Building $pkg_bin"
tar -I "gzip --best" -c -f $pkg_bin $pkg_name
mv $pkg_bin ..
cd ..
rm -Rf $pkg_lib
