
# Test script to check for syntax errors in R code chunks
# This script extracts R code from .qmd files and checks if it can be parsed.

library(knitr)
library(testthat)

test_that("All chapters have valid R code", {
  chapters <- list.files("chapters", pattern = "\\.qmd$", full.names = TRUE)

  for (chapter in chapters) {
    message("Testing chapter: ", chapter)

    # Create a temporary file for the R code
    temp_r <- tempfile(fileext = ".R")

    # Extract R code
    tryCatch({
      knitr::purl(chapter, output = temp_r, quiet = TRUE)

      # Check if the code is parseable
      # We don't run it because it might take too long or require specific environment
      # But parsing ensures no syntax errors
      parse(file = temp_r)

      expect_true(TRUE, label = paste("Chapter", chapter, "parsed successfully"))
    }, error = function(e) {
      fail(paste("Failed to parse chapter", chapter, ":", e$message))
    })

    # Clean up
    if (file.exists(temp_r)) unlink(temp_r)
  }
})
