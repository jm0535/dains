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
| **R in Context** | Integrations with jamovi, JASP, Positron, Quarto, reticulate, plumber |

### Chapter Overview

1. **Introduction to Data Analysis**: R basics and analytical thinking
2. **Data Basics**: Data structures, importing, and cleaning
3. **Exploratory Data Analysis**: Descriptive statistics and pattern discovery
4. **Hypothesis Testing**: Statistical inference fundamentals
5. **Statistical Tests**: Common parametric and non-parametric tests, with assumption checks
6. **Data Visualization**: Creating effective scientific graphics
7. **Advanced Visualization**: Interactive and publication-quality figures
8. **Regression Analysis**: Linear models, diagnostics, and the tidymodels framework
9. **Advanced Modeling**: Mixed-effects, GLMs, and modern modeling approaches
10. **Conservation Applications**: Real-world ecological case studies
11. **R in the Wider Ecosystem**: Integrations with jamovi, JASP, Positron, VS Code, Jupyter, reticulate, plumber, and friends

## 📊 Datasets

All datasets live in the `data/` directory, organized by scientific discipline. A few of the directory names reflect the chapter context in which the data are used rather than the literal subject of the CSV file (the files were sourced from public datasets and kept under their working names so chapter references stay stable). See [`data/DATA_DICTIONARY.md`](data/DATA_DICTIONARY.md) for the actual columns and teaching role, and [`data/MISMATCHES.md`](data/MISMATCHES.md) for the full audit.

| Directory | Chapter use | Actual data |
|-----------|-------------|-------------|
| `agriculture/` | Crop yields by country and year | Our World in Data: Wheat / Rice / Maize tonnes per hectare |
| `botany/` | Categorical analysis example | Break Free From Plastic brand audit (polymer types) |
| `ecology/` | Biodiversity and threat status | IUCN Red List records |
| `economics/` | Quality-vs-price regression | Coffee Quality Institute scores |
| `entomology/` | Categorical / counts example | Austin (and Australian) animal-shelter outcomes |
| `environmental/` | Continuous variables example | Palmer Penguins morphology |
| `epidemiology/` | Time-series / spatial example | Atlantic hurricane tracks |
| `forestry/` | Continuous variables example | Star Wars character measurements (used as a stand-in) |
| `geography/` | Categorical example | EMA medicine authorisations |
| `marine/` | Long-format time series | Great Lakes Fishery Commission fish populations |

Each dataset directory contains a `CITATION.txt` with source attribution. If you want a dataset whose contents match its directory name (e.g. real forestry inventory), drop it in and update the corresponding chapter reference.

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
   source("scripts/install_packages.R")
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
├── chapters/            # Book chapters (01-10)
├── solutions/           # Instructor answer keys (instructor-solutions branch only)
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

## 👩‍🏫 For Instructors

A separate `instructor-solutions` branch carries worked answer keys for all chapter exercises under `solutions/`. The branch is intentionally kept out of the published book and out of `main` to keep solutions away from students. If you teach from this book and want access, open an issue with a brief verification request.

## 🛠️ Project Infrastructure

A few notes on how the book is built and maintained:

- **CI/CD:** Every push to `main` triggers `.github/workflows/publish.yml`, which renders the book with Quarto and deploys the output to GitHub Pages. The committed `docs/` folder is not what gets published; CI re-renders on every push, so figures regenerate from the R code in each chapter.
- **Render-time gates:** The workflow warns at 25 minutes of render time and fails at 40, so render regressions get caught before they reach production.
- **Git LFS:** Large binary assets (cover images, R logo, rendered PDFs) are tracked with Git LFS. See [`docs/GIT_LFS_SETUP.md`](docs/GIT_LFS_SETUP.md) for setup notes.
- **Dependency tracking:** `renv` pins the R package versions used to build the book. The most recent dependency audit lives in [`renv-audit.md`](renv-audit.md).
- **Statistical rigor:** Chapter 5 (statistical tests) and Chapter 8 (regression) include explicit assumption-check callouts (Shapiro-Wilk, Levene's test, expected cell counts for chi-square, residual diagnostics, VIF for collinearity) before each test is applied.

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ✍️ Author

**Jimmy Moses**
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

*Last updated: May 2026*