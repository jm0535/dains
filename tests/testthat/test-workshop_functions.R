# Tests for workshop_functions.R
# Author: Automated testing suite
# Purpose: Ensure workshop functions work correctly

library(testthat)
library(dplyr)
library(ggplot2)

# Source the functions to test
source("../../R/workshop_functions.R")

# Test load_ecological_data function
test_that("load_ecological_data validates file existence", {
  expect_error(
    load_ecological_data("nonexistent_file_12345.csv"),
    "File does not exist"
  )
})

test_that("load_ecological_data loads valid CSV files", {
  # Create a temporary test file
  temp_file <- tempfile(fileext = ".csv")
  test_data <- data.frame(
    Tree_Density_per_ha = c(100, 150, 200),
    Aboveground_Tree_Carbon_ton_per_ha = c(50, 75, 100),
    Aboveground_Tree_Carbon_ton_per_ha_per_year = c(5, 7.5, 10)
  )
  write.csv(test_data, temp_file, row.names = FALSE)

  # Test loading
  result <- load_ecological_data(temp_file, clean = FALSE)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 3)
  expect_equal(ncol(result), 3)

  # Cleanup
  unlink(temp_file)
})

test_that("load_ecological_data cleans data when requested", {
  # Create test data with NA values
  temp_file <- tempfile(fileext = ".csv")
  test_data <- data.frame(
    Tree_Density_per_ha = c(100, NA, 200),
    Aboveground_Tree_Carbon_ton_per_ha = c(50, 75, NA),
    Aboveground_Tree_Carbon_ton_per_ha_per_year = c(5, 7.5, 10)
  )
  write.csv(test_data, temp_file, row.names = FALSE)

  # Test cleaning
  result <- load_ecological_data(temp_file, clean = TRUE)
  expect_equal(nrow(result), 1)  # Only one complete row

  # Cleanup
  unlink(temp_file)
})

# Test correlation_table function
test_that("correlation_table requires valid packages", {
  # This test ensures the function checks for required packages
  # We can't easily test package absence, so we test with valid data
  test_data <- data.frame(x = 1:10, y = 1:10)

  # Should not error with valid data
  expect_no_error(
    result <- correlation_table(test_data, "x", "y")
  )
})

test_that("correlation_table returns kable object", {
  test_data <- data.frame(
    var1 = c(1, 2, 3, 4, 5),
    var2 = c(2, 4, 6, 8, 10)
  )

  result <- correlation_table(test_data, "var1", "var2", method = "pearson")
  expect_s3_class(result, "knitr_kable")
})

# Test scatter_plot_with_regression function
test_that("scatter_plot_with_regression creates ggplot object", {
  test_data <- data.frame(x = 1:10, y = 1:10)

  result <- scatter_plot_with_regression(test_data, "x", "y")
  expect_s3_class(result, "ggplot")
})

test_that("scatter_plot_with_regression uses custom labels", {
  test_data <- data.frame(x = 1:10, y = 1:10)

  result <- scatter_plot_with_regression(
    test_data, "x", "y",
    title = "Test Title",
    x_lab = "X Label",
    y_lab = "Y Label"
  )

  expect_s3_class(result, "ggplot")
  expect_equal(result$labels$title, "Test Title")
  expect_equal(result$labels$x, "X Label")
  expect_equal(result$labels$y, "Y Label")
})

# Test box_plot function
test_that("box_plot creates ggplot object", {
  test_data <- data.frame(
    group = rep(c("A", "B"), each = 5),
    value = c(1:5, 6:10)
  )

  result <- box_plot(test_data, "group", "value")
  expect_s3_class(result, "ggplot")
})

# Test t_test_analysis function
test_that("t_test_analysis returns list with correct components", {
  test_data <- data.frame(
    group = rep(c("A", "B"), each = 10),
    value = c(rnorm(10, mean = 5), rnorm(10, mean = 6))
  )

  result <- t_test_analysis(test_data, "value", "group", "A", "B")

  expect_type(result, "list")
  expect_true("test_result" %in% names(result))
  expect_true("table" %in% names(result))
  expect_true("plot" %in% names(result))
  expect_s3_class(result$plot, "ggplot")
})

# Test histogram_with_density function
test_that("histogram_with_density creates ggplot object", {
  test_data <- data.frame(values = rnorm(100))

  result <- histogram_with_density(test_data, "values", bins = 20)
  expect_s3_class(result, "ggplot")
})

test_that("histogram_with_density uses custom parameters", {
  test_data <- data.frame(values = rnorm(100))

  result <- histogram_with_density(
    test_data, "values",
    bins = 15,
    title = "Test Distribution",
    fill_color = "red",
    line_color = "blue"
  )

  expect_s3_class(result, "ggplot")
  expect_equal(result$labels$title, "Test Distribution")
})
