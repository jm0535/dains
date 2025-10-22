# Parallel Dataset Download Script
# Enhanced version with parallel processing for faster downloads
# Author: Automated improvement script

# Set up packages
if (!require("pacman")) install.packages("pacman", repos = "https://cloud.r-project.org/")
pacman::p_load(
  future, # Parallel processing framework
  furrr, # Future-based parallel mapping
  tidyverse, # Data manipulation
  digest, # File hashing
  curl # Enhanced downloads
)

# Source the main download script for function definitions
source("scripts/download_datasets.R")

#' Parallel Dataset Download with Progress Tracking
#'
#' Downloads multiple datasets in parallel for improved performance
#'
#' @param datasets List of dataset specifications
#' @param max_workers Maximum number of parallel workers (default: 4)
#' @return List of download results (TRUE/FALSE for each dataset)
parallel_download_datasets <- function(datasets, max_workers = 4) {
  message(sprintf("\n=== Starting Parallel Download (%d workers) ===\n", max_workers))

  # Set up parallel processing
  future::plan(future::multisession, workers = max_workers)

  # Download datasets in parallel with progress bar
  results <- furrr::future_map_lgl(
    datasets,
    function(dataset) {
      tryCatch(
        {
          process_dataset(
            dataset$name,
            dataset$directory,
            dataset$filename,
            dataset$url,
            dataset$citation_source,
            dataset$citation_text,
            dataset$description
          )
        },
        error = function(e) {
          cat(sprintf("ERROR in %s: %s\n", dataset$name, e$message))
          return(FALSE)
        }
      )
    },
    .progress = TRUE,
    .options = furrr::furrr_options(seed = TRUE)
  )

  # Return to sequential processing
  future::plan(future::sequential)

  # Name the results
  names(results) <- sapply(datasets, function(d) d$name)

  return(results)
}

# Run parallel downloads
cat("\n##########################\n")
cat("# PARALLEL DATA DOWNLOAD #\n")
cat("##########################\n\n")

start_time <- Sys.time()

# Use the datasets list from download_datasets.R
results <- parallel_download_datasets(datasets, max_workers = 4)

end_time <- Sys.time()
duration <- as.numeric(difftime(end_time, start_time, units = "secs"))

# Generate summary
cat("\n## Download Summary ##\n")
success_count <- sum(results)
total_count <- length(datasets)

cat(sprintf(
  "Successfully downloaded %d of %d datasets (%.1f%%)\n",
  success_count, total_count, 100 * success_count / total_count
))
cat(sprintf("Total time: %.1f seconds (%.1f sec/dataset average)\n\n",
  duration, duration / total_count
))

# Show results table
cat(sprintf("%-15s | %-10s\n", "DATASET", "STATUS"))
cat(sprintf("%-15s-|-%-10s\n", "---------------", "----------"))
for (name in names(results)) {
  status <- if (results[[name]]) "SUCCESS" else "FAILED"
  cat(sprintf("%-15s | %-10s\n", name, status))
}

cat("\nParallel download complete!\n")
