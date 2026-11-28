# Predicting Restaurant Net Margin from Food Delivery Orders

**DSCI 522 - Group 15 \| Milestone 1, Milestone 2**

## Authors

- **Jerry Jin**
- **Afrah Zilani**
- **Jerry Zeng**

## Published Report

The full analysis report for this project is available on GitHub Pages:

[View the Restaurant Net Margin Prediction Report](https://ubc-mds-2026-27.github.io/DSCI522-group-15/)

## AI use statement

AI was used purely for debugging codes and provide guidance to structuring and formatting the files, none were used to generate lines of codes. ChatGPT was used.

## Project overview

The project investigates whether an order's estimated restaurant net margin (in USD) can be predicted from information available when a food delivery order is placed. We use the [Global Food Delivery Restaurant Market 2026 dataset](https://www.kaggle.com/datasets/luthfimuthathohirin/global-food-delivery-restaurant-market-2026/data) by Luthfi Muthathohirin.

The supplied dataset has 8,000 orders and 26 columns. The analysis selects 11 order-time predictors and the target, creates a reproducible 80% training / 20% test split (6,400 / 1,600 orders; with random seed `522`), performs exploratory analysis, and compares a mean-prediction baseline, ordinary least-squares linear regression, and ridge regression. Model selection uses five-fold cross-validation on the training set; the held-out test set is used for final evaluation. The target is a *dataset-estimated* margin, not a verified accounting measure of realized restaurant profit.

## Repository structure

The following paths are relative to the **repository root**:

``` text
.
├── README.md
├── CONTRIBUTING.md
├── LICENSE.md
├── CODE_OF_CONDUCT.md
├── Dockerfile                          # Container image definition for R/renv + Quarto
├── docker-compose.yml                  # Pins container image tag and analysis-env service
├── DSCI522-group-15.Rproj
├── analysis/
│   ├── restaurant-net-margin-prediction.qmd   # Executable analysis source
│   └── restaurant-net-margin-prediction.html  # Generated report after rendering
├── data/
│   ├── raw/
│   │   └── global_food_delivery_enriched_market_2026.csv
│   └── processed/
│       ├── orders_train.csv
│       └── orders_test.csv
├── docs/
│   ├── index.html                      # Self-contained report served on GitHub Pages
│   └── .nojekyll                       # Disables Jekyll processing for GitHub Pages
├── .github/
│   └── workflows/
│       └── publish-dockerhub.yml       # Builds and pushes multi-platform Docker image
├── .Rprofile                           # Activates renv on project startup
├── renv.lock                           # Pinned R package dependencies
└── renv/
    ├── activate.R
    └── settings.json
```

The report creates `data/raw/` and `data/processed/` if they do not exist, downloads the raw data if the CSV is missing, and writes the processed training and test CSVs. The HTML report is generated alongside the `.qmd` file.

## Requirements

Install the following on Windows or macOS:

1.  [R](https://cran.r-project.org/) **4.6.1**
2.  [Quarto CLI](https://quarto.org/docs/get-started/) to render the `.qmd` report.
3.  [RStudio Desktop](https://posit.co/download/rstudio-desktop/) (recommended, but optional), or another terminal/editor that can run R and Quarto.
4.  Internet access for the initial R package installation and, if the raw CSV is absent, the Kaggle dataset download.

## Milestone 1 - Reproducing the analysis (Windows and macOS)

### 1. Open the repository root

Download or clone the repository, and **open its root folder**, not the `analysis/` subfolder. In RStudio, use **File \> New Project \> Existing Directory** to select this folder if you do not already have an `.Rproj` file. Confirm that the R Console shows the repository root when you run:

``` r
getwd()
```

The root folder must contain `analysis/restaurant-net-margin-prediction.qmd`.

### 2. Restore the R virtual environment

In the **R Console** (same commands on Windows and macOS), run:

``` r
if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv", repos = "https://cloud.r-project.org")
}
renv::restore(prompt = FALSE)
```

This restores the R package versions recorded in `renv.lock` to the project-specific library. It may take several minutes on a new computer. You can check the environment with:

``` r
renv::status()
```

### 3. Make the input data available

**Option A — automatic download (default):** No manual download is needed. When the report runs, its R code downloads the public Kaggle dataset ZIP if `data/raw/global_food_delivery_enriched_market_2026.csv` is missing, then extracts it to `data/raw/`.

**Option B — manual download (fallback):** If Kaggle is blocked:

1.  Download the dataset from the [Kaggle source page](https://www.kaggle.com/datasets/luthfimuthathohirin/global-food-delivery-restaurant-market-2026/data).
2.  Extract the archive if necessary.
3.  Create `data/raw/` under the repository root if it does not exist (using File Explorer on Windows or Finder on macOS is fine).
4.  Place **`global_food_delivery_enriched_market_2026.csv`** directly in `data/raw/` (not in a nested subfolder).

For the original CSV supplied with this milestone, the SHA-256 checksum is:

``` text
31b2c932fddef2026085c98208b124d8ce4b47dfa9020272e3ba8f80e5699f38
```

To verify that your local file is identical, run one of these commands **from the repository root**:

**macOS Terminal**

``` bash
shasum -a 256 data/raw/global_food_delivery_enriched_market_2026.csv
```

**Windows PowerShell**

``` powershell
Get-FileHash -Algorithm SHA256 data/raw/global_food_delivery_enriched_market_2026.csv
```

If Kaggle later changes its published dataset, the automatically downloaded file may no longer match this checksum. Use the original, version-pinned dataset for exact result reproducibility.

### 4. Run the complete analysis

In **Terminal** (macOS), **PowerShell** (Windows), or RStudio's **Terminal** tab, navigate to the repository root and run:

``` bash
quarto render analysis/restaurant-net-margin-prediction.qmd
```

Alternatively, open `analysis/restaurant-net-margin-prediction.qmd` in RStudio and click **Render**. The report currently has `execute: eval: true`, so Quarto executes its R chunks rather than merely displaying them.

### 5. Verify the results

After a successful render, check that:

1.  The HTML output exists and includes the results and plots.
2.  Both processed CSV files exist and have 6,400 and 1,600 rows, respectively.
3.  `renv::status()` reports that the project environment is synchronized.
4.  The render completes on both Windows and macOS using a clean checkout and the steps above.

You can check the processed CSV row counts in the R Console:

``` r
nrow(read.csv("data/processed/orders_train.csv"))
nrow(read.csv("data/processed/orders_test.csv"))
```

### Milestone 2 -Reproducing the Analysis

The analysis can be reproduced using the Docker environment configured in this repository. The container includes the required R environment, R packages, and Quarto installation. You do not need to install the project's R packages or Quarto locally.

### Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running (Windows or macOS).

- Git installed.

- A terminal (Terminal on macOS or PowerShell on Windows).

Run the following commands from the repository root.

### 1. Generate an SSH key

If you do not already have an SSH key, generate one by running:

```         
ssh-keygen -t ed25519
```

Press Enter at each prompt to accept the default file location and settings.

This step is important because the Docker Compose configuration mounts the public SSH key at `~/.ssh/id_ed25519.pub`. If the key does not exist, Docker may create a directory at that path, causing SSH connections to the container to fail.

### 2. Download the Docker image

Download the pre-built container image specified in `docker-compose.yml`:

```         
docker compose pull
```

Wait for the image to finish downloading before proceeding.

### 3. Render the report inside the container

Run the following command from the repository root:

```         
docker compose run --rm analysis-env quarto render analysis/restaurant-net-margin-prediction.qmd
```

This runs the Quarto report using the R environment inside the `analysis-env` container.

The report's HTML output will be generated at:

`analysis/restaurant-net-margin-prediction.html`

The `.qmd` file path is included explicitly because the project does not use a root-level `_quarto.yml` to list the report.

### 4. Container cleanup

The `--rm` option automatically stops and removes the temporary container after the rendering process finishes. The generated files remain in the project directory because the repository is mounted into the container.

If you instead start the container in the background using:

```         
docker compose up -d
```

stop and remove the container and its network when finished by running:

```         
docker compose down
```

### 5. View the report

After rendering, the generated HTML report can be opened locally from the `analysis/` directory.

The published report is also available here:

[View the project report on GitHub Pages](https://ubc-mds-2026-27.github.io/DSCI522-group-15/)

## Dataset and Data Reproducibility

The project uses the [Global Food Delivery Restaurant Market 2026 dataset](https://www.kaggle.com/datasets/luthfimuthathohirin/global-food-delivery-restaurant-market-2026/data).

The report creates the required data directories and downloads the public Kaggle dataset ZIP if `data/raw/global_food_delivery_enriched_market_2026.csv` is missing.

**Manual download fallback:** If the automatic Kaggle download fails:

1.  Download the dataset from the [Kaggle source page](https://www.kaggle.com/datasets/luthfimuthathohirin/global-food-delivery-restaurant-market-2026/data).

2.  Extract the archive if necessary.

3.  Create `data/raw/` under the repository root if it does not exist.

4.  Place `global_food_delivery_enriched_market_2026.csv` directly inside `data/raw/`.

For the original CSV supplied with this milestone, the SHA-256 checksum is:

```         
31b2c932fddef2026085c98208b124d8ce4b47dfa9020272e3ba8f80e5699f38
```

To verify that the local file is identical, run the relevant command from the repository root.

**macOS Terminal**

```         
shasum -a 256 data/raw/global_food_delivery_enriched_market_2026.csv
```

**Windows PowerShell**

```         
Get-FileHash -Algorithm SHA256 data/raw/global_food_delivery_enriched_market_2026.csv
```

If Kaggle later changes its published dataset, the automatically downloaded file may no longer match this checksum. Use the original, version-pinned dataset for exact result reproducibility.

## Expected Generated Files

After a successful render, the following files should be available:

- `analysis/restaurant-net-margin-prediction.html` – rendered report containing the analysis and results.

- `data/raw/global_food_delivery_enriched_market_2026.csv` – source dataset, if it needed to be downloaded.

- `data/processed/orders_train.csv` – training dataset containing 6,400 rows and 12 columns.

- `data/processed/orders_test.csv` – test dataset containing 1,600 rows and 12 columns.

Both processed CSV files are produced by the report. Rendering again regenerates the split using random seed `522`, assuming the same input data and compatible R/package versions.

You can verify the processed CSV row counts using R:

```         
nrow(read.csv("data/processed/orders_train.csv"))
nrow(read.csv("data/processed/orders_test.csv"))
```

**\### Contribute to the project:** If you want to modify the analysis code, add or update R packages, or contribute changes to the repository, read [CONTRIBUTING.md](https://github.com/UBC-MDS-2026-27/DSCI522-group-15/blob/main/CONTRIBUTING.md) before making edits.

The contributing guide explains how to connect to the development environment using Positron over SSH, work with the container, update project dependencies, and contribute changes through pull requests.

## Troubleshooting

MILESTONE 1

- **`quarto` is not recognized:** Install the Quarto CLI, restart the terminal, and confirm `quarto --version` works; alternatively, use RStudio's **Render** button.
- **A package is missing:** Make sure the R session is opened from the repository root and rerun `renv::restore(prompt = FALSE)`. If RStudio was open when `renv` was initialized, restart the R session.
- **Data download fails:** Follow the manual data-download steps above, then render again. The report skips downloading if the expected raw CSV is already present.
- **An unexpected file path is reported:** Run the documented render command from the repository root. The `.qmd` itself uses `../data/...` paths relative to its location in `analysis/`.
- **Different results across computers:** Verify the raw CSV checksum, ensure the same `renv.lock` was restored, and confirm the R and Quarto versions.

MILESTONE 2

- **Docker is not running:** Start Docker Desktop and retry the Docker Compose command.

- **SSH connection fails:** Check that `~/.ssh/id_ed25519.pub` exists and is a public-key file. If Docker created a directory at that path, remove the incorrect directory and generate the SSH key.

- **Docker image pull fails:** Check your internet connection and confirm that the image tag in `docker-compose.yml` is available.

- **Data download fails:** Follow the manual dataset download instructions above, then render again. The report skips downloading if the expected raw CSV is already present.

- **An unexpected file path is reported:** Run the documented render command from the repository root. The `.qmd` file uses paths relative to its location in `analysis/`.

- **Different results across computers:** Verify the raw CSV checksum and ensure that the same `renv.lock` and container image are being used.

## Data source and attribution

Muthathohirin, L. *Global Food Delivery Restaurant Market 2026*. Kaggle. <https://www.kaggle.com/datasets/luthfimuthathohirin/global-food-delivery-restaurant-market-2026/data>

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.md) file for details.
