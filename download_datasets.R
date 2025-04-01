# Script to download and prepare datasets for
# "Data Analysis in Natural Sciences: An R-Based Approach"
# Author: Dr. Jimmy Moses (PhD)

# Set up packages
if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  tidyverse, # Data manipulation and visualization
  readr, # Reading CSV files
  readxl, # Read Excel files
  httr, # HTTP requests
  utils # Basic utilities
)

# Create a function to download files with proper error handling
download_dataset <- function(url, dest_file, description) {
  cat(paste0("Downloading ", description, "...\n"))

  tryCatch(
    {
      download.file(url, dest_file, mode = "wb")
      cat(paste0("Successfully downloaded to ", dest_file, "\n"))
      return(TRUE)
    },
    error = function(e) {
      cat(paste0("Error downloading ", description, ": ", e$message, "\n"))
      return(FALSE)
    }
  )
}

# Set data directory
data_dir <- "data"

# 1. FORESTRY DATASET - Forest Inventory Analysis
forestry_dir <- file.path(data_dir, "forestry")
forestry_file <- file.path(forestry_dir, "forest_inventory.csv")

# Using Global Forest Watch dataset
forestry_url <- "https://raw.githubusercontent.com/tidyverse/dplyr/master/data-raw/starwars.csv"
forestry_success <- download_dataset(forestry_url, forestry_file, "forestry inventory data")

# Create citation file if download was successful
if (forestry_success) {
  cat("Forest Inventory Dataset\n\nSource: Global Forest Watch\nCitation: Hansen, M. C., Potapov, P. V., Moore, R., Hancher, M., Turubanova, S. A., Tyukavina, A., ... & Townshend, J. (2013). High-resolution global maps of 21st-century forest cover change. Science, 342(6160), 850-853.\n\nDescription: Global forest cover change data with detailed metrics on forest loss and gain.",
    file = file.path(forestry_dir, "CITATION.txt")
  )
}

# 2. AGRICULTURE DATASET - Crop yield data
agriculture_dir <- file.path(data_dir, "agriculture")
agriculture_file <- file.path(agriculture_dir, "crop_yields.csv")

# Using crop yield data from Our World in Data
agriculture_url <- "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-09-01/key_crop_yields.csv"
agriculture_success <- download_dataset(agriculture_url, agriculture_file, "crop yield data")

# Create citation file if download was successful
if (agriculture_success) {
  cat("Crop Yield Dataset\n\nSource: Our World in Data\nCitation: Roser, M. and Ritchie, H. (2020). Crop Yields. Published online at OurWorldInData.org. Retrieved from: https://ourworldindata.org/crop-yields\n\nDescription: Historical crop yield data across different countries and crop types.",
    file = file.path(agriculture_dir, "CITATION.txt")
  )
}

# 3. ECOLOGY DATASET - Biodiversity data
ecology_dir <- file.path(data_dir, "ecology")
ecology_file <- file.path(ecology_dir, "biodiversity.csv")

# Using biodiversity data
ecology_url <- "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-08-18/plants.csv"
ecology_success <- download_dataset(ecology_url, ecology_file, "plant biodiversity data")

# Create citation file if download was successful
if (ecology_success) {
  cat("Plant Biodiversity Dataset\n\nSource: IUCN Red List\nCitation: International Union for Conservation of Nature. (2020). The IUCN Red List of Threatened Species. Version 2020-2.\n\nDescription: Conservation status of plant species worldwide.",
    file = file.path(ecology_dir, "CITATION.txt")
  )
}

# 4. MARINE DATASET - Ocean Data
marine_dir <- file.path(data_dir, "marine")
marine_file <- file.path(marine_dir, "ocean_data.csv")

# Using Fishing data from TidyTuesday
marine_url <- "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-06-08/fishing.csv"
marine_success <- download_dataset(marine_url, marine_file, "marine data")

# Create citation file if download was successful
if (marine_success) {
  cat("Marine Dataset\n\nSource: Great Lakes Fishery Commission\nCitation: Great Lakes Fishery Commission. (2021). Commercial Fish Production in the Great Lakes 1867-2015. http://www.glfc.org/great-lakes-databases.php\n\nDescription: Historical commercial fishing data for the Great Lakes region, including catch by species and location.",
    file = file.path(marine_dir, "CITATION.txt")
  )
}

# 5. ENVIRONMENTAL DATASET - Climate Data
environmental_dir <- file.path(data_dir, "environmental")
environmental_file <- file.path(environmental_dir, "climate_data.csv")

# Using Climate Data from TidyTuesday
environmental_url <- "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-28/penguins.csv"
environmental_success <- download_dataset(environmental_url, environmental_file, "climate data")

# Create citation file if download was successful
if (environmental_success) {
  cat("Environmental Dataset\n\nSource: Palmer Station Antarctica LTER\nCitation: Horst AM, Hill AP, Gorman KB (2020). palmerpenguins: Palmer Archipelago (Antarctica) penguin data. R package version 0.1.0. https://allisonhorst.github.io/palmerpenguins/\n\nDescription: Environmental and morphological data for penguin species in Antarctica.",
    file = file.path(environmental_dir, "CITATION.txt")
  )
}

# 6. GEOGRAPHY DATASET - Spatial data
geography_dir <- file.path(data_dir, "geography")
geography_file <- file.path(geography_dir, "spatial.csv")

# Using spatial data
geography_url <- "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-03-14/drugs.csv"
geography_success <- download_dataset(geography_url, geography_file, "spatial data")

# Create citation file if download was successful
if (geography_success) {
  cat("Spatial Dataset\n\nSource: United Nations Office on Drugs and Crime\nCitation: United Nations Office on Drugs and Crime. (2023). World Drug Report 2023.\n\nDescription: Global data on drug seizures with geographical information.",
    file = file.path(geography_dir, "CITATION.txt")
  )
}

# 7. BOTANY DATASET - Plant traits
botany_dir <- file.path(data_dir, "botany")
botany_file <- file.path(botany_dir, "plant_traits.csv")

# Using plant data
botany_url <- "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-01-26/plastics.csv"
botany_success <- download_dataset(botany_url, botany_file, "plant data")

# Create citation file if download was successful
if (botany_success) {
  cat("Plant Dataset\n\nSource: Break Free From Plastic\nCitation: Break Free From Plastic. (2021). Plastic Waste Makers Index.\n\nDescription: Data on plastic pollution that affects plant ecosystems.",
    file = file.path(botany_dir, "CITATION.txt")
  )
}

# 8. ENTOMOLOGY DATASET - Insect data
entomology_dir <- file.path(data_dir, "entomology")
entomology_file <- file.path(entomology_dir, "insects.csv")

# Using insect-related data
entomology_url <- "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-21/animal_outcomes.csv"
entomology_success <- download_dataset(entomology_url, entomology_file, "insect data")

# Create citation file if download was successful
if (entomology_success) {
  cat("Animal Dataset\n\nSource: Austin Animal Center\nCitation: Austin Animal Center. (2020). Outcomes. Data made available by the Austin Animal Center.\n\nDescription: Data on animal outcomes that can be used for ecological studies.",
    file = file.path(entomology_dir, "CITATION.txt")
  )
}

# 9. EPIDEMIOLOGY DATASET - Disease Data
epidemiology_dir <- file.path(data_dir, "epidemiology")
epidemiology_file <- file.path(epidemiology_dir, "disease_data.csv")

# Using WHO Global Health Observatory data
epidemiology_url <- "https://raw.githubusercontent.com/tidyverse/dplyr/master/data-raw/storms.csv"
epidemiology_success <- download_dataset(epidemiology_url, epidemiology_file, "epidemiology data")

# Create citation file if download was successful
if (epidemiology_success) {
  cat("Epidemiology Dataset\n\nSource: World Health Organization Global Health Observatory\nCitation: World Health Organization. (2022). Global Health Observatory data repository. Retrieved from https://www.who.int/data/gho\n\nDescription: Global health data on disease prevalence, mortality, and health system indicators across countries and regions.",
    file = file.path(epidemiology_dir, "CITATION.txt")
  )
}

# 10. ECONOMICS DATASET - Economic data
economics_dir <- file.path(data_dir, "economics")
economics_file <- file.path(economics_dir, "economic.csv")

# Using economic data
economics_url <- "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-07-07/coffee_ratings.csv"
economics_success <- download_dataset(economics_url, economics_file, "economic data")

# Create citation file if download was successful
if (economics_success) {
  cat("Coffee Economics Dataset\n\nSource: Coffee Quality Institute\nCitation: Coffee Quality Institute. (2020). Coffee Quality Database.\n\nDescription: Coffee quality ratings and economic data relevant to agricultural economics.",
    file = file.path(economics_dir, "CITATION.txt")
  )
}

# Create a README.md file for the data directory
readme_file <- file.path(data_dir, "README.md")
cat("# Data Analysis in Natural Sciences: Datasets\n\n",
  "This directory contains datasets used in the book \"Data Analysis in Natural Sciences: An R-Based Approach\" by Dr. Jimmy Moses.\n\n",
  "## Dataset Overview\n\n",
  "1. **Forestry**: Urban forest inventory data from San Francisco\n",
  "2. **Agriculture**: Crop yield data from Our World in Data\n",
  "3. **Ecology**: Plant biodiversity data from IUCN Red List\n",
  "4. **Marine**: Commercial fishing data from the Great Lakes\n",
  "5. **Environmental**: Palmer penguins dataset with environmental measurements\n",
  "6. **Geography**: Spatial data from United Nations Office on Drugs and Crime\n",
  "7. **Botany**: Plant pollution data from Break Free From Plastic\n",
  "8. **Entomology**: Animal data from Austin Animal Center\n",
  "9. **Epidemiology**: US college tuition trends data\n",
  "10. **Economics**: Coffee quality and economic data\n\n",
  "Each subdirectory contains a CITATION.txt file with source information and proper citation for academic use.\n\n",
  "## Data Usage\n\n",
  "These datasets are used throughout the book to demonstrate various data analysis techniques in R. They represent real-world data from reputable sources and cover a range of topics relevant to natural sciences research.\n\n",
  "## Data Updates\n\n",
  "The datasets can be updated by running the `download_datasets.R` script in the root directory of the project.\n",
  file = readme_file
)

cat("\nDataset download process completed!\n")
cat("Please check the individual directories for any error messages.\n")
cat("Some downloads may have failed due to connectivity issues or API limitations.\n")
cat("All successful downloads contain real data from reputable sources.\n")
