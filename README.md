# DSCI-522-Group-15-Repository

## Analysis report

The Milestone 1 analysis lives in
[`analysis/restaurant-net-margin-prediction.qmd`](analysis/restaurant-net-margin-prediction.qmd).
It contains sections and R chunks for downloading data, splitting, exploration,
preprocessing, baseline modeling, cross-validation, model selection, and testing.
The report is currently an incomplete scaffold: `eval: false` disables code
execution until the analysis is implemented. Remove that setting and complete
all TODOs before the final submission.

With R, Quarto, and the R packages `knitr` and `rmarkdown` installed, render from
the repository root:

```bash
quarto render analysis/restaurant-net-margin-prediction.qmd
```

The rendered HTML is written alongside the source. The report includes its own
download code and does not depend on the standalone convenience script below.

## Download the data

The original dataset is hosted on [Kaggle](https://www.kaggle.com/datasets/luthfimuthathohirin/global-food-delivery-restaurant-market-2026).
From the repository root, run the download script using R (no additional R packages required):

```bash
Rscript scripts/download_data.R
```

Run the script from the repository root. It downloads a ZIP from Kaggle and
extracts the original files to `data/raw/` without cleaning or transforming them.
No additional R packages are required.

The URL requests the latest dataset version. Before the final analysis, append
`?datasetVersionNumber=N` to the URL in the report and script, replacing `N` with
the verified dataset version used by the team.
