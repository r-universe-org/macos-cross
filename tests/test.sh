#!/bin/sh
set -e
echo "::group::Prepare"
R -e "install.packages(sub('_.*$', '', basename(list.files('binaries'))))"
echo "::endgroup::"

# Build from source
for pkg in binaries/*.tar.gz; do
	FAIL="OK"
	PKGNAME=$(basename $pkg | cut -d '_' -f1)
	R -e "remove.packages('$PKGNAME')" > /dev/null 2>&1
	R CMD INSTALL $pkg > out.log 2>&1
	R -e "library('$PKGNAME')" >> out.log 2>&1 || FAIL="FAILED";
	echo "::group::$PKGNAME $FAIL"
	cat out.log
	echo "::endgroup::"
done
