# Predicting Restaurant Net Margin from Food Delivery Orders

**DSCI 522 — Group 15 | Milestone 1**

## Project overview

The project investigates whether an order's estimated restaurant net margin (in USD) can be predicted from information available when a food delivery order is placed. We use the [Global Food Delivery Restaurant Market 2026 dataset](https://www.kaggle.com/datasets/luthfimuthathohirin/global-food-delivery-restaurant-market-2026/data) by Luthfi Muthathohirin.

The supplied dataset has 8,000 orders and 26 columns. The analysis selects 11 order-time predictors and the target, creates a reproducible 80% training / 20% test split (6,400 / 1,600 orders; with random seed `522`), performs exploratory analysis, and compares a mean-prediction baseline, ordinary least-squares linear regression, and ridge regression. Model selection uses five-fold cross-validation on the training set; the held-out test set is used for final evaluation. The target is a *dataset-estimated* margin, not a verified accounting measure of realized restaurant profit.

## Repository structure

The following paths are relative to the **repository root**:

```text
.
├── README.md
├── analysis/
│   ├── restaurant-net-margin-prediction.qmd   # Executable analysis source
│   └── restaurant-net-margin-prediction.html  # Generated report after rendering
├── data/
│   ├── raw/
│   │   └── global_food_delivery_enriched_market_2026.csv
│   └── processed/
│       ├── orders_train.csv
│       └── orders_test.csv
├── .Rprofile                               # Activates renv on project startup
├── renv.lock                               # Pinned R package dependencies
└── renv/
    ├── activate.R
    └── settings.json
```

The report creates `data/raw/` and `data/processed/` if they do not exist, downloads the raw data if the CSV is missing, and writes the processed training and test CSVs. The HTML report is generated alongside the `.qmd` file.

## Requirements

Install the following on Windows or macOS:

1. [R](https://cran.r-project.org/) **4.6.1** 
2. [Quarto CLI](https://quarto.org/docs/get-started/) to render the `.qmd` report.
3. [RStudio Desktop](https://posit.co/download/rstudio-desktop/) (recommended, but optional), or another terminal/editor that can run R and Quarto.
4. Internet access for the initial R package installation and, if the raw CSV is absent, the Kaggle dataset download.

## Reproduce the analysis (Windows and macOS)

### 1. Open the repository root

Download or clone the repository, and **open its root folder**, not the `analysis/` subfolder. In RStudio, use **File > New Project > Existing Directory** to select this folder if you do not already have an `.Rproj` file. Confirm that the R Console shows the repository root when you run:

```r
getwd()
```

The root folder must contain `analysis/restaurant-net-margin-prediction.qmd`.

### 2. Restore the R virtual environment

In the **R Console** (same commands on Windows and macOS), run:

```r
if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv", repos = "https://cloud.r-project.org")
}
renv::restore(prompt = FALSE)
```

This restores the R package versions recorded in `renv.lock` to the project-specific library. It may take several minutes on a new computer. You can check the environment with:

```r
renv::status()
```

Do not replace this step with an unpinned `install.packages("tidyverse")` or `install.packages("glmnet")` when reproducing a submitted result.

### 3. Make the input data available

**Option A — automatic download (default):** No manual download is needed. When the report runs, its R code downloads the public Kaggle dataset ZIP if `data/raw/global_food_delivery_enriched_market_2026.csv` is missing, then extracts it to `data/raw/`.

**Option B — manual download (fallback):** If Kaggle is blocked, or you want to reproduce the analysis using the exact dataset version provided with the submission:

1. Download the dataset from the [Kaggle source page](https://www.kaggle.com/datasets/luthfimuthathohirin/global-food-delivery-restaurant-market-2026/data).
2. Extract the archive if necessary.
3. Create `data/raw/` under the repository root if it does not exist (using File Explorer on Windows or Finder on macOS is fine).
4. Place **`global_food_delivery_enriched_market_2026.csv`** directly in `data/raw/` (not in a nested subfolder).

For the original CSV supplied with this milestone, the SHA-256 checksum is:

```text
31b2c932fddef2026085c98208b124d8ce4b47dfa9020272e3ba8f80e5699f38
```

To verify that your local file is identical, run one of these commands **from the repository root**:

**macOS Terminal**

```bash
shasum -a 256 data/raw/global_food_delivery_enriched_market_2026.csv
```

**Windows PowerShell**

```powershell
Get-FileHash -Algorithm SHA256 data/raw/global_food_delivery_enriched_market_2026.csv
```

If Kaggle later changes its published dataset, the automatically downloaded file may no longer match this checksum. Use the original, version-pinned dataset for exact result reproducibility.

### 4. Run the complete analysis

In **Terminal** (macOS), **PowerShell** (Windows), or RStudio's **Terminal** tab, navigate to the repository root and run:

```bash
quarto render analysis/restaurant-net-margin-prediction.qmd
```

Alternatively, open `analysis/restaurant-net-margin-prediction.qmd` in RStudio and click **Render**. The report currently has `execute: eval: true`, so Quarto executes its R chunks rather than merely displaying them.

**Expected generated files:**

- `analysis/restaurant-net-margin-prediction.html` — report containing the exploration, model comparison, and final test evaluation.
- `data/raw/global_food_delivery_enriched_market_2026.csv` — source dataset, if it needed to be downloaded.
- `data/processed/orders_train.csv` — 6,400 rows and 12 columns.
- `data/processed/orders_test.csv` — 1,600 rows and 12 columns.

Both processed files are produced **by the report**; do not manually substitute the pre-split CSVs for the raw dataset. Rendering again will regenerate the split with seed `522`, assuming the same input data and compatible R/package versions.

### 5. Verify the results

After a successful render, check that:

1. The HTML output exists and includes the results and plots.
2. Both processed CSV files exist and have 6,400 and 1,600 rows, respectively.
3. `renv::status()` reports that the project environment is synchronized.
4. The render completes on both Windows and macOS using a clean checkout and the steps above.

You can check the processed CSV row counts in the R Console:

```r
nrow(read.csv("data/processed/orders_train.csv"))
nrow(read.csv("data/processed/orders_test.csv"))
```

## Troubleshooting

- **`quarto` is not recognized:** Install the Quarto CLI, restart the terminal, and confirm `quarto --version` works; alternatively, use RStudio's **Render** button.
- **A package is missing:** Make sure the R session is opened from the repository root and rerun `renv::restore(prompt = FALSE)`. If RStudio was open when `renv` was initialized, restart the R session.
- **Data download fails:** Follow the manual data-download steps above, then render again. The report skips downloading if the expected raw CSV is already present.
- **An unexpected file path is reported:** Run the documented render command from the repository root. The `.qmd` itself uses `../data/...` paths relative to its location in `analysis/`.
- **Different results across computers:** Verify the raw CSV checksum, ensure the same `renv.lock` was restored, and confirm the R and Quarto versions. Pin the Kaggle dataset version in the report's download URL before submission.

## Data source and attribution

Muthathohirin, L. *Global Food Delivery Restaurant Market 2026*. Kaggle. https://www.kaggle.com/datasets/luthfimuthathohirin/global-food-delivery-restaurant-market-2026/data
