# renv - Reproducible Package Management

This project uses [renv](https://rstudio.github.io/renv/) to manage R package dependencies, ensuring reproducible environments across different machines and over time.

## What is renv?

renv is a dependency management tool for R that:
- Creates isolated, project-specific package libraries
- Captures exact package versions in `renv.lock`
- Makes projects reproducible across different systems
- Prevents package version conflicts between projects

## Setup

### First-Time Setup

If this is your first time working with this project:

```r
# Run the setup script
source("scripts/setup_renv.R")

# Or manually:
install.packages("renv")
renv::restore()
```

This will install all packages at the exact versions specified in `renv.lock`.

### Daily Usage

When you open the project, renv is automatically activated via `.Rprofile`.

## Common Commands

### Check Environment Status
```r
renv::status()
```
Shows whether your installed packages match `renv.lock`.

### Install New Package
```r
install.packages("newpackage")
renv::snapshot()  # Save the new dependency
```

### Update Package Versions
```r
renv::update("packagename")  # Update specific package
renv::update()  # Update all packages
renv::snapshot()  # Save changes
```

### Restore Environment
```r
renv::restore()
```
Use this if packages are out of sync with `renv.lock`.

### Clean Unused Packages
```r
renv::clean()
```
Removes packages not used by the project.

## Files Created by renv

- **renv.lock**: JSON file with exact package versions (commit this!)
- **renv/**: Directory containing project-specific package library (don't commit)
- **.Rprofile**: Activates renv when R starts (commit this)
- **renv/.gitignore**: Configured to exclude large library files

## Troubleshooting

### Packages Out of Sync
```r
renv::status()  # Check what's different
renv::restore()  # Restore to renv.lock state
```

### Installation Fails
```r
# Try updating renv itself
renv::upgrade()

# Or rebuild the library
renv::rebuild()
```

### Snapshot Issues
```r
# Force snapshot of current state
renv::snapshot(force = TRUE)
```

## CI/CD Integration

In GitHub Actions (`.github/workflows/publish.yml`), renv automatically:
1. Reads `renv.lock`
2. Installs exact package versions
3. Ensures consistent builds

## Migration from Manual Installation

If you previously used `scripts/install_packages.R` without renv:

1. Your existing packages will be detected
2. Run `renv::snapshot()` to capture current versions
3. Continue using the project normally
4. renv maintains backward compatibility

## Best Practices

1. **Commit renv.lock**: Always commit after adding/updating packages
2. **Don't commit renv/ library**: It's in .gitignore for a reason
3. **Regular snapshots**: Run `renv::snapshot()` after installing packages
4. **Check status often**: Use `renv::status()` to stay in sync
5. **Restore on new machines**: First command should be `renv::restore()`

## Resources

- [renv Documentation](https://rstudio.github.io/renv/)
- [renv on CRAN](https://cran.r-project.org/package=renv)
- [Introduction to renv](https://rstudio.github.io/renv/articles/renv.html)
