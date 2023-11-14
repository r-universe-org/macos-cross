#!/bin/bash

# Patch gert for macOS cross compilation.
# Last tested with gert 1.9.2
#
# Takes the path to the package source file and returns the path to a patched tarball.
#
# Usage: patched_src_file=$(./gert.sh gert.tar.gz)

src_file=$1

tmpdir=$(mktemp -d)

tar -xf "$src_file" --directory "$tmpdir"

# The configure script for gert is only compatible with bash, but the header
# specifies the 'sh' shell. Apparently, this isn't an issue when run on macOS,
# but it causes configuration to fail when run on Linux.
#
# This replaces '#!/bin/sh' with '#!/bin/bash'
sed -i 's|^#!/bin/sh$|#!/bin/bash|' "${tmpdir}/gert/configure"

patched_src_file="${tmpdir}/gert_patched.tar.gz"
tar -C "$tmpdir" -czf "$patched_src_file" gert

# Ensure permissions for builder user
chmod 755 "$tmpdir" "$patched_src_file"

echo "$patched_src_file"
