# This file is part of the standard testthat testing framework
# It runs all tests in the testthat/ directory

library(testthat)
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(rstatix)
library(knitr)

# Test the workshop functions
test_check("DataAnalysisBook")
