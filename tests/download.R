# Test set of interesting packages
pkgs <- c("antiword", "archive", "arrangements", "arrow", "av", "brotli",
"Cairo", "cld2", "curl", "data.table", "duckdb", "fftw", "fftwtools",
"gam", "gdtools", "gert", "git2r", "glmnet", "gmp", "httpgd",
"hunspell", "igraph", "image.textlinedetector", "imager", "jqr",
"lwgeom", "magick", "Matrix", "mongolite", "odbc", "opencv",
"openssl", "pdftools", "proj4", "protolite", "ragg", "RcppAlgos",
"RcppParallel", "redux", "RMariaDB", "RMySQL", "RPostgres", "rsvg",
"rzmq", "sf", "shiny", "sodium", "sparsenet", "ssh", "stars",
"stringi", "terra", "tesseract", "tidyverse", "tiledb", "unrtf",
"V8", "webp", "writexl")

cat("::group::Installing host dependencies\n")
# Install host binaries + dependencies
install.packages(pkgs, repos = 'https://p3m.dev/cran/__linux__/jammy/latest')
cat("::endgroup::\n")

# Get all the sources
cat("::group::Downloading sources\n")
deps <- unname(unlist(tools::package_dependencies(pkgs, recursive = TRUE)))
allpkgs <- sort(unique(c(pkgs, deps)))
dir.create('sources')
download.packages(allpkgs, 'sources',
  repos = sprintf('https://%s.r-universe.dev', c('r-spatial', 'r-lib', 'ropensci', 'rcppcore', 'cran')))
cat("::endgroup::\n")

