# Editorial Review: *Data Analysis in Natural Sciences*

**Review date:** 25 September 2026  
**Scope:** source manuscript (`.qmd`), datasets, Quarto configuration, exercises, references, and the book's existing maintenance notes. This is an editorial and instructional review, not a line-by-line copy edit.

## Executive assessment

This is a promising, unusually practical open textbook. Its strongest features are the end-to-end workflow, natural-science framing, reproducible Quarto/R project, explicit assumption checks, and the willingness to explain interpretation rather than only provide code. The tone is approachable and the figures include useful alternative text.

The main issue is not lack of material; it is **scope and trust**. At roughly 11,500 lines across 11 chapters, the book sometimes reads like several books placed together. A reader can also encounter an exercise whose scientific context does not match the supplied file, or a methodological recommendation that needs more qualification. Those problems are fixable, but they should be addressed before adding more topics.

**Overall recommendation: major revision, with a strong basis for a publishable second edition.**

### Priority summary

| Priority | Recommendation | Why it matters |
|---|---|---|
| P0 | Repair every dataset/exercise mismatch and add automated exercise checks | A beginner must be able to trust that the prompt, variables, and scientific story agree. |
| P0 | Audit and execute every evaluated code chunk in a clean environment | The current syntax test only parses code; it does not establish that the book renders successfully. |
| P1 | Tighten the statistical curriculum around estimands, design, uncertainty, effect sizes, and model validation | The book is strongest when it teaches reasoning; several sections still risk teaching test-first workflows. |
| P1 | Reorganize and reduce duplication, especially Chapter 1 and the transition to modeling | A clearer learning progression will make the large amount of material usable. |
| P1 | Add citations where methods are taught and remove or use unused bibliography entries | Methodological claims need provenance and readers need a route to deeper study. |
| P2 | Improve exercises, accessibility, navigation, and maintenance metadata | These changes improve classroom adoption and long-term credibility. |

## What is working well

1. **A coherent real-world workflow.** The book repeatedly connects import, tidy, explore, visualize, model, validate, and communicate. That is a better organizing idea than a catalogue of R functions.
2. **Natural-science relevance.** Examples in ecology, conservation, agriculture, marine science, and environmental work give students a reason to learn the technique.
3. **Reproducibility is treated as part of analysis.** Git, Quarto, `renv`, seeds, relative paths, and session information are introduced rather than left as an afterthought.
4. **Interpretation is present.** The prose after the code often explains what a result means and warns against equating statistical significance with practical importance.
5. **Good visual communication foundations.** Figures have captions and extensive `fig-alt` text; colorblind-friendly palettes are used in several places; the book has a useful HTML reading experience.
6. **Honest maintenance notes.** `data/MISMATCHES.md` and the existing history documents show that the project is already auditing its own weaknesses instead of hiding them.

## Major revisions recommended

### 1. Make the data contract truthful and enforce it (P0)

The repository explicitly records that several filenames do not describe their contents (`data/MISMATCHES.md`). The most serious examples are:

- `data/environmental/climate_data.csv` is Palmer Penguins, not climate data.
- `data/forestry/forest_inventory.csv` is Star Wars character data, not a forest inventory.
- `data/entomology/insects.csv` is animal-shelter outcomes.
- `data/botany/plant_traits.csv` is a plastic-waste audit.
- `data/epidemiology/disease_data.csv` is Atlantic hurricane data.
- `data/geography/spatial.csv` is EMA medicine authorisation data.
- `data/marine/ocean_data.csv` is Great Lakes fish data.

The book discloses this in the landing page, but disclosure does not repair a misleading exercise. For example, Chapter 4 asks for “tree measurements” from the forestry file and asks for a confidence interval for `temperature` in the environmental file; those variables are not in the supplied data. Chapter 5 similarly frames the entomology file as an insect dataset.

**Recommended fix:** either source domain-matching data, or rename the files and rewrite the framing around the actual data. If the files must remain stable, give each dataset a neutral descriptive name and maintain a small data dictionary. Every exercise should be checked against the dictionary for:

- file exists;
- columns exist;
- column types are suitable;
- grouping variables have enough levels and observations;
- the scientific prompt matches the data-generating context.

Add a test that extracts the exercise dataset paths and validates them, and add a short “Dataset reality check” callout at first use.

### 2. Add a genuine render/test gate (P0)

`tests/test-chapters.R` only uses `knitr::purl()` and `parse()`. Parsing catches malformed R syntax, but it does not catch missing packages, wrong column names, bad paths, invalid arguments, or a chunk that fails during rendering. The Quarto configuration also sets `error: false`, which can allow a rendered book to look complete while an evaluated chunk has failed.

**Recommended fix:** create two CI modes:

1. **Fast static gate:** parse chunks, check labels, links, citations, required files, and data schemas.
2. **Clean render gate:** render the book from a fresh `renv` environment with `error: true`, then fail on any warning/error that is not explicitly allow-listed.

Keep expensive or network-dependent examples behind `eval: false`, but mark them visibly as “not executed during the build” and provide a tested local path. Run a smaller smoke render on every pull request and a full render on release/main.

### 3. Rebuild the learning architecture before adding content (P1)

The manuscript is ambitious, but the progression is uneven:

- Chapter 1 is exceptionally long and repeats introductory material: tidyverse, tidy data, the workflow, data types, package management, and a first analysis appear in multiple passes.
- Chapter 10 is a very large jump into SDMs, spatial autocorrelation, monitoring, fragmentation, prioritisation, traits, and enforcement-style examples.
- Chapter 11 is a broad survey of tools rather than a continuation of the core analysis path.
- The preface says the book has “four main parts,” while `_quarto.yml` defines six parts. The README and the actual navigation also use slightly different labels.

**Recommended fix:** define a single course spine and make every chapter serve it. A possible structure is:

1. Foundations and data literacy (Chapters 1–2, substantially shortened).
2. Exploration and communication (Chapters 3 and 6–7).
3. Inference for designed studies (Chapters 4–5).
4. Regression and hierarchical data (Chapters 8–9).
5. Applied case studies (Chapter 10, split into shorter case-study chapters or made optional).
6. Reproducible tools and integrations (Chapter 11, optional appendix).

End each chapter with the same compact pattern: **key ideas, decision checklist, one fully specified worked example, practice exercises, and next steps**. Remove repeated explanations rather than continually appending new versions.

### 4. Make the statistical message more design-first (P1)

The book has many good cautions, but the overall path can still be read as “choose a test, check normality, report a p-value.” Strengthen the design and estimand logic before the test catalogue:

- Start with the observational unit, sampling unit, treatment/exposure, response, estimand, and source of replication.
- Distinguish descriptive, predictive, and causal questions.
- Explain that randomisation and sampling design determine what inference is justified; a statistical test cannot repair pseudoreplication or confounding.
- Make effect estimates and uncertainty the primary output, with p-values secondary.
- Treat assumption checks as model diagnostics, not a mechanical pre-test that decides the analysis from a single threshold.

Specific points to revise:

- Chapter 4 presents one-tailed tests as a way to increase power. Qualify this strongly: direction and exclusion of the opposite direction must be specified before seeing the data and justified by the scientific question; it is not a post hoc power setting.
- The Shapiro-Wilk discussion is better than average, but explicitly say that normality of the **outcome** is not the t-test assumption; for regression-style models, inspect residuals and the design/independence assumptions. Emphasize that independence cannot be tested by Shapiro-Wilk.
- The discussion of “10 events per predictor” in Chapter 8 should be labeled a rough historical heuristic, not a universal rule. Point readers toward separation, penalization, calibration, bootstrap/cross-validation, and the actual information in the data.
- Expand multiple-comparison control in Chapter 5, including planned contrasts versus exploratory post hoc comparisons and the consequence of testing many outcomes.
- Add a short section on missing-data mechanisms (MCAR/MAR/MNAR), rather than treating missingness mostly as a cleaning/visualization issue.
- Add clustered/repeated-measures examples earlier. Natural-science readers commonly sample plots within sites, observations within species, and repeated times within locations; this is central, not merely advanced.

### 5. Separate inference from prediction in the modeling chapters (P1)

Chapter 8 moves from `lm()` inference to tidymodels prediction, but the distinction should be explicit. A model that estimates an association is not automatically a good predictive model, and a high cross-validated score is not evidence of causation.

Add a comparison table covering:

- question and target;
- data split/resampling strategy;
- appropriate metrics;
- uncertainty to report;
- what a coefficient can and cannot mean;
- when random train/test splitting is invalid.

For the penguin examples, discuss grouped or blocked resampling by species/site when the intended deployment is to a new group. Demonstrate that preprocessing belongs inside the resampling workflow to avoid leakage. Include calibration and a baseline model alongside AUC/accuracy; warn that accuracy can be misleading with class imbalance. For time series and spatial data, show blocked validation rather than ordinary random folds.

### 6. Strengthen source attribution and scholarly scaffolding (P1)

The bibliography contains many useful sources, but citation use is sparse and uneven: several chapters have no method citations, while many bibliography entries are unused. Add citations at the point of methodological claims, especially for:

- tidy data and visualization;
- p-values and statistical inference;
- mixed models and GLMs;
- effect sizes and power;
- random forests and model interpretation;
- spatial statistics and SDMs;
- data sources and licenses.

For each external dataset, give a human-readable citation, access date, license/terms, transformation note, and the exact version or download URL. A `CITATION.txt` file is useful, but the chapter should not force the learner to leave the book to understand provenance.

### 7. Treat Chapter 11 as a maintained technology appendix (P1/P2)

This chapter includes time-sensitive claims such as specific 2026 Positron releases, Radian's maintenance status, and Posit Cloud publishing behavior. Those statements will age faster than the statistical chapters, and all of the chapter's chunks are globally `eval: false`.

Move the most volatile installation/version advice into a maintained appendix or external companion page. Add “last verified” dates and link to official documentation. Explain clearly that `eval: false` means the examples are illustrative and not verified by the book build. A small decision matrix (task, recommended tool, maturity, maintenance burden, reproducibility implications) would be more useful than a long catalogue.

## Exercise and assessment improvements

The exercises are a strong foundation, but they should be more diagnostic and less open-ended. For every chapter, provide:

- one “predict before running” question;
- one code-completion or debugging task;
- one interpretation task with a deliberately tempting wrong conclusion;
- one reporting task with a required estimand, uncertainty interval, and limitation;
- a difficulty label and estimated time;
- an explicit expected output (table, plot, paragraph, or decision);
- an instructor solution or rubric in the separate solutions branch.

Add a capstone project that follows one dataset from research question through data audit, exploratory analysis, model choice, validation, visualisation, and a reproducible short report. This will unify the otherwise broad book.

## Accessibility, usability, and copy editing

1. Keep the strong `fig-alt` practice, but check that every alt description conveys the takeaway without encoding too many exact visual details. Add table headers/scope and test keyboard navigation in the HTML output.
2. Avoid relying on color alone for groups or status; add shapes, linetypes, direct labels, or an accessible table where appropriate. Check contrast for custom themes and annotations.
3. Consider a print/PDF or downloadable source-friendly version for field and low-bandwidth use. The online book is excellent for interactive work, but not every reader has reliable access to a live site.
4. Standardize spelling and terminology (for example, analysis/modelling conventions), heading capitalization, “tidyverse” styling, and whether code uses `%>%` or the native `|>`.
5. Replace marketing-style headings such as “PROFESSIONAL TIP” with descriptive headings where possible. The advice is good; descriptive headings improve search and navigation.
6. Complete repository placeholders outside the book, notably the `[INSERT EMAIL ADDRESS]` contact in `CODE_OF_CONDUCT.md`, and keep the README's date, book structure, and dataset description synchronized with `_quarto.yml`.

## Suggested release plan

### Release 1: trust and buildability

- Repair/reframe mismatched datasets and exercises.
- Add schema/data-dictionary tests.
- Render with `error: true` in CI and fix every evaluated-chunk failure.
- Check links, citations, duplicate labels, and generated output.
- Reconcile README, preface, navigation, and release dates.

### Release 2: pedagogy and statistical rigor

- Condense Chapter 1 and revise the book map.
- Add design/estimand and inference-versus-prediction sections.
- Revise one-tailed tests, normality checks, events-per-variable guidance, missing data, multiplicity, and validation.
- Rewrite exercises using rubrics and expected outputs.

### Release 3: polish and reach

- Add method/data citations and provenance metadata.
- Accessibility and keyboard/contrast audit.
- Add a capstone and instructor materials.
- Move fast-changing tool advice to a maintained appendix.
- Publish a stable release with a changelog and versioned rendered artifact.

## Bottom line

Do not add more statistical methods yet. The book already has enough breadth. The highest-value work is to make every example truthful and executable, teach design and estimands before test selection, and give the reader a shorter, more deliberate path through the material. With those changes, this can become a distinctive and genuinely useful open textbook rather than merely a comprehensive one.
