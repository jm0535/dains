# Data Validation Schema for Forestry Dataset
# Author: Automated validation framework
# Purpose: Define validation rules for forestry data

library(validate)

#' Forestry Data Validation Schema
#'
#' Comprehensive validation rules for forest inventory data
#'
#' @return A validator object containing all validation rules
#' @export
forestry_validation_schema <- validate::validator(
  # ===  Column Existence Rules ===
  "Required column: ID must exist" =
    "ID" %in% names(.) || "id" %in% names(.),

  "Required column: Species must exist" =
    any(c("Species", "species", "tree_species") %in% names(.)),

  # === Data Type Rules ===
  "Tree density must be numeric" =
    if ("Tree_Density_per_ha" %in% names(.)) is.numeric(Tree_Density_per_ha) else TRUE,

  "Carbon values must be numeric" =
    if ("Aboveground_Tree_Carbon_ton_per_ha" %in% names(.)) {
      is.numeric(Aboveground_Tree_Carbon_ton_per_ha)
    } else {
      TRUE
    },

  # === Value Range Rules ===
  "Tree density must be non-negative" =
    if ("Tree_Density_per_ha" %in% names(.)) {
      all(Tree_Density_per_ha >= 0, na.rm = TRUE)
    } else {
      TRUE
    },

  "Tree density must be realistic (< 10000 trees/ha)" =
    if ("Tree_Density_per_ha" %in% names(.)) {
      all(Tree_Density_per_ha < 10000, na.rm = TRUE)
    } else {
      TRUE
    },

  "Carbon values must be non-negative" =
    if ("Aboveground_Tree_Carbon_ton_per_ha" %in% names(.)) {
      all(Aboveground_Tree_Carbon_ton_per_ha >= 0, na.rm = TRUE)
    } else {
      TRUE
    },

  # === Completeness Rules ===
  "ID column must not have missing values" =
    if ("ID" %in% names(.)) !any(is.na(ID)) else TRUE,

  "At least 80% of records must be complete" =
    sum(complete.cases(.)) / nrow(.) >= 0.8,

  # === Relationship Rules ===
  "Higher tree density should correlate with higher carbon" =
    if (all(c("Tree_Density_per_ha", "Aboveground_Tree_Carbon_ton_per_ha") %in% names(.))) {
      suppressWarnings({
        complete_data <- subset(., !is.na(Tree_Density_per_ha) &
          !is.na(Aboveground_Tree_Carbon_ton_per_ha))
        if (nrow(complete_data) > 10) {
          cor(complete_data$Tree_Density_per_ha,
            complete_data$Aboveground_Tree_Carbon_ton_per_ha,
            use = "complete.obs"
          ) > -0.5
        } else {
          TRUE
        }
      })
    } else {
      TRUE
    }
)
