
## Chapter Summary

### Key Concepts

-   **Test Selection**: Choosing the right test depends on data type, distribution, and study design
-   **Parametric vs. Non-Parametric**: Parametric tests have more power but require normality; non-parametric tests are more robust
-   **Group Comparisons**: t-tests and ANOVA compare means across two or more groups
-   **Relationships**: Correlation and regression quantify associations between variables
-   **Post-hoc Testing**: Essential for ANOVA and Kruskal-Wallis to pinpoint specific differences

### R Functions Learned

-   `t.test()` - One-sample, two-sample, and paired t-tests
-   `aov()` - Analysis of Variance (ANOVA)
-   `TukeyHSD()` - Post-hoc test for ANOVA
-   `wilcox.test()` - Mann-Whitney U and Wilcoxon signed-rank tests
-   `kruskal.test()` - Kruskal-Wallis test
-   `cor.test()` - Correlation analysis (Pearson and Spearman)
-   `lm()` - Linear and multiple regression models
-   `shapiro.test()` - Test for normality

### Next Steps

In the next part of the book, we will shift our focus to **Data Visualization**, exploring how to create compelling and informative graphics to communicate your results effectively.

## Exercises

1.  **Test Selection**: For each of the following scenarios, identify the appropriate statistical test:
    -   Comparing tree heights between three different soil types (normal distribution)
    -   Testing if the number of bird species differs between two forest fragments (non-normal)
    -   Predicting biomass based on rainfall and temperature

2.  **Group Comparison**: Use the `iris` dataset to compare sepal lengths among the three species using ANOVA. Follow up with a post-hoc test.

3.  **Non-Parametric Test**: Use the `mtcars` dataset to compare fuel efficiency (`mpg`) between automatic and manual transmissions (`am`) using a non-parametric test.

4.  **Correlation**: Analyze the relationship between two continuous variables in your own dataset. Calculate the correlation coefficient and interpret the result.

5.  **Regression**: Fit a linear regression model to predict a continuous outcome. Interpret the slope and R-squared value.

6.  **Reporting**: Write a short paragraph reporting the results of one of your analyses, including the test statistic, degrees of freedom, p-value, and effect size.
