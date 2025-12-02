# Data Analysis in Natural Sciences: An R-Based Approach

[![Publish to GitHub Pages](https://github.com/jm0535/dains/actions/workflows/publish.yml/badge.svg)](https://github.com/jm0535/dains/actions/workflows/publish.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Quarto](https://img.shields.io/badge/Made%20with-Quarto-blue.svg)](https://quarto.org/)

A comprehensive book that provides step-by-step instructions on data analysis for researchers and students in natural sciences using R. This book is designed to guide users through fundamental statistical concepts and practical data analysis techniques with a focus on ecological, environmental, and life sciences applications.

## 📖 Read the Book

**Online Version:** [https://jm0535.github.io/dains/](https://jm0535.github.io/dains/)

## 📚 Contents

The book covers:

| Part | Topics |
|------|--------|
| **Getting Started** | Introduction to R, data analysis fundamentals, data basics |
| **Data Analysis Fundamentals** | Exploratory data analysis, hypothesis testing, statistical tests |
| **Data Visualization** | Visualization techniques, advanced graphics with ggplot2 |
| **Advanced Topics** | Regression analysis, conservation applications |

### Chapter Overview

1. **Introduction to Data Analysis** - R basics and analytical thinking
2. **Data Basics** - Data structures, importing, and cleaning
3. **Exploratory Data Analysis** - Descriptive statistics and pattern discovery
4. **Hypothesis Testing** - Statistical inference fundamentals
5. **Statistical Tests** - Common parametric and non-parametric tests
6. **Data Visualization** - Creating effective scientific graphics
7. **Advanced Visualization** - Interactive and publication-quality figures
8. **Regression Analysis** - Linear models and tidymodels framework
9. **Conservation Applications** - Real-world ecological case studies

## 📊 Datasets

All datasets are located in the `data/` directory, organized by scientific discipline:

| Directory | Description | Source |
|-----------|-------------|--------|
| `agriculture/` | Crop yield data | Our World in Data |
| `botany/` | Plant traits data | Break Free From Plastic |
| `ecology/` | Plant biodiversity data | IUCN Red List |
| `economics/` | Coffee economics data | Coffee Quality Institute |
| `entomology/` | Animal data | Austin Animal Center |
| `environmental/` | Climate data | Palmer penguins dataset |
| `epidemiology/` | Disease/health data | Various sources |
| `forestry/` | Forest inventory data | Field collections |
| `geography/` | Spatial data | UN Office on Drugs and Crime |
| `marine/` | Ocean/fishing data | Great Lakes Fishery Commission |

Each dataset directory contains a `CITATION.txt` file with source information and proper citation for academic use.

## 🚀 Getting Started

### Prerequisites

- **R** (version 4.0.0 or higher)
- **RStudio** (recommended IDE)
- **Quarto** (for building the book)

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/jm0535/dains.git
   cd dains
   ```

2. **Install required R packages:**

   ```r
   source("install_packages.R")
   ```

   Or manually install core packages:

   ```r
   install.packages(c(
     "tidyverse",
     "tidymodels", 
     "ggplot2", 
     "rstatix", 
     "knitr", 
     "rmarkdown",
     "performance",
     "see"
   ))
   ```

3. **Download datasets (if needed):**

   ```r
   source("download_datasets.R")
   ```

## 🔨 Building the Book

To build the HTML version of the book locally:

1. **Install Quarto** from [quarto.org](https://quarto.org/docs/get-started/)

2. **Render the book:**

   ```bash
   quarto render
   ```

3. **Preview locally:**

   ```bash
   quarto preview
   ```

The rendered book will be available in the `docs/` directory.

## 📁 Project Structure

```
dains/
├── _quarto.yml          # Quarto configuration
├── index.qmd            # Book landing page
├── preface.qmd          # Preface chapter
├── references.qmd       # References chapter
├── chapters/            # Book chapters (01-09)
├── data/                # Datasets by discipline
├── docs/                # Rendered HTML output
├── images/              # Book images and cover
├── R/                   # Helper R functions
├── scripts/             # Utility scripts
├── styles.css           # Custom CSS styling
├── references.bib       # Bibliography
└── apa.csl              # Citation style
```

## 🤝 Contributing

Contributions to improve the book are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-improvement`)
3. Make your changes
4. Run `quarto render` to ensure everything builds correctly
5. Commit your changes (`git commit -m 'Add some amazing improvement'`)
6. Push to the branch (`git push origin feature/amazing-improvement`)
7. Open a Pull Request

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ✍️ Author

**Dr. Jimmy Moses (PhD)**  
School of Forestry, Faculty of Natural Resources  
Papua New Guinea University of Technology  
PMB 411, Lae, Morobe Province, Papua New Guinea

## 🙏 Acknowledgments

- The [R Core Team](https://www.r-project.org/) for developing R
- The [tidyverse team](https://www.tidyverse.org/) for revolutionizing R programming
- The [Quarto team](https://quarto.org/) for the publishing system
- All data providers who make their datasets openly available
- Students and colleagues who provided feedback

## 📬 Contact

- **Issues:** [GitHub Issues](https://github.com/jm0535/dains/issues)
- **Discussions:** [GitHub Discussions](https://github.com/jm0535/dains/discussions)

---

*Last updated: December 2025*