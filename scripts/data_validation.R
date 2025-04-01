# Data Validation Script for Data Analysis in Natural Sciences
# Author: Dr. Jimmy Moses (PhD)
# Version: 1.0.0
# Last updated: 2023-04-02
#
# Purpose: This script checks the integrity and quality of all datasets downloaded
# for the book "Data Analysis in Natural Sciences: An R-Based Approach".
# It ensures data is properly formatted and ready for analysis in the book.

# Load necessary packages
if (!require("pacman")) install.packages("pacman", repos = "https://cloud.r-project.org/")
pacman::p_load(
    tidyverse, # For data manipulation
    naniar, # For missing data visualization
    validate, # For data validation
    digest, # For file hashing
    dataMaid, # For data quality reporting
    janitor, # For data cleaning
    skimr # For summary statistics
)

# Create log file
log_file <- "data_validation_log.txt"
timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
cat(
    paste0(
        "# Data Analysis in Natural Sciences - Data Validation Log\n",
        "# Run on: ", timestamp, "\n",
        "# R version: ", R.version.string, "\n",
        "# Platform: ", paste(Sys.info()[c("sysname", "release", "version")], collapse = " "), "\n\n"
    ),
    file = log_file
)

# Main data directory
data_dir <- "data"

# Function to validate a dataset
validate_dataset <- function(name, path, primary_key = NULL) {
    cat(paste0("\n## Validating ", name, " dataset ##\n"))

    # Append to log file
    cat(paste0("\n## Validating ", name, " dataset ##\n"), file = log_file, append = TRUE)

    # Check if file exists
    if (!file.exists(path)) {
        cat(paste0("ERROR: File '", path, "' not found.\n"))
        cat(paste0("ERROR: File '", path, "' not found.\n"), file = log_file, append = TRUE)
        return(FALSE)
    }

    # Get file metadata
    file_info <- file.info(path)
    file_size_kb <- round(file_info$size / 1024, 2)
    file_modified <- file_info$mtime
    file_hash <- digest::digest(path, algo = "md5", file = TRUE)

    cat(paste0("File: ", basename(path), "\n"))
    cat(paste0("Size: ", file_size_kb, " KB\n"))
    cat(paste0("Last Modified: ", file_modified, "\n"))
    cat(paste0("MD5 Hash: ", file_hash, "\n\n"))

    # Log file information
    cat(paste0("File: ", basename(path), "\n"), file = log_file, append = TRUE)
    cat(paste0("Size: ", file_size_kb, " KB\n"), file = log_file, append = TRUE)
    cat(paste0("Last Modified: ", file_modified, "\n"), file = log_file, append = TRUE)
    cat(paste0("MD5 Hash: ", file_hash, "\n\n"), file = log_file, append = TRUE)

    # Attempt to read the file
    tryCatch(
        {
            if (grepl("\\.csv$", path, ignore.case = TRUE)) {
                data <- read.csv(path, stringsAsFactors = FALSE)
            } else if (grepl("\\.xlsx$|\\.xls$", path, ignore.case = TRUE)) {
                data <- readxl::read_excel(path)
            } else {
                cat(paste0("ERROR: Unsupported file format for '", path, "'.\n"))
                cat(paste0("ERROR: Unsupported file format for '", path, "'.\n"), file = log_file, append = TRUE)
                return(FALSE)
            }

            # Basic data checks
            n_rows <- nrow(data)
            n_cols <- ncol(data)
            n_missing <- sum(is.na(data))
            pct_missing <- round(100 * n_missing / (n_rows * n_cols), 2)

            cat(paste0("Data dimensions: ", n_rows, " rows x ", n_cols, " columns\n"))
            cat(paste0("Missing values: ", n_missing, " (", pct_missing, "%)\n"))

            cat(paste0("Data dimensions: ", n_rows, " rows x ", n_cols, " columns\n"), file = log_file, append = TRUE)
            cat(paste0("Missing values: ", n_missing, " (", pct_missing, "%)\n"), file = log_file, append = TRUE)

            # Column data types
            col_types <- sapply(data, class)
            cat("\nColumn data types:\n")
            cat("\nColumn data types:\n", file = log_file, append = TRUE)

            for (i in seq_along(col_types)) {
                col_name <- names(col_types)[i]
                col_type <- col_types[i]
                cat(paste0("  - ", col_name, ": ", col_type, "\n"))
                cat(paste0("  - ", col_name, ": ", col_type, "\n"), file = log_file, append = TRUE)
            }

            # Check for primary key uniqueness if specified
            if (!is.null(primary_key) && primary_key %in% names(data)) {
                n_unique <- length(unique(data[[primary_key]]))
                is_unique <- n_unique == n_rows

                cat(paste0("\nPrimary key check (", primary_key, "): "))
                cat(paste0("\nPrimary key check (", primary_key, "): "), file = log_file, append = TRUE)

                if (is_unique) {
                    cat("PASSED - All values are unique\n")
                    cat("PASSED - All values are unique\n", file = log_file, append = TRUE)
                } else {
                    cat(paste0("FAILED - Only ", n_unique, " unique values out of ", n_rows, " rows\n"))
                    cat(paste0("FAILED - Only ", n_unique, " unique values out of ", n_rows, " rows\n"),
                        file = log_file, append = TRUE
                    )
                }
            }

            # Generate summary statistics
            cat("\nSummary statistics:\n")
            cat("\nSummary statistics:\n", file = log_file, append = TRUE)

            data_summary <- skimr::skim(data)
            print(data_summary)
            capture.output(print(data_summary), file = log_file, append = TRUE)

            # Create data quality report
            output_dir <- file.path(dirname(path), "validation")
            if (!dir.exists(output_dir)) {
                dir.create(output_dir)
            }

            report_file <- file.path(output_dir, paste0(name, "_validation_report.html"))

            # Generate data quality report
            cat(paste0("\nGenerating data quality report: ", report_file, "\n"))
            cat(paste0("\nGenerating data quality report: ", report_file, "\n"), file = log_file, append = TRUE)

            tryCatch(
                {
                    dataMaid::makeDataReport(data,
                        output = report_file,
                        replace = TRUE,
                        title = paste0(name, " Dataset Validation Report"),
                        reportTitle = paste0(name, " Dataset Validation")
                    )
                    cat("Report generated successfully.\n")
                    cat("Report generated successfully.\n", file = log_file, append = TRUE)
                },
                error = function(e) {
                    cat(paste0("Error generating report: ", e$message, "\n"))
                    cat(paste0("Error generating report: ", e$message, "\n"), file = log_file, append = TRUE)
                }
            )

            # Return success
            cat(paste0("\nValidation of ", name, " dataset completed.\n"))
            cat(paste0("\nValidation of ", name, " dataset completed.\n"), file = log_file, append = TRUE)
            return(TRUE)
        },
        error = function(e) {
            cat(paste0("ERROR: Failed to read file '", path, "': ", e$message, "\n"))
            cat(paste0("ERROR: Failed to read file '", path, "': ", e$message, "\n"), file = log_file, append = TRUE)
            return(FALSE)
        }
    )
}

# List all datasets to validate
datasets <- list(
    list(name = "Forestry", path = file.path(data_dir, "forestry", "forest_inventory.csv")),
    list(name = "Agriculture", path = file.path(data_dir, "agriculture", "crop_yields.csv")),
    list(name = "Ecology", path = file.path(data_dir, "ecology", "biodiversity.csv")),
    list(name = "Marine", path = file.path(data_dir, "marine", "ocean_data.csv")),
    list(name = "Environmental", path = file.path(data_dir, "environmental", "climate_data.csv")),
    list(name = "Geography", path = file.path(data_dir, "geography", "spatial.csv")),
    list(name = "Botany", path = file.path(data_dir, "botany", "plant_traits.csv")),
    list(name = "Entomology", path = file.path(data_dir, "entomology", "insects.csv")),
    list(name = "Epidemiology", path = file.path(data_dir, "epidemiology", "disease_data.csv")),
    list(name = "Economics", path = file.path(data_dir, "economics", "economic.csv"))
)

# Validate all datasets and collect results
results <- list()
for (dataset in datasets) {
    results[[dataset$name]] <- validate_dataset(dataset$name, dataset$path)
}

# Generate summary report
cat("\n## Validation Summary ##\n")
cat("\n## Validation Summary ##\n", file = log_file, append = TRUE)

success_count <- sum(unlist(results))
total_count <- length(datasets)
cat(sprintf(
    "Successfully validated %d of %d datasets (%.1f%%)\n\n",
    success_count, total_count, 100 * success_count / total_count
))
cat(
    sprintf(
        "Successfully validated %d of %d datasets (%.1f%%)\n\n",
        success_count, total_count, 100 * success_count / total_count
    ),
    file = log_file, append = TRUE
)

# List each dataset status
for (i in seq_along(datasets)) {
    dataset <- datasets[[i]]
    status <- if (results[[dataset$name]]) "SUCCESS" else "FAILED"
    cat(sprintf("%-15s: %s\n", dataset$name, status))
    cat(sprintf("%-15s: %s\n", dataset$name, status), file = log_file, append = TRUE)
}

cat("\nValidation process completed at", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
cat("\nValidation process completed at", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n",
    file = log_file, append = TRUE
)

# Create combined validation report for all datasets
cat("\nAttempting to create combined validation report...\n")
tryCatch(
    {
        valid_datasets <- list()

        for (dataset in datasets) {
            if (file.exists(dataset$path) && results[[dataset$name]]) {
                if (grepl("\\.csv$", dataset$path, ignore.case = TRUE)) {
                    data <- read.csv(dataset$path, stringsAsFactors = FALSE)
                } else if (grepl("\\.xlsx$|\\.xls$", dataset$path, ignore.case = TRUE)) {
                    data <- readxl::read_excel(dataset$path)
                } else {
                    next
                }

                # Add dataset source information
                data <- data %>%
                    mutate(dataset_source = dataset$name) %>%
                    select(dataset_source, everything())

                valid_datasets[[dataset$name]] <- data
            }
        }

        # Create a report directory if it doesn't exist
        report_dir <- file.path(data_dir, "validation_reports")
        if (!dir.exists(report_dir)) {
            dir.create(report_dir, recursive = TRUE)
        }

        # Save separate and combined reports
        timestamp_str <- format(Sys.time(), "%Y%m%d%H%M%S")
        combined_report_path <- file.path(report_dir, paste0("combined_validation_report_", timestamp_str, ".html"))

        dataMaid::makeDataReport(valid_datasets,
            output = combined_report_path,
            replace = TRUE,
            title = "Combined Dataset Validation Report",
            reportTitle = "Natural Sciences Datasets Validation"
        )

        cat(paste0("Combined report generated: ", combined_report_path, "\n"))
        cat(paste0("Combined report generated: ", combined_report_path, "\n"), file = log_file, append = TRUE)
    },
    error = function(e) {
        cat(paste0("Error creating combined report: ", e$message, "\n"))
        cat(paste0("Error creating combined report: ", e$message, "\n"), file = log_file, append = TRUE)
    }
)

cat("\nData validation process completed. See data_validation_log.txt for details.\n")
