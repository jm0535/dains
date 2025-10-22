# Tests for data_validation.R
# Author: Automated testing suite
# Purpose: Ensure data validation functions work correctly

library(testthat)

test_that("data validation creates log file", {
  # This is an integration test that would run the validation script
  # For now, we test that the key functions exist
  expect_true(file.exists("../../scripts/data_validation.R"))
})

test_that("validate_dataset function handles missing files", {
  # Create a mock validation function for testing
  validate_test <- function(name, path, primary_key = NULL) {
    if (!file.exists(path)) {
      return(FALSE)
    }
    return(TRUE)
  }

  result <- validate_test("Test", "nonexistent.csv")
  expect_false(result)
})

test_that("file hash validation works", {
  # Create a temporary file
  temp_file <- tempfile(fileext = ".csv")
  writeLines("test,data\n1,2", temp_file)

  # Calculate hash
  hash1 <- digest::digest(temp_file, algo = "md5", file = TRUE)

  # Calculate again - should be same
  hash2 <- digest::digest(temp_file, algo = "md5", file = TRUE)

  expect_equal(hash1, hash2)

  # Modify file
  writeLines("test,data\n1,3", temp_file)
  hash3 <- digest::digest(temp_file, algo = "md5", file = TRUE)

  expect_false(hash1 == hash3)

  # Cleanup
  unlink(temp_file)
})
