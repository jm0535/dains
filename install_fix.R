# Force source installation and disable system package managers
# This script attempts to bypass the "Copr/RPM" errors by forcing standard CRAN source installs

# 1. Disable bspm if it's loaded (Fedora's system package manager integration)
if (requireNamespace("bspm", quietly = TRUE)) {
  message("Disabling bspm integration...")
  try(bspm::disable(), silent = TRUE)
}

# 2. Force package type to source
options(pkgType = "source")
options(install.packages.check.source = "no")

# 3. Set a reliable CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# 4. Define critical packages
pkgs <- c("tidyverse", "knitr", "rmarkdown", "kableExtra", "magrittr")

# 5. Install loop
for (pkg in pkgs) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message(sprintf("Installing %s from source...", pkg))
    tryCatch(
      {
        install.packages(pkg, quiet = FALSE, verbose = TRUE)
        if (requireNamespace(pkg, quietly = TRUE)) {
          message(sprintf("✓ Successfully installed %s", pkg))
        } else {
          message(sprintf("✗ Failed to install %s", pkg))
        }
      },
      error = function(e) {
        message(sprintf("Error installing %s: %s", pkg, e$message))
      }
    )
  } else {
    message(sprintf("✓ %s is already installed", pkg))
  }
}
