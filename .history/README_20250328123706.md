# Data Analysis in Natural Sciences: An R-Based Approach

A comprehensive book that provides step-by-step instructions on data analysis for researchers and students in natural sciences using R. This book is designed to guide users through fundamental statistical concepts and practical data analysis techniques with a focus on ecological and forestry applications.

[![Publish to GitHub Pages](https://github.com/jm0535/data-analysis-book/actions/workflows/publish.yml/badge.svg)](https://github.com/jm0535/data-analysis-book/actions/workflows/publish.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Contents

The book covers:

- Introduction to R and data analysis fundamentals
- Data manipulation and cleaning
- Exploratory data analysis
- Statistical hypothesis testing
- Data visualization techniques
- Advanced statistical methods
- Regression analysis
- Conservation applications
- Practical examples with real-world datasets

## Datasets

All datasets used in this book are located in the `data/` directory, organized by scientific discipline:

- **Agriculture**: `data/agriculture/` - Crop yield data from Our World in Data
- **Botany**: `data/botany/` - Plant traits data from Break Free From Plastic
- **Ecology**: `data/ecology/` - Plant biodiversity data from IUCN Red List
- **Economics**: `data/economics/` - Coffee economics data from Coffee Quality Institute
- **Entomology**: `data/entomology/` - Animal data from Austin Animal Center
- **Environmental**: `data/environmental/` - Climate data (Palmer penguins dataset)
- **Epidemiology**: `data/epidemiology/` - Disease/health data
- **Forestry**: `data/forestry/` - Forest inventory data
- **Geography**: `data/geography/` - Spatial data from United Nations Office on Drugs and Crime
- **Marine**: `data/marine/` - Ocean/fishing data from Great Lakes Fishery Commission

Each dataset directory contains a CITATION.txt file with source information and proper citation for academic use.

## Getting Started

### Prerequisites

- R (version 4.0.0 or higher recommended)
- RStudio (recommended for working with R)
- Quarto (for building the book)

### Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/jm0535/data-analysis-book.git
   ```

2. Download the datasets by running the script:

   ```r
   Rscript download_datasets.R
   ```

3. Install required R packages:

   ```r
   install.packages(c("tidyverse", "ggplot2", "plotly", "leaflet", "rstatix", "knitr", "rmarkdown"))
   ```

## Building the Book

To build the HTML version of the book:

1. Install Quarto from [Quarto](https://quarto.org/)
2. Run the following command in the terminal:

   ```bash
   quarto render
   ```

3. The rendered book will be available in the `docs/` directory

## GitHub Pages

This book is published using GitHub Pages and can be accessed at:
[https://jm0535.github.io/data-analysis-book/](https://jm0535.github.io/data-analysis-book/)

The publishing process is automated using GitHub Actions. When changes are pushed to the main branch, the book is automatically rebuilt and published.

## Contributing

Contributions to improve the book are welcome. Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-improvement`)
3. Make your changes
4. Commit your changes (`git commit -m 'Add some amazing improvement'`)
5. Push to the branch (`git push origin feature/amazing-improvement`)
6. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Dr. Jimmy Moses (PhD)
School of Forestry, Faculty of Natural Resources
Papua New Guinea University of Technology
PMB 411, Lae, Morobe Province, Papua New Guinea
