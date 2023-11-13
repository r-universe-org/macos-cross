# MacOS Cross

Docker images for cross compiling R packages for MacOS on Linux.

## How to test

To start the image prepared for R-4.3-x86_64 cross:

```sh
docker run -it ghcr.io/r-universe-org/macos-cross/r-4.3-x86_64
```

And then start R and do something like:

```r
# Installs linux binary + dependencies
install.packages("pdftools")

# Cross compile the source package for apple-x86_64
install.packages("pdftools", repos = 'https://cran.r-project.org', INSTALL_opts="--build --no-test-load")
```
