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
	pkg_name=$(basename $pkg | cut -d '_' -f1)

	# Apply patch script if exists
	patch_script="patches/${pkg_name}.sh"
	if [ -f "$patch_script" ]; then
	  echo "Applying patch $patch_script..."
	  pkg=$($patch_script "$pkg")
	fi

	build-package $pkg > out.log 2>&1 || FAIL="FAILED";
	echo "::group::${pkg_name} $FAIL"
	cat out.log
	mv *.tgz binaries/ || true
	echo "::endgroup::"
done
