# Testing Documentation

This directory contains automated tests for the Data Analysis in Natural Sciences project.

## Test Structure

```
tests/
├── testthat.R                          # Main test runner
└── testthat/
    ├── test-workshop_functions.R       # Tests for R/workshop_functions.R
    ├── test-data_validation.R          # Tests for scripts/data_validation.R
    └── test-download_datasets.R        # Tests for scripts/download_datasets.R
```

## Running Tests

### Run All Tests

```r
# From R console
library(testthat)
test_dir("tests")
```

### Run Specific Test File

```r
library(testthat)
test_file("tests/testthat/test-workshop_functions.R")
```

### Run Tests from Command Line

```bash
Rscript -e 'library(testthat); test_dir("tests")'
```

## Test Coverage

Current test coverage includes:

- **Workshop Functions** (R/workshop_functions.R)
  - load_ecological_data: File validation, data loading, cleaning
  - correlation_table: Output format validation
  - scatter_plot_with_regression: Plot creation and customization
  - box_plot: Plot creation
  - t_test_analysis: Statistical analysis output
  - histogram_with_density: Distribution visualization

- **Data Validation** (scripts/data_validation.R)
  - File hash validation
  - Missing file handling

- **Data Download** (scripts/download_datasets.R)
  - URL validation
  - Directory creation
  - File integrity checks

## Writing New Tests

Follow these guidelines when adding tests:

1. **Test File Naming**: Use `test-<component>.R` format
2. **Test Structure**: Use `test_that()` blocks with descriptive names
3. **Assertions**: Use expect_* functions (expect_equal, expect_error, expect_true, etc.)
4. **Cleanup**: Always clean up temporary files and directories
5. **Independence**: Tests should not depend on each other

### Example Test

```r
test_that("function handles invalid input", {
  expect_error(
    my_function(invalid_input),
    "Expected error message"
  )
})

test_that("function returns correct output", {
  result <- my_function(valid_input)
  expect_equal(result, expected_output)
  expect_type(result, "list")
})
```

## Continuous Integration

Tests are automatically run in the CI/CD pipeline on every push and pull request.
All tests must pass before code can be merged.

## Test Data

Tests use temporary files and mock data to avoid dependencies on external data sources.
Use `tempfile()` and `tempdir()` for creating test fixtures.

## Troubleshooting

### Tests Failing Locally

1. Ensure all dependencies are installed: `Rscript scripts/install_packages.R`
2. Check that you're in the project root directory
3. Clear any cached data: `rm -rf _cache/`

### Skipping Tests

To skip a test temporarily:

```r
skip("Reason for skipping")
```

## Resources

- [testthat Documentation](https://testthat.r-lib.org/)
- [R Testing Best Practices](https://r-pkgs.org/tests.html)
- [Writing Effective Tests](https://testthat.r-lib.org/articles/test-fixtures.html)
