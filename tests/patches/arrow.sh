#!/bin/bash

# Patch arrow for macOS cross compilation.
# Last tested with arrow 12.0.0
#
# Takes the path to the package source file and returns the path to a patched tarball.
#
# Usage: patched_src_file=$(./arrow.sh arrow.tar.gz)

src_file=$1

tmpdir=$(mktemp -d)

tar -xf "$src_file" --directory "$tmpdir"

# The configure script for arrow is only compatible with bash, but the header
# specifies the 'sh' shell. Apparently, this isn't an issue when run on macOS,
# but it causes configuration to fail when run on Linux.
#
# This replaces '#!/usr/bin/env sh' with '#!/usr/bin/env bash'
sed -i 's|^#!/usr/bin/env sh$|#!/usr/bin/env bash|' "${tmpdir}/arrow/configure"

patched_src_file="${tmpdir}/arrow_patched.tar.gz"
tar -C "$tmpdir" -czf "$patched_src_file" arrow

# Ensure permissions for builder user
chmod 755 "$tmpdir" "$patched_src_file"

echo "$patched_src_file"

