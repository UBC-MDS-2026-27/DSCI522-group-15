# Predicting Restaurant Net Margin from Food Delivery Orders

**DSCI 522 - Group 15 | Milestone 2**

## Authors

Jerry Jin, Afrah Zilani, and Jerry Zeng developed this project.

## Published report

[Read the complete analysis on GitHub Pages](https://ubc-mds-2026-27.github.io/DSCI522-group-15/).

## Project overview

The project investigates whether an order's estimated restaurant net margin (in USD) can be predicted from information available when a food delivery order is placed. We use the [Global Food Delivery Restaurant Market 2026 dataset](https://www.kaggle.com/datasets/luthfimuthathohirin/global-food-delivery-restaurant-market-2026/data) by Luthfi Muthathohirin.

The supplied dataset has 8,000 orders and 26 columns. The analysis selects 11 order-time predictors and the target, creates a reproducible 80% training / 20% test split (6,400 / 1,600 orders; with random seed `522`), performs exploratory analysis, and compares a mean-prediction baseline, ordinary least-squares linear regression, and ridge regression. Model selection uses five-fold cross-validation on the training set; the held-out test set is used for final evaluation. The target is a *dataset-estimated* margin, not a verified accounting measure of realized restaurant profit.

## Requirements

Install [Git](https://git-scm.com/downloads) and [Docker Desktop](https://www.docker.com/products/docker-desktop/) on Windows or macOS. Start Docker Desktop before running the commands below. Use Terminal on macOS or PowerShell on Windows. Internet access is required to download the image and, if the raw CSV is absent, the dataset.

The container supplies R 4.6.1, Quarto, and the R packages recorded in `renv.lock`. You do not need to install R, Quarto, or the project's R packages on your computer.

## Get the project

Clone the repository and enter its root directory:

```bash
git clone https://github.com/UBC-MDS-2026-27/DSCI522-group-15.git
cd DSCI522-group-15
```

If you already have a checkout, open its root directory and run `git pull` to get the latest changes. Run all subsequent terminal commands from that directory, which contains `docker-compose.yml`.

## Run the analysis

### 1. Prepare the mounted files

If `~/.ssh/id_ed25519.pub` does not exist, generate an SSH key:

```bash
ssh-keygen -t ed25519
```

Press Enter at each prompt to accept the default location and settings. Keep an existing key if you already have one. Docker mounts the public key into the container; if it is missing, Docker may create a directory at that path instead, preventing SSH connections.

The container also mounts `~/.gitconfig`. Before starting it, check your Git identity:

```bash
git config --global user.name
git config --global user.email
```

If either value is missing, set it on your computer, replacing these examples with your own name and GitHub email:

```bash
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
```

### 2. Download the Docker image

Download the image pinned to a commit-SHA tag in `docker-compose.yml`:

```bash
docker compose pull
```

Wait for the download to finish before rendering. Docker selects the appropriate image for Intel/AMD or ARM computers.

### 3. Render the report

Run the complete analysis inside the container:

```bash
docker compose run --rm analysis-env quarto render analysis/restaurant-net-margin-prediction.qmd
```

The explicit report path is required because the repository has no root `_quarto.yml` listing it. Rendering executes the analysis, creates the processed data, and writes `analysis/restaurant-net-margin-prediction.html`.

### 4. Container cleanup

The `--rm` option removes the temporary container when rendering finishes. Generated files remain on your computer because the repository is mounted at `/workspace` inside the container.

If you started a background container with `docker compose up -d`, stop and remove it when finished:

```bash
docker compose down
```

### 5. Inspect the output

Open `analysis/restaurant-net-margin-prediction.html` in your browser and check that the report includes its figures, model comparison, and final test evaluation. The analysis also produces `data/processed/orders_train.csv` with 6,400 rows and 12 columns and `data/processed/orders_test.csv` with 1,600 rows and 12 columns.

The report generates these CSVs from the raw dataset using random seed `522`. Do not substitute them for the raw input. Re-rendering regenerates the split, assuming the same input and environment.

## Dataset and reproducibility

The project uses the [Global Food Delivery Restaurant Market 2026 dataset](https://www.kaggle.com/datasets/luthfimuthathohirin/global-food-delivery-restaurant-market-2026/data). If `data/raw/global_food_delivery_enriched_market_2026.csv` is missing, the report creates the required directories and downloads the public Kaggle ZIP.

If the download fails, download and extract the dataset from the linked Kaggle page. Create `data/raw/` under the repository root if necessary, then place `global_food_delivery_enriched_market_2026.csv` directly inside it. Re-run the container render command.

The original CSV has SHA-256 checksum `31b2c932fddef2026085c98208b124d8ce4b47dfa9020272e3ba8f80e5699f38`. On macOS, verify it with:

```bash
shasum -a 256 data/raw/global_food_delivery_enriched_market_2026.csv
```

On Windows, use PowerShell:

```powershell
Get-FileHash -Algorithm SHA256 data/raw/global_food_delivery_enriched_market_2026.csv
```

If Kaggle changes the dataset, a new download may not match. Use the original CSV committed in this repository for exact reproducibility.

## Repository structure

The analysis source is `analysis/restaurant-net-margin-prediction.qmd`. Raw and processed CSVs live in `data/raw/` and `data/processed/`. The published report is `docs/index.html`, with `docs/.nojekyll` ensuring it is served without Jekyll processing.

`Dockerfile` defines the container, and `docker-compose.yml` selects its image and mounts. `DESCRIPTION` declares exact versions of the project's direct R dependencies and rendering tools; `renv.lock` also pins their transitive dependencies. `.Rprofile` and `renv/` activate the R environment. `.github/workflows/publish-dockerhub.yml` builds and publishes the container image.

## Troubleshooting

If Docker is unavailable, start Docker Desktop and retry. If the image cannot be downloaded, check your internet connection and that the image tag in `docker-compose.yml` exists on Docker Hub.

If Docker has created a directory named `~/.ssh/id_ed25519.pub` or `~/.gitconfig`, stop the container with `docker compose down`. Remove only that incorrectly created directory, then create the missing key or Git configuration using the setup instructions above before retrying.

If rendering reports an unexpected file path, confirm that you ran the command from the repository root. The `.qmd` file resolves its data paths relative to `analysis/`. If results differ between computers, compare the dataset checksum and container image tag.

## Contributing

To change the analysis, dependencies, or published report, follow [CONTRIBUTING.md](CONTRIBUTING.md). It describes development in Positron over SSH, package updates, review, and report publication.

## AI use statement

ChatGPT assisted with debugging, documentation structure and wording, and preparation of the dependency declaration. Contributors are responsible for checking the resulting work and disclosing additional AI assistance in pull requests.

## Data source and attribution

Muthathohirin, L. *Global Food Delivery Restaurant Market 2026*. [Kaggle dataset](https://www.kaggle.com/datasets/luthfimuthathohirin/global-food-delivery-restaurant-market-2026/data).

## License

This project is licensed under the MIT License. See [LICENSE.md](LICENSE.md).
