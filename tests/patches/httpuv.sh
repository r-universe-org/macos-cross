#!/bin/bash

# Patch httpuv for macOS cross compilation.
# Last tested with httpuv 1.6.11.
#
# Takes the path to the package source file and returns the path to a patched tarball.
#
# Usage: patched_src_file=$(./httpuv.sh httpuv.tar.gz)

src_file=$1

tmpdir=$(mktemp -d)

tar -xf "$src_file" --directory "$tmpdir"

# Patch configure flags for libuv configure script, which aren't configurable
# through the usual means of R CMD INSTALL --configure-args. This is required to
# properly cross compile libuv for macOS.
# https://github.com/rstudio/httpuv/blob/v1.6.11/src/Makevars
if [ -f "${tmpdir}/httpuv/src/Makevars" ]; then
  sed -i "s/CONFIGURE_FLAGS=.*/CONFIGURE_FLAGS=--quiet ${R_CONFIGURE_FLAGS}/" "${tmpdir}/httpuv/src/Makevars"
fi
# After 1.6.11, Makevars moved to Makevars.in:
# https://github.com/rstudio/httpuv/blob/4b8dc26e5165078656877e41afd55806771b5f8c/src/Makevars.in
if [ -f "${tmpdir}/httpuv/src/Makevars.in" ]; then
  sed -i "s/CONFIGURE_FLAGS=.*/CONFIGURE_FLAGS=--quiet ${R_CONFIGURE_FLAGS}/" "${tmpdir}/httpuv/src/Makevars.in"
fi

patched_src_file="${tmpdir}/httpuv_patched.tar.gz"
tar -C "$tmpdir" -czf "$patched_src_file" httpuv

# Ensure permissions for builder user
chmod 755 "$tmpdir" "$patched_src_file"

echo "$patched_src_file"
