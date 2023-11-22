#!/bin/sh
set -e
echo "::group::Prepare"
R -e "install.packages(sub('_.*$', '', basename(list.files('binaries'))))"
echo "::endgroup::"

# Build from source
for pkg in binaries/*.tgz; do
	PKGNAME=$(basename $pkg | cut -d '_' -f1)
	R -e "remove.packages('$PKGNAME')" > /dev/null
	R CMD INSTALL $pkg > /dev/null
	Rscript -e "library('$PKGNAME')"
done
