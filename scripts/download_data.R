# Run from the repository root: Rscript scripts/download_data.R
# For a fixed version, append ?datasetVersionNumber=N to the URL.
url <- "https://www.kaggle.com/api/v1/datasets/download/luthfimuthathohirin/global-food-delivery-restaurant-market-2026"

dir.create("data/raw", recursive = TRUE, showWarnings = FALSE)
zip_file <- tempfile(fileext = ".zip")
download.file(url, zip_file, mode = "wb")
unzip(zip_file, exdir = "data/raw")
