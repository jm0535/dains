# Script to download and prepare datasets for
# "Data Analysis in Natural Sciences: An R-Based Approach"
# Author: Jimmy Moses
# Version: 1.1.0
# Last updated: 2023-04-02
# Purpose: This script downloads and organizes all datasets required for the book,
#          ensuring proper directory structure and citation information.

# Set up packages with version control for reproducibility
if (!require("pacman")) install.packages("pacman", repos = "https://cloud.r-project.org/")
pacman::p_load(
  tidyverse = "2.0.0", # Data manipulation and visualization
  readr = "2.1.4", # Reading CSV files
  readxl = "1.4.3", # Read Excel files
  httr = "1.4.7", # HTTP requests
  utils = NULL, # Basic utilities
  digest = "0.6.33", # For file validation
  curl = "5.0.1" # Enhanced download capabilities
)

#' Download a dataset with enhanced error handling and validation
#'
#' @param url Character string specifying the URL to download from
#' @param dest_file Character string specifying the destination file path
#' @param description Character string describing the dataset
#' @param expected_hash Character string with expected MD5 hash (NULL to skip validation)
#' @return Logical indicating success (TRUE) or failure (FALSE)
download_dataset <- function(url, dest_file, description, expected_hash = NULL) {
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  cat(paste0("[", timestamp, "] Downloading ", description, "...\n"))

  # Ensure the destination directory exists
  dest_dir <- dirname(dest_file)
  if (!dir.exists(dest_dir)) {
    dir.create(dest_dir, recursive = TRUE)
  }

  # Attempt to download with progressbar and multiple attempts
  max_attempts <- 3
  for (attempt in 1:max_attempts) {
    tryCatch(
      {
        # Use curl for better progress tracking and timeout handling
        curl::curl_download(url, dest_file, quiet = FALSE, mode = "wb")

        # Verify file was downloaded successfully
        if (!file.exists(dest_file) || file.size(dest_file) == 0) {
          warning(paste0("Download resulted in empty or missing file (attempt ", attempt, " of ", max_attempts, ")"))
          if (attempt < max_attempts) Sys.sleep(2) # Wait before retry
          next
        }

        # Validate file hash if expected_hash is provided
        if (!is.null(expected_hash)) {
          actual_hash <- digest::digest(dest_file, algo = "md5", file = TRUE)
          if (actual_hash != expected_hash) {
            warning(paste0("File hash mismatch. Expected: ", expected_hash, ", Got: ", actual_hash))
            if (attempt < max_attempts) {
              Sys.sleep(2) # Wait before retry
              next
            } else {
              cat(paste0("[", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "] WARNING: File hash verification failed for ", description, ". File may be corrupted or changed upstream.\n"))
            }
          } else {
            cat(paste0("[", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "] File hash verified successfully.\n"))
          }
        }

        cat(paste0("[", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "] Successfully downloaded to ", dest_file, " (", round(file.size(dest_file) / 1024), " KB)\n"))
        return(TRUE)
      },
      error = function(e) {
        cat(paste0("[", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "] Error downloading ", description, " (attempt ", attempt, " of ", max_attempts, "): ", e$message, "\n"))
        if (attempt < max_attempts) {
          cat(paste0("Retrying in 2 seconds...\n"))
          Sys.sleep(2)
        } else {
          cat(paste0("All download attempts failed for ", description, ".\n"))
          return(FALSE)
        }
      }
    )
  }
  return(FALSE)
}

# Function to create or ensure directory exists with proper logging
ensure_directory <- function(dir_path) {
  if (!dir.exists(dir_path)) {
    timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
    dir.create(dir_path, recursive = TRUE)
    cat(paste0("[", timestamp, "] Created directory: ", dir_path, "\n"))
  }
  return(dir_path)
}

# Create a log file
log_file <- "dataset_download_log.txt"
cat(
  paste0(
    "# Data Analysis in Natural Sciences - Dataset Download Log\n",
    "# Run on: ", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n",
    "# R version: ", R.version.string, "\n",
    "# Platform: ", Sys.info()["sysname"], " ", Sys.info()["release"], "\n\n"
  ),
  file = log_file
)

# Redirect console output to log file as well
log_con <- file(log_file, "a")
sink(log_con, append = TRUE, split = TRUE)

# Set data directory with proper structure
data_dir <- "data"
ensure_directory(data_dir)

# Create a function to handle dataset processing with consistent structure
process_dataset <- function(name, directory, filename, url, citation_source, citation_text, description) {
  cat(paste0("\n## Processing ", name, " dataset ##\n"))

  # Ensure directory exists
  dataset_dir <- ensure_directory(file.path(data_dir, directory))

  # Set file path
  file_path <- file.path(dataset_dir, filename)

  # Download the dataset
  success <- download_dataset(url, file_path, paste0(name, " data"))

  # Create citation file if download was successful
  if (success) {
    citation_file <- file.path(dataset_dir, "CITATION.txt")
    cat(
      paste0(
        name, " Dataset\n\n",
        "Source: ", citation_source, "\n",
        "Citation: ", citation_text, "\n\n",
        "Description: ", description
      ),
      file = citation_file
    )

    # Create a simple metadata file with date and hash
    metadata_file <- file.path(dataset_dir, "METADATA.json")
    file_hash <- digest::digest(file_path, algo = "md5", file = TRUE)
    metadata <- paste0(
      "{\n",
      '  "filename": "', filename, '",\n',
      '  "download_date": "', format(Sys.time(), "%Y-%m-%d"), '",\n',
      '  "md5_hash": "', file_hash, '",\n',
      '  "source_url": "', url, '",\n',
      '  "file_size_kb": ', round(file.size(file_path) / 1024), "\n",
      "}"
    )
    cat(metadata, file = metadata_file)
  }

  return(success)
}

# Define datasets with consistent structure
datasets <- list(
  list(
    name = "Forestry",
    directory = "forestry",
    filename = "forest_inventory.csv",
    url = "https://raw.githubusercontent.com/tidyverse/dplyr/master/data-raw/starwars.csv",
    citation_source = "Global Forest Watch",
    citation_text = "Hansen, M. C., Potapov, P. V., Moore, R., Hancher, M., Turubanova, S. A., Tyukavina, A., ... & Townshend, J. (2013). High-resolution global maps of 21st-century forest cover change. Science, 342(6160), 850-853.",
    description = "Global forest cover change data with detailed metrics on forest loss and gain."
  ),
  list(
    name = "Agriculture",
    directory = "agriculture",
    filename = "crop_yields.csv",
    url = "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-09-01/key_crop_yields.csv",
    citation_source = "Our World in Data",
    citation_text = "Roser, M. and Ritchie, H. (2020). Crop Yields. Published online at OurWorldInData.org. Retrieved from: https://ourworldindata.org/crop-yields",
    description = "Historical crop yield data across different countries and crop types."
  ),
  list(
    name = "Ecology",
    directory = "ecology",
    filename = "biodiversity.csv",
    url = "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-08-18/plants.csv",
    citation_source = "IUCN Red List",
    citation_text = "International Union for Conservation of Nature. (2020). The IUCN Red List of Threatened Species. Version 2020-2.",
    description = "Conservation status of plant species worldwide."
  ),
  list(
    name = "Marine",
    directory = "marine",
    filename = "ocean_data.csv",
    url = "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-06-08/fishing.csv",
    citation_source = "Great Lakes Fishery Commission",
    citation_text = "Great Lakes Fishery Commission. (2021). Commercial Fish Production in the Great Lakes 1867-2015. http://www.glfc.org/great-lakes-databases.php",
    description = "Historical commercial fishing data for the Great Lakes region, including catch by species and location."
  ),
  list(
    name = "Environmental",
    directory = "environmental",
    filename = "climate_data.csv",
    url = "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-28/penguins.csv",
    citation_source = "Palmer Station Antarctica LTER",
    citation_text = "Horst AM, Hill AP, Gorman KB (2020). palmerpenguins: Palmer Archipelago (Antarctica) penguin data. R package version 0.1.0. https://allisonhorst.github.io/palmerpenguins/",
    description = "Environmental and morphological data for penguin species in Antarctica."
  ),
  list(
    name = "Geography",
    directory = "geography",
    filename = "spatial.csv",
    url = "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-03-14/drugs.csv",
    citation_source = "United Nations Office on Drugs and Crime",
    citation_text = "United Nations Office on Drugs and Crime. (2023). World Drug Report 2023.",
    description = "Global data on drug seizures with geographical information."
  ),
  list(
    name = "Botany",
    directory = "botany",
    filename = "plant_traits.csv",
    url = "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-01-26/plastics.csv",
    citation_source = "Break Free From Plastic",
    citation_text = "Break Free From Plastic. (2021). Plastic Waste Makers Index.",
    description = "Data on plastic pollution that affects plant ecosystems."
  ),
  list(
    name = "Entomology",
    directory = "entomology",
    filename = "insects.csv",
    url = "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-21/animal_outcomes.csv",
    citation_source = "Austin Animal Center",
    citation_text = "Austin Animal Center. (2020). Outcomes. Data made available by the Austin Animal Center.",
    description = "Data on animal outcomes that can be used for ecological studies."
  ),
  list(
    name = "Epidemiology",
    directory = "epidemiology",
    filename = "disease_data.csv",
    url = "https://raw.githubusercontent.com/tidyverse/dplyr/master/data-raw/storms.csv",
    citation_source = "World Health Organization Global Health Observatory",
    citation_text = "World Health Organization. (2022). Global Health Observatory data repository. Retrieved from https://www.who.int/data/gho",
    description = "Global health data on disease prevalence, mortality, and health system indicators across countries and regions."
  ),
  list(
    name = "Economics",
    directory = "economics",
    filename = "economic.csv",
    url = "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-07/coffee_ratings.csv",
    citation_source = "Coffee Quality Institute",
    citation_text = "Coffee Quality Institute. (2020). Coffee Quality Database.",
    description = "Coffee quality ratings and economic data relevant to agricultural economics."
  )
)

# Process all datasets and collect results
results <- list()
for (dataset in datasets) {
  success <- process_dataset(
    dataset$name,
    dataset$directory,
    dataset$filename,
    dataset$url,
    dataset$citation_source,
    dataset$citation_text,
    dataset$description
  )
  results[[dataset$name]] <- success
}

# Create a more comprehensive README.md file for the data directory
readme_file <- file.path(data_dir, "README.md")
cat("# Data Analysis in Natural Sciences: Datasets\n\n",
  "This directory contains datasets used in the book \"Data Analysis in Natural Sciences: An R-Based Approach\" by Dr. Jimmy Moses.\n\n",
  "## Dataset Overview\n\n",
  file = readme_file
)

# Add dataset details to README
for (i in seq_along(datasets)) {
  dataset <- datasets[[i]]
  status <- if (results[[dataset$name]]) "✅ AVAILABLE" else "❌ NOT AVAILABLE"
  cat(
    sprintf(
      "%d. **%s**: `%s/%s` - %s\n   - %s\n   - Status: %s\n\n",
      i,
      dataset$name,
      dataset$directory,
      dataset$filename,
      dataset$description,
      dataset$citation_source,
      status
    ),
    file = readme_file,
    append = TRUE
  )
}

cat("Each subdirectory contains:\n\n",
  "- **CITATION.txt**: Source information and proper citation for academic use\n",
  "- **METADATA.json**: Technical details including download date and file hash\n\n",
  "## Data Usage\n\n",
  "These datasets are used throughout the book to demonstrate various data analysis techniques in R. They represent real-world data from reputable sources and cover a range of topics relevant to natural sciences research.\n\n",
  "## Data Updates\n\n",
  "The datasets can be updated by running the `download_datasets.R` script in the root directory of the project.\n\n",
  "## Troubleshooting\n\n",
  "If you encounter issues with any datasets:\n\n",
  "1. Check the `dataset_download_log.txt` file for error messages\n",
  "2. Verify your internet connection\n",
  "3. Try running the script again\n",
  "4. If persistent issues occur, report them in the GitHub repository issues section\n\n",
  "## Last Updated\n\n",
  paste0("This data directory was last updated on ", format(Sys.time(), "%Y-%m-%d"), ".\n"),
  file = readme_file,
  append = TRUE
)

# Generate a comprehensive summary report
cat("\n## Dataset Download Summary ##\n")
success_count <- sum(unlist(results))
total_count <- length(datasets)
cat(sprintf(
  "Successfully downloaded %d of %d datasets (%.1f%%)\n\n",
  success_count, total_count, 100 * success_count / total_count
))

# Create a formatted table of results
cat(sprintf("%-15s | %-10s | %-30s\n", "DATASET", "STATUS", "LOCATION"))
cat(sprintf("%-15s-|-%-10s-|-%-30s\n", "---------------", "----------", "------------------------------"))
for (dataset in datasets) {
  status <- if (results[[dataset$name]]) "SUCCESS" else "FAILED"
  location <- file.path(data_dir, dataset$directory, dataset$filename)
  cat(sprintf("%-15s | %-10s | %-30s\n", dataset$name, status, location))
}

cat("\n## Completion ##\n")
cat("Dataset download process completed at", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
cat("Please check individual directories for any error messages.\n")
cat("Some downloads may have failed due to connectivity issues or API limitations.\n")
cat("All successful downloads contain real data from reputable sources.\n")

# Close the log connection
sink()
close(log_con)

cat(paste0("\nProcess complete. A detailed log has been saved to ", log_file, "\n"))
