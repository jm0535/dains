# Download datasets for "Data Analysis in Natural Sciences: An R-Based Approach"
# Author: Dr. Jimmy Moses
# Repository: https://github.com/jm0535/dains
#
# This script sources the comprehensive download script from the scripts/ directory.
# For more details on individual datasets, see scripts/download_datasets.R
#
# Usage:
#   source("download_datasets.R")
#
# Or from command line:
#   Rscript download_datasets.R

# Get the directory of this script
script_dir <- dirname(sys.frame(1)$ofile)
if (is.null(script_dir) || script_dir == "") {
  script_dir <- "."
}

# Path to the comprehensive download script
full_script <- file.path(script_dir, "scripts", "download_datasets.R")

# Check if the script exists
if (file.exists(full_script)) {
  message("Sourcing comprehensive download script from: ", full_script)
  message("")
  source(full_script)
} else {
  # Fallback: run inline if scripts folder doesn't exist
  message("Note: scripts/download_datasets.R not found.")
  message("Running simplified inline download...")
  message("")

  # Set up packages
  if (!require("pacman")) install.packages("pacman", repos = "https://cloud.r-project.org/")
  pacman::p_load(tidyverse, readr, httr)

  # Set data directory
  data_dir <- "data"

  # Define key datasets
  datasets <- list(
    list(
      name = "Environmental (Palmer Penguins)",
      dir = "environmental",
      file = "climate_data.csv",
      url = "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-28/penguins.csv"
    ),
    list(
      name = "Agriculture (Crop Yields)",
      dir = "agriculture",
      file = "crop_yields.csv",
      url = "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-09-01/key_crop_yields.csv"
    ),
    list(
      name = "Marine (Fishing Data)",
      dir = "marine",
      file = "ocean_data.csv",
      url = "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-06-08/fishing.csv"
    ),
    list(
      name = "Ecology (Plant Biodiversity)",
      dir = "ecology",
      file = "biodiversity.csv",
      url = "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-08-18/plants.csv"
    )
  )

  # Download each dataset
  for (ds in datasets) {
    dest_dir <- file.path(data_dir, ds$dir)
    if (!dir.exists(dest_dir)) dir.create(dest_dir, recursive = TRUE)

    dest_file <- file.path(dest_dir, ds$file)
    message("Downloading ", ds$name, "...")

    tryCatch(
      {
        download.file(ds$url, dest_file, mode = "wb", quiet = TRUE)
        message("  ✓ Saved to ", dest_file)
      },
      error = function(e) {
        message("  ✗ Failed: ", e$message)
      }
    )
  }

  message("")
  message("Download complete!")
  message("For full dataset downloads, ensure scripts/download_datasets.R exists.")
}
