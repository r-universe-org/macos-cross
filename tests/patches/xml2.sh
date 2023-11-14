#!/bin/bash

# Patch xml2 for macOS cross compilation.
# Last tested with httpuv 1.3.4
#
# Takes the path to the package source file and returns the path to a patched tarball.
#
# Usage: patched_src_file=$(./xml2.sh xml2.tar.gz)

src_file=$1

tmpdir=$(mktemp -d)

tar -xf "$src_file" --directory "$tmpdir"

# xml2 dynamically generates documentation by calling a function from itself in
# an \Sexpr macro. This can't work for a macOS built xml2, and can't be
# excluded from the build, so manually remove the \Sexpr macros for now.
#
# https://github.com/r-lib/xml2/blob/53575f0156e8713d195be33848b18b231399f4d3/man/read_xml.Rd#L58

# Remove "\Sexpr...{}"
sed -ri 's/\\Sexpr[^}]+}//' "${tmpdir}"/xml2/man/*.Rd

patched_src_file="${tmpdir}/xml2_patched.tar.gz"
tar -C "$tmpdir" -czf "$patched_src_file" xml2

# Ensure permissions for builder user
chmod 755 "$tmpdir" "$patched_src_file"

echo "$patched_src_file"
