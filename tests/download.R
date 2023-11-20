# Test set of interesting packages
pkgs <- c("antiword", "av", "brotli", "cld2", "curl", "data.table", "gam",
"gdtools", "gert", "gert", "git2r", "glmnet", "glmnet", "httpgd",
"hunspell", "igraph", "image.textlinedetector", "jqr", "magick",
"Matrix", "mongolite", "odbc", "opencv", "openssl", "pdftools",
"protolite", "ragg", "RcppParallel", "redux", "RMariaDB", "RMySQL",
"RPostgres", "rsvg", "rzmq", "rzmq", "sf", "shiny", "sodium",
"sparsenet", "ssh", "stars", "stringi", "tesseract", "tidyverse",
"tiledb", "unrtf", "V8", "webp", "writexl", "writxl")

# Install host binaries + dependencies
install.packages(pkgs, repos = 'https://p3m.dev/cran/__linux__/jammy/latest')

# Get all the sources
deps <- unname(unlist(tools::package_dependencies(pkgs, recursive = TRUE)))
allpkgs <- sort(unique(c(pkgs, deps)))
dir.create('sources')
download.packages(allpkgs, 'sources', repos = 'https://cloud.r-project.org')
