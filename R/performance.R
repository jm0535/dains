# Performance Monitoring Utilities
# Author: Automated improvement script
# Purpose: Provide tools to monitor and log performance metrics

#' Time Function Execution
#'
#' Wrapper to measure and log function execution time
#'
#' @param f Function to execute
#' @param description Description of what's being timed
#' @param ... Arguments to pass to the function
#' @param verbose Whether to print timing information (default: TRUE)
#' @return List containing the result and timing information
#' @examples
#' result <- time_function(mean, "Calculate mean", x = 1:1000000)
#' @export
time_function <- function(f, description = "Operation", ..., verbose = TRUE) {
  start_time <- Sys.time()
  start_memory <- if (requireNamespace("pryr", quietly = TRUE)) {
    pryr::mem_used()
  } else {
    NA
  }

  result <- tryCatch(
    {
      f(...)
    },
    error = function(e) {
      duration <- as.numeric(difftime(Sys.time(), start_time, units = "secs"))
      if (verbose) {
        cat(sprintf(
          "❌ FAILED: %s (%.2f seconds)\nError: %s\n",
          description, duration, e$message
        ))
      }
      stop(e)
    }
  )

  end_time <- Sys.time()
  end_memory <- if (requireNamespace("pryr", quietly = TRUE)) {
    pryr::mem_used()
  } else {
    NA
  }

  duration <- as.numeric(difftime(end_time, start_time, units = "secs"))
  memory_delta <- if (!is.na(start_memory) && !is.na(end_memory)) {
    as.numeric(end_memory - start_memory)
  } else {
    NA
  }

  if (verbose) {
    cat(sprintf("✅ COMPLETED: %s\n", description))
    cat(sprintf("   Duration: %.2f seconds", duration))

    if (duration < 1) {
      cat(sprintf(" (%.0f ms)", duration * 1000))
    }
    cat("\n")

    if (!is.na(memory_delta)) {
      cat(sprintf(
        "   Memory change: %s\n",
        format_bytes(abs(memory_delta), sign = sign(memory_delta))
      ))
    }
  }

  return(list(
    result = result,
    duration_sec = duration,
    memory_delta_bytes = memory_delta,
    start_time = start_time,
    end_time = end_time
  ))
}

#' Format Bytes for Display
#'
#' Convert bytes to human-readable format
#'
#' @param bytes Number of bytes
#' @param sign Sign of the change (1 for increase, -1 for decrease)
#' @return Formatted string
format_bytes <- function(bytes, sign = 1) {
  units <- c("B", "KB", "MB", "GB", "TB")
  unit_idx <- 1

  value <- abs(bytes)

  while (value >= 1024 && unit_idx < length(units)) {
    value <- value / 1024
    unit_idx <- unit_idx + 1
  }

  prefix <- if (sign > 0) "+" else if (sign < 0) "-" else ""

  return(sprintf("%s%.2f %s", prefix, value, units[unit_idx]))
}

#' Profile Code Block
#'
#' Profile a code block and generate performance report
#'
#' @param expr Expression to profile
#' @param description Description of the operation
#' @return Profiling results
#' @examples
#' \dontrun{
#' profile_code({
#'   x <- rnorm(1000000)
#'   mean(x)
#' }, "Generate and summarize random numbers")
#' }
#' @export
profile_code <- function(expr, description = "Code block") {
  if (!requireNamespace("profvis", quietly = TRUE)) {
    warning("profvis package not available. Install with: install.packages('profvis')")
    return(time_function(function() eval(expr), description))
  }

  cat(sprintf("📊 Profiling: %s\n", description))

  result <- profvis::profvis({
    eval(expr)
  })

  return(result)
}

#' Benchmark Multiple Approaches
#'
#' Compare performance of different approaches to the same task
#'
#' @param ... Named expressions to benchmark
#' @param times Number of times to run each expression (default: 10)
#' @return Data frame with benchmark results
#' @examples
#' \dontrun{
#' results <- benchmark_approaches(
#'   base_r = sum(1:1000),
#'   vectorized = Reduce("+", 1:1000),
#'   times = 100
#' )
#' }
#' @export
benchmark_approaches <- function(..., times = 10) {
  if (!requireNamespace("microbenchmark", quietly = TRUE)) {
    warning("microbenchmark package not available. Using simple timing.")

    exprs <- list(...)
    results <- data.frame(
      approach = character(),
      mean_ms = numeric(),
      sd_ms = numeric(),
      stringsAsFactors = FALSE
    )

    for (name in names(exprs)) {
      timings <- numeric(times)
      for (i in 1:times) {
        start <- Sys.time()
        eval(exprs[[name]])
        timings[i] <- as.numeric(difftime(Sys.time(), start, units = "secs")) * 1000
      }

      results <- rbind(results, data.frame(
        approach = name,
        mean_ms = mean(timings),
        sd_ms = sd(timings),
        stringsAsFactors = FALSE
      ))
    }

    return(results)
  }

  result <- microbenchmark::microbenchmark(..., times = times)
  return(summary(result))
}

#' Create Performance Log Entry
#'
#' Log performance metrics to a file
#'
#' @param operation Description of the operation
#' @param duration Duration in seconds
#' @param memory_mb Memory used in MB
#' @param log_file Path to log file (default: "logs/performance.log")
#' @export
log_performance <- function(operation, duration, memory_mb = NA,
                            log_file = "logs/performance.log") {
  # Ensure log directory exists
  log_dir <- dirname(log_file)
  if (!dir.exists(log_dir)) {
    dir.create(log_dir, recursive = TRUE)
  }

  # Create log entry
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  memory_str <- if (!is.na(memory_mb)) {
    sprintf("%.2f", memory_mb)
  } else {
    "NA"
  }

  log_entry <- sprintf(
    "%s | %s | %.4f sec | %s MB\n",
    timestamp, operation, duration, memory_str
  )

  # Write to log file
  cat(log_entry, file = log_file, append = TRUE)
}
