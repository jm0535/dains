# Data Validation Schemas

This directory contains validation schemas for all datasets used in the Data Analysis in Natural Sciences project.

## Purpose

Validation schemas define rules that data must satisfy to be considered valid. These rules help ensure data quality and catch issues early in the analysis pipeline.

## Schema Files

- `forestry_schema.R` - Validation rules for forestry datasets
- `agriculture_schema.R` - Validation rules for agricultural data
- `ecology_schema.R` - Validation rules for ecological data
- (Additional schemas as needed)

## Using Schemas

### Basic Usage

```r
# Load the validation framework
source("data/schemas/forestry_schema.R")

# Load your data
forest_data <- read.csv("data/forestry/forest_inventory.csv")

# Run validation
results <- validate::confront(forest_data, forestry_validation_schema)

# View summary
summary(results)

# Get detailed results
validate::as.data.frame(results)
```

### In Automated Pipelines

```r
# Example integration in data_validation.R
validate_with_schema <- function(data, schema_name) {
  schema_file <- sprintf("data/schemas/%s_schema.R", schema_name)

  if (!file.exists(schema_file)) {
    warning(sprintf("Schema file not found: %s", schema_file))
    return(NULL)
  }

  source(schema_file)
  schema <- get(paste0(schema_name, "_validation_schema"))

  results <- validate::confront(data, schema)
  summary(results)

  # Check if all validations passed
  all_passed <- all(validate::values(results) == TRUE, na.rm = TRUE)

  return(list(
    passed = all_passed,
    results = results,
    summary = summary(results)
  ))
}
```

## Validation Rule Types

### 1. Column Existence
Ensures required columns are present in the dataset.

```r
"Required column: ID must exist" = "ID" %in% names(.)
```

### 2. Data Types
Validates that columns have the correct data types.

```r
"Tree density must be numeric" = is.numeric(Tree_Density_per_ha)
```

### 3. Value Ranges
Checks that values fall within expected ranges.

```r
"Tree density must be non-negative" = all(Tree_Density_per_ha >= 0, na.rm = TRUE)
```

### 4. Completeness
Ensures data doesn't have excessive missing values.

```r
"At least 80% of records must be complete" = sum(complete.cases(.)) / nrow(.) >= 0.8
```

### 5. Relationships
Validates expected relationships between variables.

```r
"Density correlates with carbon" = cor(Density, Carbon) > 0.5
```

## Creating New Schemas

To create a validation schema for a new dataset:

1. Create a new R file: `data/schemas/[dataset_name]_schema.R`
2. Define validation rules using the `validate::validator()` function
3. Document each rule with a clear description
4. Test the schema with real data
5. Add examples to this README

### Schema Template

```r
# Data Validation Schema for [Dataset Name]
library(validate)

[dataset_name]_validation_schema <- validate::validator(
  # Column existence
  "Column X must exist" = "X" %in% names(.),

  # Data types
  "X must be numeric" = is.numeric(X),

  # Value ranges
  "X must be positive" = all(X > 0, na.rm = TRUE),

  # Completeness
  "X must not have missing values" = !any(is.na(X)),

  # Relationships
  "X and Y must be correlated" = cor(X, Y, use = "complete.obs") > 0.5
)
```

## Benefits

- **Early Error Detection**: Catch data quality issues before analysis
- **Documentation**: Rules serve as documentation of data expectations
- **Reproducibility**: Consistent validation across different analysis runs
- **Debugging**: Quickly identify which data quality checks fail
- **Collaboration**: Team members understand data requirements

## Best Practices

1. **Be Specific**: Write clear, descriptive rule names
2. **Handle Missing Data**: Use `na.rm = TRUE` or check for NAs explicitly
3. **Conditional Rules**: Use `if-else` for rules that depend on column existence
4. **Test Schemas**: Validate schemas with both good and bad data
5. **Version Control**: Track schema changes in git
6. **Document Assumptions**: Explain why rules exist (e.g., "Trees/ha typically < 10000")

## Troubleshooting

### Schema Not Found
```r
Error: Schema file not found
```
**Solution**: Check file path and ensure schema file exists

### Validation Fails Unexpectedly
```r
# Debug by checking individual rules
results <- validate::confront(data, schema)
validate::as.data.frame(results)  # See which rules failed
```

### Performance Issues with Large Datasets
```r
# Sample data for validation
sample_data <- data[sample(nrow(data), min(10000, nrow(data))), ]
results <- validate::confront(sample_data, schema)
```

## Resources

- [validate package documentation](https://cran.r-project.org/package=validate)
- [Data validation in R](https://data-cleaning.github.io/validate/)
- [Data quality best practices](https://www.go-fair.org/fair-principles/)
