# Structured Logging Infrastructure
# Author: Automated improvement script
# Purpose: Provide structured logging capabilities for all R scripts

#' Setup Logger with Structured Output
#'
#' Initializes a logging system with different levels and structured output
#'
#' @param log_file Path to the log file (default: "logs/project.log")
#' @param log_level Minimum level to log ("DEBUG", "INFO", "WARN", "ERROR")
#' @param console_output Whether to also print to console (default: TRUE)
#' @return NULL (side effect: configures logging)
#' @examples
#' setup_logger("logs/data_analysis.log", "INFO")
#' log_info("Starting analysis")
#' log_error("Failed to load data", error = e$message)
setup_logger <- function(log_file = "logs/project.log",
                         log_level = "INFO",
                         console_output = TRUE) {
  # Create logs directory if it doesn't exist
  log_dir <- dirname(log_file)
  if (!dir.exists(log_dir)) {
    dir.create(log_dir, recursive = TRUE)
  }

  # Store configuration in options
  options(
    logger_file = log_file,
    logger_level = log_level,
    logger_console = console_output
  )

  # Write header to log file
  cat(
    sprintf(
      "=== Log Session Started: %s ===\n",
      format(Sys.time(), "%Y-%m-%d %H:%M:%S")
    ),
    file = log_file,
    append = TRUE
  )

  invisible(NULL)
}

#' Log a message at the specified level
#'
#' Internal function to write structured log messages
#'
#' @param level Log level ("DEBUG", "INFO", "WARN", "ERROR")
#' @param message Main log message
#' @param ... Additional named parameters to include in log
#' @return NULL (side effect: writes to log)
log_message <- function(level, message, ...) {
  # Get configuration
  log_file <- getOption("logger_file", "logs/project.log")
  log_level <- getOption("logger_level", "INFO")
  console_output <- getOption("logger_console", TRUE)

  # Define level hierarchy
  levels <- c("DEBUG" = 1, "INFO" = 2, "WARN" = 3, "ERROR" = 4)

  # Check if message should be logged
  if (levels[level] < levels[log_level]) {
    return(invisible(NULL))
  }

  # Build structured log entry
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  additional_fields <- list(...)

  log_entry <- sprintf("[%s] [%s] %s", timestamp, level, message)

  # Add additional fields if provided
  if (length(additional_fields) > 0) {
    fields_str <- paste(
      names(additional_fields),
      sapply(additional_fields, as.character),
      sep = "=",
      collapse = ", "
    )
    log_entry <- paste(log_entry, sprintf("| %s", fields_str))
  }

  # Write to file
  cat(log_entry, "\n", file = log_file, append = TRUE)

  # Write to console if enabled
  if (console_output) {
    # Add color coding for console output
    color_codes <- list(
      DEBUG = "\033[0;36m", # Cyan
      INFO = "\033[0;32m", # Green
      WARN = "\033[0;33m", # Yellow
      ERROR = "\033[0;31m" # Red
    )
    reset_color <- "\033[0m"

    if (level %in% names(color_codes)) {
      cat(color_codes[[level]], log_entry, reset_color, "\n", sep = "")
    } else {
      cat(log_entry, "\n")
    }
  }

  invisible(NULL)
}

#' Log DEBUG message
#' @param message Log message
#' @param ... Additional named parameters
#' @export
log_debug <- function(message, ...) {
  log_message("DEBUG", message, ...)
}

#' Log INFO message
#' @param message Log message
#' @param ... Additional named parameters
#' @export
log_info <- function(message, ...) {
  log_message("INFO", message, ...)
}

#' Log WARN message
#' @param message Log message
#' @param ... Additional named parameters
#' @export
log_warn <- function(message, ...) {
  log_message("WARN", message, ...)
}

#' Log ERROR message
#' @param message Log message
#' @param ... Additional named parameters
#' @export
log_error <- function(message, ...) {
  log_message("ERROR", message, ...)
}

#' Log function execution time
#'
#' Wrapper to time a function and log its duration
#'
#' @param f Function to execute
#' @param message Description of the operation
#' @param ... Arguments to pass to the function
#' @return Result of the function
#' @export
log_timed <- function(f, message, ...) {
  start_time <- Sys.time()
  log_info(sprintf("Starting: %s", message))

  result <- tryCatch(
    {
      f(...)
    },
    error = function(e) {
      duration <- as.numeric(difftime(Sys.time(), start_time, units = "secs"))
      log_error(
        sprintf("Failed: %s", message),
        duration_sec = round(duration, 2),
        error = e$message
      )
      stop(e)
    }
  )

  duration <- as.numeric(difftime(Sys.time(), start_time, units = "secs"))
  log_info(
    sprintf("Completed: %s", message),
    duration_sec = round(duration, 2)
  )

  return(result)
}

# Initialize default logger if not already set up
if (is.null(getOption("logger_file"))) {
  setup_logger()
}
