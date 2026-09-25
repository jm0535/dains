# Dataset dictionary

These are the **actual** datasets shipped with the book. Directory names are
historical chapter labels and are not always descriptions of the source data.
Use the column names below when adapting an exercise.

| File | Observational unit | Core columns | Intended teaching use |
|---|---|---|---|
| `agriculture/crop_yields.csv` | country-year | `Entity`, `Year`, crop yield columns | grouped summaries and trends |
| `botany/plant_traits.csv` | country-year audit record | `parent_company`, polymer columns, `num_events` | categorical/count data |
| `ecology/biodiversity.csv` | species record | `binomial_name`, `continent`, `year_last_seen`, `red_list_category` | data cleaning and categorical analysis |
| `economics/economic.csv` | coffee lot | `total_cup_points`, `altitude`, quality scores | regression and prediction |
| `entomology/insects.csv` | year-animal-outcome record | `year`, `animal_type`, `outcome`, state counts | count summaries and group comparisons |
| `environmental/climate_data.csv` | penguin | `species`, `island`, morphology columns | visualization and regression |
| `epidemiology/disease_data.csv` | storm observation | `name`, date fields, coordinates, `wind`, `pressure` | spatial/time data examples |
| `forestry/forest_inventory.csv` | Star Wars character | `name`, `height`, `mass`, `species` | illustrative numeric/grouped examples |
| `geography/spatial.csv` | medicine authorisation | medicine, therapeutic area, status, dates | categorical and date handling |
| `marine/ocean_data.csv` | lake-year-species record | `year`, `lake`, `species`, `values` | long-format time series |

The files are educational examples, not interchangeable evidence for claims
about the disciplines named by their directories. Read `CITATION.txt` in each
directory before redistributing data, and inspect `names()` and `glimpse()`
before writing an analysis.
