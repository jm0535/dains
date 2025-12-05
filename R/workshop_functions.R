# Workshop Manual Helper Functions
# This file contains reusable functions for the data analysis workshop manual

#' Load and prepare ecological dataset
#'
#' This function loads data from CSV files with comprehensive validation and error handling.
#' It checks for file existence, validates data structure, and optionally cleans missing values.
#'
#' @param file_path Path to the CSV file (absolute or relative)
#' @param clean Logical, whether to clean the data (remove NAs, etc.)
#' @param required_cols Optional character vector of required column names
#' @param verbose Logical, whether to print informative messages (default: TRUE)
#' @return A tibble with the loaded and prepared data
#' @examples
#' \dontrun{
#' # Basic usage
#' forest_data <- load_ecological_data("./data/forestry/forest_inventory.csv")
#'
#' # With required columns validation
#' forest_data <- load_ecological_data(
#'   "./data/forestry/forest_inventory.csv",
#'   required_cols = c("Tree_Density_per_ha", "Carbon")
#' )
#'
#' # Load without cleaning
#' raw_data <- load_ecological_data("./data/forestry/forest_inventory.csv", clean = FALSE)
#' }
#' @export
load_ecological_data <- function(file_path, clean = TRUE, required_cols = NULL, verbose = TRUE) {
  # Input validation
  if (!is.character(file_path) || length(file_path) != 1) {
    stop("file_path must be a single character string")
  }

  if (!is.logical(clean)) {
    stop("clean must be a logical value (TRUE or FALSE)")
  }

  # Check if file exists
  if (!file.exists(file_path)) {
    stop(sprintf(
      "File does not exist: '%s'\nCurrent working directory: '%s'\nPlease check the file path.",
      file_path, getwd()
    ))
  }

  # Check file extension
  if (!grepl("\\.(csv|CSV)$", file_path)) {
    warning(sprintf(
      "File '%s' does not have a .csv extension. Attempting to read anyway.",
      basename(file_path)
    ))
  }

  # Load data with error handling
  if (verbose) message("Loading data from: ", file_path)

  data <- tryCatch(
    {
      readr::read_csv(file_path, show_col_types = FALSE)
    },
    error = function(e) {
      stop(sprintf(
        "Failed to read CSV file '%s'.\nError: %s\nPlease ensure the file is a valid CSV format.",
        file_path, e$message
      ))
    }
  )

  # Validate data structure
  if (nrow(data) == 0) {
    stop(sprintf("File '%s' contains no data rows.", file_path))
  }

  if (ncol(data) == 0) {
    stop(sprintf("File '%s' contains no columns.", file_path))
  }

  if (verbose) {
    message(sprintf("Loaded %d rows and %d columns", nrow(data), ncol(data)))
  }

  # Validate required columns if specified
  if (!is.null(required_cols)) {
    if (!is.character(required_cols)) {
      stop("required_cols must be a character vector")
    }

    missing_cols <- setdiff(required_cols, names(data))
    if (length(missing_cols) > 0) {
      stop(sprintf(
        "Missing required columns: %s\nAvailable columns: %s",
        paste(missing_cols, collapse = ", "),
        paste(names(data), collapse = ", ")
      ))
    }

    if (verbose) {
      message("All required columns present: ", paste(required_cols, collapse = ", "))
    }
  }

  # Clean data if requested
  if (clean) {
    original_rows <- nrow(data)

    # Define columns to check for NAs
    clean_cols <- c(
      "Tree_Density_per_ha",
      "Aboveground_Tree_Carbon_ton_per_ha",
      "Aboveground_Tree_Carbon_ton_per_ha_per_year"
    )

    # Only use columns that exist in the data
    existing_clean_cols <- intersect(clean_cols, names(data))

    if (length(existing_clean_cols) > 0) {
      data <- data %>%
        tidyr::drop_na(dplyr::any_of(existing_clean_cols))

      removed_rows <- original_rows - nrow(data)

      if (removed_rows > 0 && verbose) {
        message(sprintf(
          "Removed %d rows (%.1f%%) with missing values in: %s",
          removed_rows,
          100 * removed_rows / original_rows,
          paste(existing_clean_cols, collapse = ", ")
        ))
      }

      if (nrow(data) == 0) {
        stop("All rows were removed during cleaning. Check for excessive missing values in key columns.")
      }
    } else if (verbose) {
      message("No standard columns found for cleaning. Returning data as-is.")
    }
  }

  return(data)
}

#' Create a formatted correlation table
#' 
#' @param data Dataset to analyze
#' @param var1 First variable name
#' @param var2 Second variable name
#' @param method Correlation method ("pearson", "spearman", or "kendall")
#' @return A formatted kable table with correlation results
#' @examples
#' correlation_table(forest_data, "Tree_Density_per_ha", "Aboveground_Tree_Carbon_ton_per_ha")
correlation_table <- function(data, var1, var2, method = "pearson") {
  # Check if required packages are available
  if (!requireNamespace("rstatix", quietly = TRUE) || 
      !requireNamespace("knitr", quietly = TRUE)) {
    stop("Packages 'rstatix' and 'knitr' are required")
  }
  
  # Perform correlation test
  result <- data %>% 
    rstatix::cor_test(
      vars = var1,
      vars2 = var2,
      alternative = "two.sided",
      method = method,
      conf.level = 0.95,
      use = "pairwise.complete.obs"
    )
  
  # Format the result as a table
  formatted_table <- result %>% 
    knitr::kable(
      caption = paste("Correlation between", var1, "and", var2),
      digits = 3,
      col.names = c("Variable 1", "Variable 2", "Correlation", "Statistic", "p-value", "Method", "Alternative"),
      align = c('l', 'l', 'c', 'c', 'c', 'l', 'l')
    )
  
  return(formatted_table)
}

#' Create a standard scatter plot with regression line
#' 
#' @param data Dataset to plot
#' @param x_var X-axis variable name
#' @param y_var Y-axis variable name
#' @param title Plot title
#' @param x_lab X-axis label
#' @param y_lab Y-axis label
#' @param point_size Size of points
#' @param line_color Color of regression line
#' @return A ggplot object
#' @examples
#' scatter_plot_with_regression(forest_data, 
#'                             "Tree_Density_per_ha", 
#'                             "Aboveground_Tree_Carbon_ton_per_ha")
scatter_plot_with_regression <- function(data, 
                                        x_var, 
                                        y_var, 
                                        title = NULL,
                                        x_lab = NULL, 
                                        y_lab = NULL,
                                        point_size = 3,
                                        line_color = "blue") {
  # Check if required package is available
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required")
  }
  
  # Set default labels if not provided
  if (is.null(x_lab)) x_lab <- x_var
  if (is.null(y_lab)) y_lab <- y_var
  if (is.null(title)) title <- paste("Relationship between", x_var, "and", y_var)
  
  # Create the plot
  plot <- ggplot2::ggplot(data, ggplot2::aes_string(x = x_var, y = y_var)) +
    ggplot2::geom_point(size = point_size, alpha = 0.7) +
    ggplot2::geom_smooth(method = "lm", color = line_color) +
    ggplot2::labs(title = title, x = x_lab, y = y_lab) +
    ggplot2::theme_bw()
  
  return(plot)
}

#' Create a box plot for comparing groups
#' 
#' @param data Dataset to plot
#' @param x_var Grouping variable name
#' @param y_var Response variable name
#' @param title Plot title
#' @param x_lab X-axis label
#' @param y_lab Y-axis label
#' @return A ggplot object
#' @examples
#' box_plot(forest_data, 
#'         "Management_regime", 
#'         "Aboveground_Tree_Carbon_ton_per_ha")
box_plot <- function(data, 
                    x_var, 
                    y_var, 
                    title = NULL,
                    x_lab = NULL, 
                    y_lab = NULL) {
  # Check if required package is available
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required")
  }
  
  # Set default labels if not provided
  if (is.null(x_lab)) x_lab <- x_var
  if (is.null(y_lab)) y_lab <- y_var
  if (is.null(title)) title <- paste(y_var, "by", x_var)
  
  # Create the plot
  plot <- ggplot2::ggplot(data, ggplot2::aes_string(x = x_var, y = y_var, fill = x_var)) +
    ggplot2::geom_boxplot() +
    ggplot2::labs(title = title, x = x_lab, y = y_lab) +
    ggplot2::theme_bw() +
    ggplot2::theme(legend.position = "none")
  
  return(plot)
}

#' Perform and visualize t-test
#' 
#' @param data Dataset to analyze
#' @param var Response variable name
#' @param group Grouping variable name
#' @param group1 First group value
#' @param group2 Second group value
#' @param var_equal Logical, whether to assume equal variances
#' @return A list containing the test result and a visualization
#' @examples
#' t_test_analysis(forest_data, 
#'                "Aboveground_Tree_Carbon_ton_per_ha", 
#'                "Management_regime",
#'                "Natural", 
#'                "Plantation")
t_test_analysis <- function(data, 
                           var, 
                           group, 
                           group1, 
                           group2, 
                           var_equal = FALSE) {
  # Check if required packages are available
  if (!requireNamespace("rstatix", quietly = TRUE) || 
      !requireNamespace("ggplot2", quietly = TRUE) ||
      !requireNamespace("knitr", quietly = TRUE)) {
    stop("Packages 'rstatix', 'ggplot2', and 'knitr' are required")
  }
  
  # Filter data for the two groups
  filtered_data <- data %>%
    dplyr::filter(!!dplyr::sym(group) %in% c(group1, group2))
  
  # Perform t-test
  t_test_result <- filtered_data %>%
    rstatix::t_test(
      formula = as.formula(paste(var, "~", group)),
      var.equal = var_equal
    )
  
  # Create visualization
  plot <- ggplot2::ggplot(filtered_data, 
                         ggplot2::aes_string(x = group, y = var, fill = group)) +
    ggplot2::geom_boxplot(alpha = 0.7) +
    ggplot2::stat_summary(fun = mean, geom = "point", shape = 18, size = 4, color = "black") +
    ggplot2::labs(
      title = paste("T-test:", var, "by", group),
      subtitle = paste("p-value =", format(t_test_result$p, digits = 3)),
      x = group,
      y = var
    ) +
    ggplot2::theme_bw()
  
  # Format the result as a table
  formatted_table <- t_test_result %>%
    knitr::kable(
      caption = paste("T-test results for", var, "by", group),
      digits = 3
    )
  
  # Return both the test result and visualization
  return(list(
    test_result = t_test_result,
    table = formatted_table,
    plot = plot
  ))
}

#' Create a histogram with density curve
#' 
#' @param data Dataset to plot
#' @param var Variable name to visualize
#' @param bins Number of bins for histogram
#' @param title Plot title
#' @param x_lab X-axis label
#' @param fill_color Fill color for histogram
#' @param line_color Color for density line
#' @return A ggplot object
#' @examples
#' histogram_with_density(CO2, "uptake", bins = 20)
histogram_with_density <- function(data, 
                                  var, 
                                  bins = 30,
                                  title = NULL,
                                  x_lab = NULL,
                                  fill_color = "skyblue",
                                  line_color = "navy") {
  # Check if required package is available
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required")
  }
  
  # Set default labels if not provided
  if (is.null(x_lab)) x_lab <- var
  if (is.null(title)) title <- paste("Distribution of", var)
  
  # Create the plot
  plot <- ggplot2::ggplot(data, ggplot2::aes_string(x = var)) +
    ggplot2::geom_histogram(
      ggplot2::aes(y = ..density..),
      bins = bins,
      fill = fill_color,
      color = "white",
      alpha = 0.7
    ) +
    ggplot2::geom_density(color = line_color, size = 1) +
    ggplot2::labs(title = title, x = x_lab, y = "Density") +
    ggplot2::theme_bw()
  
  return(plot)
}
