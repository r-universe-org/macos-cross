#!/bin/bash

# Patch fs for macOS cross compilation.
# Last tested with fs 1.6.2.
#
# Takes the path to the package source file and returns the path to a patched tarball.
#
# Usage: patched_src_file=$(./fs.sh fs.tar.gz)

src_file=$1

tmpdir=$(mktemp -d)

tar -xf "$src_file" --directory "$tmpdir"

# Patch configure flags for libuv configure script, which aren't configurable
# through the usual means of R CMD INSTALL --configure-args. This is required to
# properly cross compile libuv for macOS.
# https://github.com/r-lib/fs/blob/v1.6.1/src/Makevars
sed -i "s|./configure|./configure ${R_CONFIGURE_FLAGS}|" "${tmpdir}/fs/src/Makevars"

patched_src_file="${tmpdir}/fs_patched.tar.gz"
tar -C "$tmpdir" -czf "$patched_src_file" fs

# Ensure permissions for builder user
chmod 755 "$tmpdir" "$patched_src_file"

echo "$patched_src_file"
