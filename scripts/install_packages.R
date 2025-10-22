# Install required packages for "Data Analysis in Natural Sciences: An R-Based Approach"
# Author: Jimmy Moses
# Last updated: 2025-10-22
# Run this script once to set up all necessary packages

# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Function to install packages if not already installed
install_if_missing <- function(packages) {
  new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  if(length(new_packages)) {
    message("Installing packages: ", paste(new_packages, collapse = ", "))
    install.packages(new_packages, dependencies = TRUE)
  } else {
    message("All required packages are already installed.")
  }
}

# Print R session information
message("\n=== R Session Information ===")
message("R version: ", R.version.string)
message("Platform: ", Sys.info()["sysname"], " ", Sys.info()["release"])
message("==========================\n")

# Core tidyverse packages
tidyverse_packages <- c(
  "tidyverse",      # Meta-package including dplyr, ggplot2, tidyr, readr, purrr, tibble, stringr, forcats
  "tidymodels",     # Meta-package for modeling (parsnip, recipes, rsample, tune, workflows, yardstick)
  "broom",          # Tidy model outputs
  "broom.mixed"     # Tidy mixed models
)

# Document generation packages
document_packages <- c(
  "rmarkdown",      # R Markdown documents
  "knitr",          # Dynamic report generation
  "quarto",         # Next-gen scientific publishing
  "kableExtra"      # Enhanced table formatting
)

# Statistical analysis packages
stats_packages <- c(
  "rstatix",        # Pipe-friendly statistical tests
  "car",            # Companion to Applied Regression
  "lme4",           # Linear mixed-effects models
  "MASS",           # Modern Applied Statistics
  "pwr",            # Power analysis
  "FSA",            # Fisheries Stock Assessment
  "Kendall",        # Kendall correlation
  "corrplot",       # Correlation plots
  "GGally",         # ggplot2 extensions
  "performance",    # Model assessment
  "parameters",     # Model parameters
  "see",            # Visualization for model diagnostics
  "effectsize",     # Effect size calculations
  "pROC",           # ROC curve analysis
  "emmeans"         # Estimated marginal means
)

# Visualization packages
viz_packages <- c(
  "ggplot2",        # Grammar of graphics (included in tidyverse but listed for clarity)
  "patchwork",      # Compose multiple plots
  "DiagrammeR",     # Create diagrams and flowcharts
  "plotly",         # Interactive plots
  "viridis",        # Colorblind-friendly palettes
  "RColorBrewer",   # Color schemes for maps
  "pheatmap",       # Pretty heatmaps
  "ggeffects",      # Marginal effects plots
  "scales",         # Scale functions for visualization
  "ggrepel",        # Better text labels for ggplot2
  "ggridges"        # Ridge plots
)

# Spatial and ecological packages
eco_packages <- c(
  "sf",             # Simple features for spatial data
  "rnaturalearth",  # Natural Earth map data
  "rnaturalearthdata", # Natural Earth high resolution data
  "leaflet",        # Interactive maps
  "terra",          # Spatial data analysis
  "vegan"           # Community ecology package
)

# Data exploration and quality packages
exploration_packages <- c(
  "skimr",          # Quick data summaries
  "DataExplorer",   # Automated EDA
  "naniar",         # Missing data visualization
  "janitor"         # Data cleaning
)

# Reproducibility packages
repro_packages <- c(
  "renv",           # Package management
  "here",           # Project-relative paths
  "usethis"         # Project setup utilities
)

# Optional advanced packages (uncomment if needed)
# optional_packages <- c(
#   "randomForest",   # Random forest models
#   "xgboost",        # Gradient boosting
#   "glmnet",         # Regularized regression
#   "caret",          # Classification and regression training
#   "mlr3"            # Machine learning framework
# )

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

# Print summary of packages to be installed
message("\n=== Package Installation Summary ===")
message("Total packages to check: ", length(all_packages))
message("=====================================\n")

# Install missing packages
install_if_missing(all_packages)

# Verify critical packages
critical_packages <- c("tidyverse", "tidymodels", "rstatix", "ggplot2", "knitr")
missing_critical <- critical_packages[!(critical_packages %in% installed.packages()[,"Package"])]

if(length(missing_critical) > 0) {
  warning("Critical packages not installed: ", paste(missing_critical, collapse = ", "))
  message("\nPlease try installing them manually with: install.packages(c(\"", 
          paste(missing_critical, collapse = "\", \""), "\"))")
} else {
  message("\n✓ All critical packages successfully installed!")
}

# Print package versions for reproducibility
message("\n=== Core Package Versions ===")
for(pkg in critical_packages) {
  if(pkg %in% installed.packages()[,"Package"]) {
    message(sprintf("%-15s: %s", pkg, packageVersion(pkg)))
  }
}

# Print completion message
message("\n======================================")
message("Package installation complete!")
message("Your environment is now set up for")
message("'Data Analysis in Natural Sciences: An R-Based Approach'")
message("=====================================\n")

# Optional: Initialize renv for reproducibility
if(interactive()) {
  response <- readline(prompt = "\nWould you like to initialize renv for reproducibility? (y/n): ")
  if(tolower(response) == "y") {
    if("renv" %in% installed.packages()[,"Package"]) {
      message("Initializing renv...")
      renv::init()
      message("\nrenv initialized! Run renv::snapshot() to save package versions.")
    }
  }
}
