# Direct package installation without renv
# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Critical packages needed for rendering
critical_pkgs <- c(
  "knitr", "rmarkdown", "tidyverse", "ggplot2",
  "kableExtra", "magrittr", "dplyr", "tidyr"
)

cat("Installing critical packages...\n")
for (pkg in critical_pkgs) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    cat("Installing:", pkg, "\n")
    install.packages(pkg, dependencies = TRUE, quiet = FALSE)
  } else {
    cat("Already installed:", pkg, "\n")
  }
}

cat("\n✓ Critical packages installation complete!\n")
