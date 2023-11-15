# MacOS Cross

Docker images prepared for cross compiling R packages for MacOS using [osxcross](https://github.com/tpoechtrager/osxcross).

## Hello world

To start the image prepared for R-4.3-x86_64 cross:

```sh
docker run -it ghcr.io/r-universe-org/macos-cross/r-4.3-x86_64
```

To cross compile a package, we first install the binary package with dependencies for the host architecture (Linux):

```sh
# Install host binaries + dependencies
R -e "install.packages('magick', repos = 'https://p3m.dev/cran/__linux__/jammy/latest')"
```

Then we compile the source package:

```sh
mkdir -p maclibs
curl -OL "https://cloud.r-project.org/src/contrib/magick_2.8.1.tar.gz"
R CMD INSTALL magick_2.8.1.tar.gz --build --no-test-load --library=maclibs
```

We use `--no-test-load` because the cross-compiled MacOS binary cannot be loaded on Linux.

Also make sure to pass a `--library` to make sure the MacOS compiled packages do not get installed into your real package library with Linux packages, because again, they cannot actually be loaded on MacOS.
