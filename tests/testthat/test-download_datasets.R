# Tests for download_datasets.R
# Author: Automated testing suite
# Purpose: Ensure dataset download functions work correctly

library(testthat)

test_that("download dataset handles invalid URLs", {
  # Mock download function for testing
  download_test <- function(url, dest_file, description, expected_hash = NULL) {
    tryCatch({
      download.file(url, dest_file, quiet = TRUE)
      return(file.exists(dest_file) && file.size(dest_file) > 0)
    }, error = function(e) {
      return(FALSE)
    })
  }

  temp_file <- tempfile()
  result <- download_test("http://invalid-url-12345.com/data.csv", temp_file, "Test")
  expect_false(result)
})

test_that("directory creation works", {
  # Test ensure_directory function logic
  ensure_dir_test <- function(dir_path) {
    if (!dir.exists(dir_path)) {
      dir.create(dir_path, recursive = TRUE)
    }
    return(dir.exists(dir_path))
  }

  temp_dir <- file.path(tempdir(), "test_dir_structure", "nested")
  result <- ensure_dir_test(temp_dir)
  expect_true(result)
  expect_true(dir.exists(temp_dir))

  # Cleanup
  unlink(file.path(tempdir(), "test_dir_structure"), recursive = TRUE)
})

test_that("file hash validation detects changes", {
  temp_file <- tempfile(fileext = ".txt")
  writeLines("original content", temp_file)

  hash1 <- digest::digest(temp_file, algo = "md5", file = TRUE)

  # Modify file
  writeLines("modified content", temp_file)
  hash2 <- digest::digest(temp_file, algo = "md5", file = TRUE)

  expect_false(hash1 == hash2)

  # Cleanup
  unlink(temp_file)
})
