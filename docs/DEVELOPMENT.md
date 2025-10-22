# Development Guide

Complete guide for developers contributing to the Data Analysis in Natural Sciences project.

## Table of Contents

- [Getting Started](#getting-started)
- [Development Environment](#development-environment)
- [Project Structure](#project-structure)
- [Development Workflow](#development-workflow)
- [Testing](#testing)
- [Code Style](#code-style)
- [Documentation](#documentation)
- [Troubleshooting](#troubleshooting)

## Getting Started

### Prerequisites

Before you begin, ensure you have:

- **R** (version 4.2.0 or higher)
  ```bash
  # Check version
  R --version
  ```

- **RStudio** (recommended, latest version)
  - Download from: https://posit.co/downloads/

- **Quarto** (version 1.3.450 or higher)
  ```bash
  # Check version
  quarto --version

  # Install if needed
  # Download from: https://quarto.org/docs/get-started/
  ```

- **Git** (for version control)
  ```bash
  git --version
  ```

### Initial Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/jm0535/Data-Analysis-in-Natural-Sciences.git
   cd Data-Analysis-in-Natural-Sciences
   ```

2. **Set up R environment**
   ```r
   # Open R or RStudio
   # Install renv if not already installed
   install.packages("renv")

   # Restore project dependencies
   renv::restore()
   ```

3. **Download datasets**
   ```r
   source("scripts/download_datasets.R")
   ```

4. **Install additional dependencies**
   ```r
   source("scripts/install_packages.R")
   ```

5. **Verify setup**
   ```r
   # Run tests
   testthat::test_dir("tests")

   # Try building book
   quarto render
   ```

## Development Environment

### RStudio Configuration

Recommended RStudio settings:

1. **Tools > Global Options > Code**
   - Soft-wrap R source files: ✅
   - Continue comment lines: ✅
   - Auto-indent code: ✅

2. **Tools > Global Options > Code > Display**
   - Show margin (80 characters): ✅
   - Show whitespace characters: ✅

3. **Tools > Global Options > Code > Saving**
   - Ensure line ending conversion: Posix (LF)
   - Strip trailing whitespace: ✅

4. **Tools > Global Options > R Markdown**
   - Show output preview in: Viewer Pane
   - Show equation and image previews: ✅

### Directory Structure

```
Data-Analysis-in-Natural-Sciences/
├── .github/              # CI/CD workflows
├── chapters/             # Book chapters (edit these)
├── data/                 # Datasets and schemas
├── docs/                 # Rendered output (generated)
├── R/                    # Reusable functions (edit these)
├── scripts/              # Utility scripts
├── tests/                # Test files (add tests here)
├── _quarto.yml           # Quarto configuration
├── .Rprofile             # R startup configuration
└── renv.lock            # Package versions (managed by renv)
```

### Environment Variables

Create a `.Renviron` file (gitignored) for local settings:

```bash
# .Renviron
R_MAX_VSIZE=32Gb
R_ENABLE_JIT=3
```

## Development Workflow

### Standard Workflow

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make changes**
   - Edit chapter files (`.qmd`)
   - Add/modify functions in `R/`
   - Update documentation
   - Add tests

3. **Test locally**
   ```r
   # Run tests
   testthat::test_dir("tests")

   # Check specific function
   source("R/workshop_functions.R")
   # Test your function...
   ```

4. **Render book locally**
   ```bash
   quarto render
   # Open docs/index.html to preview
   ```

5. **Commit changes**
   ```bash
   git add .
   git commit -m "feat: add new statistical test explanation"
   ```

6. **Push and create PR**
   ```bash
   git push -u origin feature/your-feature-name
   # Create PR on GitHub
   ```

### Working with Chapters

#### Creating a New Chapter

1. Create file: `chapters/##-chapter-name.qmd`
2. Add YAML frontmatter:
   ```yaml
   ---
   prefer-html: true
   ---
   ```
3. Add to `_quarto.yml`:
   ```yaml
   chapters:
     - chapters/##-chapter-name.qmd
   ```

#### Chapter Structure Template

```markdown
---
prefer-html: true
---

# Chapter Title

## Introduction

Brief overview of what this chapter covers.

## Main Content

### Subsection

Explanation with code examples:

\`\`\`{r}
# R code here
data <- read.csv("data/...")
\`\`\`

::: {.callout-note}
## Code Explanation
Explain what the code does...
:::

::: {.callout-important}
## Results Interpretation
Explain what the results mean...
:::

::: {.callout-tip}
## PROFESSIONAL TIP
Best practices for...
:::

## Summary

Key takeaways from this chapter.
```

### Working with R Functions

#### Adding a New Function

1. Add to appropriate file in `R/`:
   - Data manipulation → `workshop_functions.R`
   - Plotting → `plotting_themes.R`
   - Logging → `logging.R`
   - Performance → `performance.R`

2. Use roxygen2 documentation:
   ```r
   #' Function Title
   #'
   #' Detailed description of what the function does
   #'
   #' @param param1 Description of parameter 1
   #' @param param2 Description of parameter 2
   #' @return Description of return value
   #' @examples
   #' \dontrun{
   #' result <- my_function(param1, param2)
   #' }
   #' @export
   my_function <- function(param1, param2) {
     # Implementation
   }
   ```

3. Add error handling:
   ```r
   my_function <- function(param1) {
     # Validate inputs
     if (!is.numeric(param1)) {
       stop("param1 must be numeric")
     }

     # Implement with tryCatch
     result <- tryCatch({
       # Main logic
     }, error = function(e) {
       log_error("Function failed", error = e$message)
       stop(e)
     })

     return(result)
   }
   ```

4. Write tests (see Testing section)

## Testing

### Running Tests

```r
# Run all tests
testthat::test_dir("tests")

# Run specific test file
testthat::test_file("tests/testthat/test-workshop_functions.R")

# Run with coverage (requires covr package)
covr::package_coverage()
```

### Writing Tests

Create test file: `tests/testthat/test-your_feature.R`

```r
# tests/testthat/test-workshop_functions.R

test_that("load_ecological_data handles missing files", {
  expect_error(
    load_ecological_data("nonexistent.csv"),
    "File does not exist"
  )
})

test_that("load_ecological_data validates columns", {
  temp_file <- tempfile(fileext = ".csv")
  write.csv(data.frame(x = 1:5), temp_file, row.names = FALSE)

  expect_no_error(
    result <- load_ecological_data(temp_file, required_cols = "x")
  )

  expect_error(
    load_ecological_data(temp_file, required_cols = "missing_col"),
    "Missing required columns"
  )

  unlink(temp_file)
})
```

### Test Guidelines

- **Descriptive names**: `test_that("function handles invalid input")`
- **One concept per test**: Don't test multiple things in one test
- **Clean up**: Remove temp files, restore options
- **Independence**: Tests shouldn't depend on each other
- **Fast**: Keep tests quick (< 1 second each)

## Code Style

### R Code Style

Follow the [tidyverse style guide](https://style.tidyverse.org/):

#### Naming
```r
# Good
calculate_mean_value <- function(x) { }
my_variable <- 42

# Avoid
CalculateMeanValue <- function(x) { }
myVariable <- 42
```

#### Spacing
```r
# Good
x <- 5 + 3
my_function(a = 1, b = 2)

# Avoid
x<-5+3
my_function(a=1,b=2)
```

#### Line Length
- Maximum 80 characters
- Break long lines logically:
  ```r
  # Good
  long_function_name(
    argument1 = value1,
    argument2 = value2,
    argument3 = value3
  )
  ```

#### Pipes
```r
# Good
data %>%
  filter(condition) %>%
  select(columns) %>%
  summarize(stat = mean(value))
```

### Checking Style

```r
# Install styler
install.packages("styler")

# Check file style
styler::style_file("R/workshop_functions.R")

# Check directory
styler::style_dir("R")

# Check with lintr
lintr::lint("R/workshop_functions.R")
```

### Quarto/Markdown Style

- Use **ATX-style headers** (# Header)
- One sentence per line for easier diffs
- Code blocks with language specification:
  ```markdown
  \`\`\`{r}
  # R code
  \`\`\`
  ```
- Alt text for all images
- Descriptive link text (not "click here")

## Documentation

### Documenting Functions

Use roxygen2 format:

```r
#' Calculate Descriptive Statistics
#'
#' Computes mean, median, and standard deviation for a numeric vector,
#' with options to handle missing values.
#'
#' @param x A numeric vector
#' @param na.rm Logical; should missing values be removed? (default: TRUE)
#' @param verbose Logical; print progress messages? (default: FALSE)
#'
#' @return A named list with three elements:
#'   \item{mean}{Arithmetic mean}
#'   \item{median}{Median value}
#'   \item{sd}{Standard deviation}
#'
#' @examples
#' data <- c(1, 2, 3, NA, 5)
#' stats <- calculate_stats(data)
#' stats$mean  # 2.75
#'
#' # With NA removal
#' stats <- calculate_stats(data, na.rm = TRUE)
#'
#' @export
#' @seealso \code{\link{summary}} for more comprehensive statistics
calculate_stats <- function(x, na.rm = TRUE, verbose = FALSE) {
  # Implementation
}
```

### Updating Documentation

1. Edit roxygen2 comments in source files
2. Generate documentation:
   ```r
   roxygen2::roxygenise()
   ```
3. Check generated docs in `man/` directory

### Writing Chapter Documentation

- **Clear headings**: Descriptive, hierarchical
- **Code examples**: Working, tested examples
- **Explanations**: What, why, and how
- **Professional tips**: Practical advice
- **Visual aids**: Plots, tables, diagrams

## Common Tasks

### Adding a Dataset

1. **Edit `scripts/download_datasets.R`**:
   ```r
   datasets <- list(
     # ... existing datasets ...
     list(
       name = "NewDataset",
       directory = "newcategory",
       filename = "data.csv",
       url = "https://source.com/data.csv",
       citation_source = "Source Name",
       citation_text = "Full citation...",
       description = "Description of dataset"
     )
   )
   ```

2. **Create validation schema**: `data/schemas/newcategory_schema.R`

3. **Test download**:
   ```r
   source("scripts/download_datasets.R")
   ```

4. **Document in README**

### Updating Dependencies

```r
# Install new package
install.packages("newpackage")

# Update snapshot
renv::snapshot()

# Commit renv.lock
git add renv.lock
git commit -m "deps: add newpackage"
```

### Building Locally

```bash
# Full render
quarto render

# Render specific chapter
quarto render chapters/01-introduction.qmd

# Preview (watches for changes)
quarto preview
```

## Troubleshooting

### Common Issues

#### renv Issues

**Problem**: Package installation fails
```r
# Solution 1: Update renv
renv::upgrade()

# Solution 2: Clear cache and reinstall
renv::purge("packagename")
renv::install("packagename")

# Solution 3: Rebuild
renv::rebuild("packagename")
```

**Problem**: Package versions out of sync
```r
renv::status()  # Check status
renv::restore() # Restore to renv.lock
```

#### Quarto Issues

**Problem**: Render fails
```bash
# Check Quarto installation
quarto check

# Render with verbose output
quarto render --verbose

# Clear cache
rm -rf _cache/
quarto render
```

**Problem**: Code chunk errors
- Check R code runs independently
- Verify data files exist
- Check package loading

#### Git Issues

**Problem**: Merge conflicts in renv.lock
```bash
# Use main branch version
git checkout --theirs renv.lock
renv::restore()

# Or rebuild from current environment
renv::snapshot()
```

### Getting Help

1. **Check documentation**: This file, ARCHITECTURE.md
2. **Search issues**: GitHub issues page
3. **Run diagnostics**:
   ```r
   # Check R environment
   sessionInfo()

   # Check package versions
   renv::status()

   # Check Quarto
   quarto check
   ```
4. **Create minimal reproducible example**
5. **Open a GitHub issue** with:
   - What you tried
   - What you expected
   - What actually happened
   - Session info
   - Error messages

## Best Practices

### Code Quality

- ✅ Write tests for new functions
- ✅ Use meaningful variable names
- ✅ Add comments for complex logic
- ✅ Keep functions focused (one task)
- ✅ Handle errors gracefully
- ✅ Log important operations

### Commits

- ✅ Atomic commits (one logical change)
- ✅ Descriptive commit messages
- ✅ Reference issues when applicable
- ✅ Test before committing

### Pull Requests

- ✅ One feature per PR
- ✅ Update documentation
- ✅ Add tests
- ✅ Pass CI checks
- ✅ Request review

## Resources

### R Resources

- [R for Data Science](https://r4ds.had.co.nz/)
- [Advanced R](https://adv-r.hadley.nz/)
- [tidyverse style guide](https://style.tidyverse.org/)
- [R Packages book](https://r-pkgs.org/)

### Quarto Resources

- [Quarto documentation](https://quarto.org/docs/guide/)
- [Quarto books](https://quarto.org/docs/books/)
- [Markdown basics](https://quarto.org/docs/authoring/markdown-basics.html)

### Testing Resources

- [testthat documentation](https://testthat.r-lib.org/)
- [Testing chapter in R Packages](https://r-pkgs.org/tests.html)

### Git Resources

- [Pro Git book](https://git-scm.com/book/en/v2)
- [GitHub guides](https://guides.github.com/)

## Questions?

- 📧 Open an issue on GitHub
- 💬 Check existing documentation
- 🔍 Search closed issues
- 📚 Review code examples in the project
