# Setup renv for Reproducible Dependency Management
# Author: Automated setup script
# Purpose: Initialize renv and capture current package environment

# Install renv if not already installed
if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv", repos = "https://cloud.r-project.org/")
}

library(renv)

# Initialize renv (if not already initialized)
if (!file.exists("renv.lock")) {
  message("Initializing renv...")
  renv::init(bare = TRUE)

  # Install all required packages
  message("Installing required packages...")
  source("scripts/install_packages.R")

  # Take a snapshot of the current environment
  message("Creating snapshot of package versions...")
  renv::snapshot()

  message("renv setup complete!")
  message("renv.lock file created with all package versions.")
} else {
  message("renv is already initialized.")
  message("To restore the environment, run: renv::restore()")
  message("To update the snapshot, run: renv::snapshot()")
}

# Print instructions
cat("\n=== renv Usage Instructions ===\n")
cat("1. To restore packages: renv::restore()\n")
cat("2. To update snapshot: renv::snapshot()\n")
cat("3. To check status: renv::status()\n")
cat("4. To add new package: install.packages('pkg'), then renv::snapshot()\n")
cat("5. To update packages: renv::update()\n")
cat("\n")
