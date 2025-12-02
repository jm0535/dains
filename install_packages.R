# Install required packages for "Data Analysis in Natural Sciences: An R-Based Approach"
# Author: Jimmy Moses
# Repository: https://github.com/jm0535/dains
# Last updated: December 2025
#
# Run this script once to set up all necessary packages:
#   source("install_packages.R")

# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Function to install packages if not already installed
install_if_missing <- function(packages) {
  new_packages <- packages[!(packages %in% installed.packages()[, "Package"])]
  if (length(new_packages)) {
    message("Installing packages: ", paste(new_packages, collapse = ", "))
    install.packages(new_packages, dependencies = TRUE)
  } else {
    message("All required packages are already installed.")
  }
}

# Print R session information
message("\n", strrep("=", 50))
message("R Session Information")
message(strrep("=", 50))
message("R version: ", R.version.string)
message("Platform:  ", Sys.info()["sysname"], " ", Sys.info()["release"])
message("Date:      ", Sys.Date())
message(strrep("=", 50), "\n")

# =============================================================================
# PACKAGE DEFINITIONS
# =============================================================================

# Core tidyverse packages
tidyverse_packages <- c(
  "tidyverse", # Meta-package: dplyr, ggplot2, tidyr, readr, purrr, tibble, stringr, forcats
  "tidymodels", # Meta-package: parsnip, recipes, rsample, tune, workflows, yardstick
  "broom", # Tidy model outputs
  "broom.mixed" # Tidy mixed model outputs
)

# Document generation packages
document_packages <- c(
  "rmarkdown", # R Markdown documents
  "knitr", # Dynamic report generation
  "kableExtra" # Enhanced table formatting
)

# Statistical analysis packages
stats_packages <- c(
  "rstatix", # Pipe-friendly statistical tests
  "car", # Companion to Applied Regression
  "lme4", # Linear mixed-effects models
  "MASS", # Modern Applied Statistics
  "pwr", # Power analysis
  "FSA", # Fisheries Stock Assessment methods
  "Kendall", # Kendall correlation and trend tests
  "corrplot", # Correlation plots
  "GGally", # ggplot2 extensions for pairs plots
  "performance", # Model assessment and diagnostics
  "parameters", # Model parameters extraction
  "see", # Visualization for easystats
  "effectsize", # Effect size calculations
  "pROC", # ROC curve analysis
  "emmeans" # Estimated marginal means
)

# Visualization packages
viz_packages <- c(
  "ggplot2", # Grammar of graphics

  "patchwork", # Compose multiple ggplots
  "DiagrammeR", # Diagrams and flowcharts
  "plotly", # Interactive plots

  "viridis", # Colorblind-friendly palettes
  "RColorBrewer", # Color schemes
  "pheatmap", # Pretty heatmaps
  "ggeffects", # Marginal effects plots
  "scales", # Scale functions for visualization
  "ggrepel", # Better text labels
  "ggridges" # Ridge plots
)

# Spatial and ecological packages
eco_packages <- c(
  "sf", # Simple features for spatial data
  "rnaturalearth", # Natural Earth map data
  "rnaturalearthdata", # Natural Earth high resolution data
  "leaflet", # Interactive maps
  "vegan" # Community ecology package
)

# Data exploration and quality packages
exploration_packages <- c(
  "skimr", # Quick data summaries
  "DataExplorer", # Automated EDA reports
  "naniar", # Missing data visualization
  "janitor" # Data cleaning utilities
)

# Reproducibility packages
repro_packages <- c(
  "renv", # Package management for reproducibility
  "here" # Project-relative file paths
)

# Optional advanced packages (uncomment if needed)
# advanced_packages <- c(
#   "randomForest",   # Random forest models
#   "xgboost",        # Gradient boosting
#   "glmnet",         # Regularized regression (ridge, lasso)
#   "ranger",         # Fast random forests
#   "terra",          # Modern spatial data analysis
#   "mlr3"            # Machine learning framework
# )

# =============================================================================
# INSTALLATION
# =============================================================================

# Combine all packages
all_packages <- c(
  tidyverse_packages,
  document_packages,
  stats_packages,
  viz_packages,
  eco_packages,
  exploration_packages,
  repro_packages
)

# Remove duplicates
all_packages <- unique(all_packages)

# Print summary
message("\n", strrep("=", 50))
message("Package Installation Summary")
message(strrep("=", 50))
message("Total packages to check: ", length(all_packages))
message(strrep("=", 50), "\n")

# Install missing packages
install_if_missing(all_packages)

# =============================================================================
# VERIFICATION
# =============================================================================

# Define critical packages that must be installed
critical_packages <- c(
  "tidyverse",
  "tidymodels",
  "rstatix",
  "ggplot2",
  "knitr",
  "performance"
)

# Check for missing critical packages
missing_critical <- critical_packages[!(critical_packages %in% installed.packages()[, "Package"])]

if (length(missing_critical) > 0) {
  warning("Critical packages not installed: ", paste(missing_critical, collapse = ", "))
  message("\nPlease try installing them manually with:")
  message('install.packages(c("', paste(missing_critical, collapse = '", "'), '"))')
} else {
  message("\n✓ All critical packages successfully installed!")
}

# Print package versions for reproducibility
message("\n", strrep("=", 50))
message("Core Package Versions")
message(strrep("=", 50))
for (pkg in critical_packages) {
  if (pkg %in% installed.packages()[, "Package"]) {
    message(sprintf("  %-15s %s", pkg, packageVersion(pkg)))
  }
}
message(strrep("=", 50))

# =============================================================================
# COMPLETION MESSAGE
# =============================================================================

message("\n", strrep("=", 50))
message("Installation Complete!")
message(strrep("=", 50))
message("\nYour R environment is now set up for:")
message("'Data Analysis in Natural Sciences: An R-Based Approach'")
message("\nOnline book: https://jm0535.github.io/dains/")
message("Repository:  https://github.com/jm0535/dains")
message(strrep("=", 50), "\n")

# =============================================================================
# OPTIONAL: Initialize renv for reproducibility
# =============================================================================

if (interactive()) {
  message("\nFor reproducible research, consider using renv:")
  message("  renv::init()      # Initialize renv in your project")
  message("  renv::snapshot()  # Save current package versions")
  message("  renv::restore()   # Restore packages from lockfile\n")
}
