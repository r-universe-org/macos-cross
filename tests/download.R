# Test set of interesting packages
pkgs <- c('ragg', 'stringi', 'igraph', 'V8', 'opencv', 'magick', 'pdftools', 
  'protolite', 'curl', 'openssl', 'RMariaDB', "RPostgres", "glmnet", "av",
  "gert", 'mongolite', 'rsvg', 'rzmq', 'sodium', 'tesseract', 'writexl',
  "shiny", "tidyverse", 'RcppParallel', 'antiword', 'unrtf', 'brotli',
  'cld2', 'gert', 'hunspell', 'RMySQL', 'rzmq', 'ssh', 'webp', 'writxl')

# Install host binaries + dependencies
install.packages(pkgs, repos = 'https://p3m.dev/cran/__linux__/jammy/latest')

# Get all the sources
deps <- unname(unlist(tools::package_dependencies(pkgs, recursive = TRUE)))
allpkgs <- sort(unique(c(pkgs, deps)))
dir.create('sources')
download.packages(allpkgs, 'sources', repos = 'https://cloud.r-project.org')
