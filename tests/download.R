# Test set of interesting packages
pkgs <- c("antiword", "arrangements", "av", "brotli", "Cairo", "cld2",
"curl", "data.table", "fftw", "fftwtools", "gam", "gdtools",
"gert", "git2r", "glmnet", "gmp", "httpgd", "hunspell", "igraph",
"image.textlinedetector", "imager", "jqr", "lwgeom", "magick",
"Matrix", "mongolite", "odbc", "opencv", "openssl", "pdftools",
"proj4", "protolite", "ragg", "RcppAlgos", "RcppParallel", "redux",
"RMariaDB", "RMySQL", "RPostgres", "rsvg", "rzmq", "sf", "shiny",
"sodium", "sparsenet", "ssh", "stars", "stringi", "terra", "tesseract",
"tidyverse", "tiledb", "unrtf", "V8", "webp", "writexl", "writxl")

# Install host binaries + dependencies
install.packages(pkgs, repos = 'https://p3m.dev/cran/__linux__/jammy/latest')

# Get all the sources
deps <- unname(unlist(tools::package_dependencies(pkgs, recursive = TRUE)))
allpkgs <- sort(unique(c(pkgs, deps)))
dir.create('sources')
download.packages(allpkgs, 'sources', repos = 'https://cloud.r-project.org')
