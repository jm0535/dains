
## Chapter Summary

### Key Concepts

-   **Descriptive Statistics**: Measures of central tendency (mean, median) and dispersion (SD, IQR) summarize data properties
-   **Data Distributions**: Visualizing distributions helps identify skewness, multimodality, and outliers
-   **Relationships**: Scatter plots and correlation matrices reveal associations between variables
-   **Outliers**: Identifying extreme values is crucial for data quality and robust analysis
-   **Missing Data**: Understanding missingness patterns informs appropriate handling strategies

### R Functions Learned

-   `summarize()` - Calculate summary statistics
-   `geom_histogram()` / `geom_density()` - Visualize distributions
-   `geom_boxplot()` - Compare distributions and identify outliers
-   `geom_point()` - Create scatter plots
-   `cor()` - Calculate correlation coefficients
-   `pairs()` / `ggpairs()` - Create pair plots for multiple variables
-   `is.na()` - Detect missing values

### Next Steps

In the next chapter, we will move from exploration to inference, learning how to formulate and test scientific hypotheses using statistical methods.

## Exercises

1.  **Descriptive Statistics**: Calculate the mean, median, and standard deviation for a continuous variable in your own dataset.
2.  **Distribution Visualization**: Create a histogram and density plot for the same variable. Describe the shape of the distribution.
3.  **Group Comparison**: Use box plots to compare the distribution of a continuous variable across different groups (e.g., species, treatments).
4.  **Correlation Analysis**: Calculate the correlation matrix for a set of continuous variables and visualize it using a heatmap or pair plot.
5.  **Outlier Detection**: Identify potential outliers in your dataset using the IQR method or Z-scores.
6.  **Missing Data**: Visualize missing data patterns in your dataset and discuss potential reasons for missingness.
