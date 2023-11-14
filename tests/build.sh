#!/bin/sh
set -e
echo "::group::Prepare: download sources"
Rscript download.R
echo "::endgroup::"

# Build from source
mkdir -p binaries
mkdir -p temp
for pkg in sources/*.tar.gz; do
	FAIL="OK"
	rm -Rf out.log temp/*
	R CMD INSTALL $pkg --build --library=temp --no-test-load --configure-args="$R_CONFIGURE_FLAGS" > out.log 2>&1 || FAIL="FAILED";
	echo "::group::$(basename $pkg) $FAIL"
	cat out.log
	mv *.tar.gz binaries/ || true
	echo "::endgroup::"
done
