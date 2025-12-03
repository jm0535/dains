
# Check packages for Chapter 4
pkg_list <- c("tidyverse", "ggplot2", "knitr", "kableExtra", "magrittr")

for (p in pkg_list) {
  if (!require(p, character.only = TRUE)) {
    message("Failed to load: ", p)
    install.packages(p, repos = "http://cran.rstudio.com/")
  } else {
    message("Successfully loaded: ", p)
  }
}
