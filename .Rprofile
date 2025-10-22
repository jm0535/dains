# .Rprofile for Data Analysis in Natural Sciences
# This file is automatically sourced when R starts in this project

# Activate renv for this project
if (file.exists("renv/activate.R")) {
  source("renv/activate.R")
}

# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org/"))

# Set default options
options(
  stringsAsFactors = FALSE,
  max.print = 100,
  scipen = 10,
  width = 80
)

# Welcome message
if (interactive()) {
  cat("\n=== Data Analysis in Natural Sciences ===\n")
  cat("Project loaded successfully!\n")
  cat("Working directory:", getwd(), "\n")

  if (requireNamespace("renv", quietly = TRUE)) {
    cat("renv is active - using project library\n")
  }

  cat("\nQuick commands:\n")
  cat("  - Build book: quarto render\n")
  cat("  - Run tests: testthat::test_dir('tests')\n")
  cat("  - Check renv: renv::status()\n")
  cat("\n")
}
