# Install spatial packages for "Data Analysis in Natural Sciences: An R-Based Approach"
# Author: Dr. Jimmy Moses
# Repository: https://github.com/jm0535/dains
#
# This script installs spatial and GIS-related packages needed for:
# - Chapter 9: Conservation Applications
# - Spatial data analysis
# - Interactive mapping
#
# Usage:
#   source("scripts/install_spatial_packages.R")

# Set CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

# Print header
message("\n", strrep("=", 60))
message("Spatial Packages Installation")
message("Data Analysis in Natural Sciences")
message(strrep("=", 60))
message("R version: ", R.version.string)
message("Date: ", Sys.Date())
message(strrep("=", 60), "\n")

# Function to install packages if not already installed
install_if_missing <- function(packages) {
  new_packages <- packages[!(packages %in% installed.packages()[, "Package"])]
  if (length(new_packages)) {
    message("Installing packages: ", paste(new_packages, collapse = ", "))
    install.packages(new_packages, dependencies = TRUE)
  } else {
    message("All required packages are already installed.")
  }
}

# =============================================================================
# PACKAGE DEFINITIONS
# =============================================================================

# Core spatial packages (modern sf-based workflow)
core_spatial <- c(
  "sf", # Simple features for R - modern spatial data handling
  "terra", # Modern raster and vector spatial data analysis
  "stars" # Spatiotemporal arrays, raster and vector data cubes
)

# Legacy spatial packages (for compatibility)
legacy_spatial <- c(
  "sp", # Classes and methods for spatial data
  "raster" # Raster data analysis (predecessor to terra)
)

# Map data packages
map_data <- c(
  "rnaturalearth", # Natural Earth map data
  "rnaturalearthdata", # Natural Earth high-resolution data
  "spData", # Spatial datasets for teaching
  "maps", # Draw geographical maps
  "mapdata" # Extra map databases
)

# Visualization packages
spatial_viz <- c(
  "tmap", # Thematic maps (static and interactive)
  "leaflet", # Interactive web maps
  "mapview", # Interactive viewing of spatial data
  "ggmap", # Spatial visualization with ggplot2
  "ggspatial" # Spatial data framework for ggplot2
)

# Analysis packages
spatial_analysis <- c(
  "landscapemetrics", # Landscape metrics calculation
  "spdep", # Spatial dependence: weighting schemes, statistics
  "spatstat", # Spatial point pattern analysis
  "gstat" # Geostatistical modeling, prediction and simulation
)

# Species distribution modeling
sdm_packages <- c(
  "dismo", # Species distribution modeling
  "biomod2" # Ensemble platform for species distribution modeling
)

# Optional advanced packages (uncomment if needed)
# advanced_spatial <- c(
#   "rgdal",           # Bindings for GDAL (being retired)
#   "rgeos",           # Interface to GEOS (being retired)
#   "exactextractr",   # Fast raster extraction
#   "fasterize",       # Fast polygon to raster conversion
#   "whitebox",        # WhiteboxTools for geospatial analysis
#   "geodata"          # Download geographic data
# )

# =============================================================================
# SYSTEM DEPENDENCIES NOTE
# =============================================================================

message("\n", strrep("-", 60))
message("NOTE: Spatial packages require system libraries")
message(strrep("-", 60))
message("
On Ubuntu/Debian, you may need to install:
  sudo apt-get install libgdal-dev libgeos-dev libproj-dev libudunits2-dev

On macOS with Homebrew:
  brew install gdal geos proj

On Windows:
  System libraries are typically bundled with packages.
")
message(strrep("-", 60), "\n")

# =============================================================================
# INSTALLATION
# =============================================================================

# Combine all packages
all_packages <- c(
  core_spatial,
  legacy_spatial,
  map_data,
  spatial_viz,
  spatial_analysis,
  sdm_packages
)

# Remove duplicates
all_packages <- unique(all_packages)

# Print summary
message("\n", strrep("=", 60))
message("Installing ", length(all_packages), " spatial packages")
message(strrep("=", 60), "\n")

# Install packages
install_if_missing(all_packages)

# =============================================================================
# VERIFICATION
# =============================================================================

# Define critical packages
critical_packages <- c("sf", "terra", "rnaturalearth", "leaflet", "tmap")

# Check installation status
message("\n", strrep("=", 60))
message("Verification")
message(strrep("=", 60))

all_installed <- TRUE
for (pkg in critical_packages) {
  if (pkg %in% installed.packages()[, "Package"]) {
    message(sprintf("  ✓ %-20s %s", pkg, packageVersion(pkg)))
  } else {
    message(sprintf("  ✗ %-20s NOT INSTALLED", pkg))
    all_installed <- FALSE
  }
}

if (all_installed) {
  message("\n✓ All critical spatial packages installed successfully!")
} else {
  message("\n⚠ Some packages failed to install. Check system dependencies above.")
}

# =============================================================================
# QUICK TEST
# =============================================================================

if (interactive() && all_installed) {
  message("\n", strrep("-", 60))
  message("Quick Test")
  message(strrep("-", 60))

  tryCatch(
    {
      library(sf, quietly = TRUE)
      library(rnaturalearth, quietly = TRUE)

      # Try loading world data
      world <- ne_countries(scale = "medium", returnclass = "sf")
      message("  ✓ Successfully loaded Natural Earth world data")
      message("  ✓ World dataset has ", nrow(world), " countries")
      message("\nSpatial functionality is working correctly!")
    },
    error = function(e) {
      message("  ✗ Quick test failed: ", e$message)
    }
  )
}

# =============================================================================
# COMPLETION
# =============================================================================

message("\n", strrep("=", 60))
message("Spatial Packages Installation Complete!")
message(strrep("=", 60))
message("\nUseful resources:")
message("  - sf documentation: https://r-spatial.github.io/sf/")
message("  - terra documentation: https://rspatial.github.io/terra/")
message("  - tmap documentation: https://r-tmap.github.io/tmap/")
message("  - Geocomputation with R: https://geocompr.robinlovelace.net/")
message(strrep("=", 60), "\n")
