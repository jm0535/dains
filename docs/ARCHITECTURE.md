# Architecture Overview

## Project Structure

This project is a Quarto-based book for teaching data analysis in natural sciences using R.

```
Data-Analysis-in-Natural-Sciences/
├── chapters/              # Book content (Quarto markdown files)
├── data/                  # Datasets organized by scientific discipline
│   └── schemas/          # Data validation rules
├── docs/                  # Rendered HTML book (generated)
├── R/                     # Reusable R functions and utilities
│   ├── workshop_functions.R  # Core analysis functions
│   ├── logging.R         # Structured logging system
│   ├── plotting_themes.R # Consistent plot styling
│   └── performance.R     # Performance monitoring
├── scripts/               # Utility scripts
│   ├── download_datasets.R   # Data acquisition
│   ├── data_validation.R     # Data quality checks
│   ├── install_packages.R    # Dependency installation
│   └── build_book.R          # Build automation
├── tests/                 # Automated test suite
├── .github/workflows/     # CI/CD pipelines
├── renv/                  # Package management (local library)
└── logs/                  # Application logs

Generated files (not in version control):
├── _cache/               # Computation cache
├── renv/library/         # R package binaries
└── logs/*.log           # Log files
```

## Component Responsibilities

### 1. Chapters (`chapters/`)

**Purpose**: Educational content organized by topic

**Structure**:
- `01-introduction.qmd` - R and data analysis basics
- `02-data-basics.qmd` - Data structures and manipulation
- `03-exploratory-analysis.qmd` - EDA techniques
- `04-hypothesis-testing.qmd` - Statistical inference
- `05-statistical-tests.qmd` - Common statistical tests
- `06-visualization.qmd` - Data visualization principles
- `07-advanced-visualization.qmd` - Interactive plots
- `08-regression.qmd` - Regression analysis
- `09-conservation.qmd` - Applied conservation science

**Design Principles**:
- Self-contained: Each chapter can be read independently
- Progressive complexity: Builds on previous concepts
- Real-world examples: Uses actual scientific datasets
- Code-first: Emphasizes reproducible analysis

### 2. Data (`data/`)

**Purpose**: Curated datasets from reputable sources

**Organization**: 10 scientific disciplines
- agriculture/, botany/, ecology/, economics/
- entomology/, environmental/, epidemiology/
- forestry/, geography/, marine/

**Each dataset includes**:
- Raw data files (CSV format)
- CITATION.txt (proper attribution)
- METADATA.json (download date, hash, size)
- Validation schemas (data/schemas/)

**Data Flow**:
1. `download_datasets.R` fetches data from URLs
2. Files stored with metadata and citations
3. `data_validation.R` checks quality
4. Chapters load and analyze data
5. Results rendered in book

### 3. R Functions (`R/`)

**Core Modules**:

#### workshop_functions.R
- `load_ecological_data()` - Load and clean CSV files
- `correlation_table()` - Format correlation results
- `scatter_plot_with_regression()` - Scatter plots
- `box_plot()` - Group comparisons
- `t_test_analysis()` - Statistical testing
- `histogram_with_density()` - Distribution plots

#### logging.R
- Structured logging with levels (DEBUG, INFO, WARN, ERROR)
- Log to file and console simultaneously
- Colored console output for readability
- Timed function execution tracking

#### plotting_themes.R
- `get_default_theme()` - Consistent plot styling
- `get_publication_theme()` - Journal-ready plots
- `get_colorblind_palette()` - Accessible colors
- `apply_plot_formatting()` - Standardized formatting

#### performance.R
- `time_function()` - Measure execution time
- `profile_code()` - Detailed performance profiling
- `benchmark_approaches()` - Compare implementations
- `log_performance()` - Performance logging

### 4. Scripts (`scripts/`)

**Utility Scripts**:

#### download_datasets.R
- Downloads data from remote URLs
- Validates file integrity (hash, size, format)
- Atomic downloads with rollback
- Retry logic with exponential backoff
- Generates citations and metadata

#### data_validation.R
- Validates all datasets
- Checks file existence, format, structure
- Analyzes missing values
- Generates quality reports
- Logs validation results

#### install_packages.R
- One-time package installation
- Organized by category
- Smart detection (only installs if missing)

#### setup_renv.R
- Initializes renv for reproducibility
- Captures package versions
- Creates renv.lock snapshot

### 5. Testing (`tests/`)

**Test Suite**:
- Unit tests for R functions
- Integration tests for data pipelines
- Test coverage for critical paths

**Framework**: testthat
- Structured test organization
- Descriptive test names
- Cleanup of temp files
- CI/CD integration

### 6. CI/CD (`.github/workflows/`)

**Pipeline Stages**:

1. **Quality Checks**
   - Lint R code (lintr)
   - Check code style (styler)
   - Verify formatting

2. **Automated Tests**
   - Run test suite
   - Generate coverage report
   - Upload test results

3. **Data Validation**
   - Validate data integrity
   - Check schemas
   - Log validation results

4. **Build & Deploy**
   - Render Quarto book
   - Verify output
   - Deploy to GitHub Pages

## Data Flow

```
┌─────────────────┐
│ External Sources│ (TidyTuesday, IUCN, etc.)
└────────┬────────┘
         │
         ▼
  ┌──────────────────┐
  │download_datasets.R│ (Fetch, validate, store)
  └──────────┬────────┘
             │
             ▼
       ┌─────────┐
       │ data/   │ (CSV files + metadata)
       └────┬────┘
            │
            ├──►┌──────────────────┐
            │   │data_validation.R │ (Quality checks)
            │   └──────────────────┘
            │
            ▼
     ┌──────────────┐
     │  chapters/   │ (Analysis code)
     └──────┬───────┘
            │
            ▼
      ┌─────────┐
      │ Quarto  │ (Render)
      └────┬────┘
           │
           ▼
     ┌──────────┐
     │  docs/   │ (HTML book)
     └────┬─────┘
          │
          ▼
   ┌──────────────┐
   │GitHub Pages  │ (Published site)
   └──────────────┘
```

## Design Decisions

### Why Quarto Over Bookdown?

**Advantages**:
- Modern tooling and active development
- Better HTML output with interactive features
- Built-in code execution and caching
- Cross-language support (future Python examples)
- Improved figure and table handling
- Better error messages

### Why tidyverse?

**Rationale**:
- Industry standard in data science
- Consistent syntax across packages
- Excellent documentation
- Strong ecosystem
- Educational focus (readability)
- Pipe operator improves code flow

### Why GitHub Pages?

**Benefits**:
- Free hosting
- Automatic deployment via Actions
- Version control integration
- Custom domain support
- Fast and reliable
- HTTPS by default

### Why renv?

**Reproducibility**:
- Isolated project dependencies
- Exact version tracking in renv.lock
- Works across different systems
- Lightweight (only locks, not binaries)
- Seamless RStudio integration

## Scalability Considerations

### Adding New Chapters

1. Create new .qmd file in `chapters/`
2. Add to `_quarto.yml` book structure
3. Follow existing naming convention
4. Include professional tips and callouts
5. Test locally before committing

### Adding New Datasets

1. Add dataset info to `download_datasets.R`
2. Create validation schema in `data/schemas/`
3. Document in data README
4. Update citations
5. Test validation pipeline

### Adding New Functions

1. Add function to appropriate R/ file
2. Include roxygen2 documentation
3. Write unit tests in tests/
4. Export if needed by chapters
5. Update function documentation

## Performance Optimization

### Current Optimizations

1. **Caching**: Quarto caches expensive computations
2. **Lazy Loading**: Data loaded only when needed
3. **Parallel Downloads**: (Planned) Multiple datasets simultaneously
4. **Selective Rendering**: Only changed chapters rebuild

### Future Improvements

- Implement parallel data downloads
- Add memoization for repeated calculations
- Optimize large dataset handling
- Use data.table for big data operations

## Security Considerations

### Data Integrity

- File hash validation (MD5)
- Source URL verification
- Format validation before use
- Regular checksum updates

### CI/CD Security

- No secrets in code
- GitHub token for deployment only
- Read-only access where possible
- Audit logs for all builds

### Dependency Management

- Version pinning via renv
- Regular security updates
- Trusted package sources (CRAN)
- Vulnerability scanning (planned)

## Monitoring and Logging

### Current Logging

- Structured logs in logs/
- Console output with colors
- Error tracking with context
- Performance metrics

### Metrics Tracked

- Build success/failure rate
- Render time per chapter
- Data download success rate
- Test pass rate
- Deployment status

## Future Architecture Plans

1. **Multilingual Support**: Add Spanish/French translations
2. **Interactive Tutorials**: Embed learnr tutorials
3. **Video Content**: Integrate video explanations
4. **API Integration**: Real-time data fetching
5. **User Analytics**: Track book usage patterns
6. **Feedback System**: Collect reader comments
7. **Mobile Optimization**: Better responsive design
8. **Offline Access**: PWA for offline reading

## Technology Stack Summary

| Layer | Technology | Version | Purpose |
|-------|-----------|---------|---------|
| Document Generation | Quarto | 1.3.450 | Book rendering |
| Language | R | 4.2.0+ | Statistical computing |
| Package Management | renv | Latest | Dependency isolation |
| Testing | testthat | Latest | Unit/integration tests |
| CI/CD | GitHub Actions | - | Automation |
| Deployment | GitHub Pages | - | Hosting |
| Version Control | Git | - | Source control |
| Linting | lintr | Latest | Code quality |
| Logging | Custom | - | Structured logging |

## Contributing to Architecture

See [DEVELOPMENT.md](DEVELOPMENT.md) for guidelines on:
- Proposing architectural changes
- Adding new components
- Modifying existing systems
- Testing architecture changes

## Questions?

For architecture-related questions:
1. Check this document first
2. Review DEVELOPMENT.md
3. Examine code comments
4. Open a GitHub issue
