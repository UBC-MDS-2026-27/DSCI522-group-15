# Contributing to Predicting Restaurant Net Margin from Food Delivery Orders

Thank you for contributing to **Predicting Restaurant Net Margin from Food Delivery Orders**. Please follow these guidelines and workflows when making changes to the project.. We welcome bug reports, suggestions, and improvements to the analysis and documentation. Please follow our [Code of Conduct](https://github.com/UBC-MDS-2026-27/DSCI522-group-15/blob/main/CODE_OF_CONDUCT.md) when participating.

## Reporting bugs and proposing changes

Open a GitHub issue describing the problem or proposed improvement before starting substantial work, and discuss it with the team. For bugs, include the command you ran, the expected and actual behavior, relevant error messages, and your R and operating-system versions. Provide a small reproducible example where possible, without sharing private information.

## Setting up the project

Install R 4.6.1 and the [Quarto CLI](https://quarto.org/docs/get-started/). Clone the repository and enter its root directory in a terminal:

```bash
git clone https://github.com/UBC-MDS-2026-27/DSCI522-group-15.git
cd DSCI522-group-15
Rscript -e 'renv::restore()'
```

Render the complete analysis from the repository root:

```bash
quarto render analysis/restaurant-net-margin-prediction.qmd
```

The report downloads the data if the raw CSV is missing, so an initial download requires internet access. See the [README](https://github.com/UBC-MDS-2026-27/DSCI522-group-15/blob/main/README.md) for detailed setup instructions and troubleshooting.

If you add an R dependency, install it in the project environment, verify that the report renders, and run `renv::snapshot()` in the R console. Include the resulting `renv.lock` changes in your pull request and explain why the dependency is needed.

## Editing documentation

Edit the source files, including `analysis/restaurant-net-margin-prediction.qmd`, rather than manually editing generated HTML. After changing the report, render it again and include the updated HTML. Even small typo fixes made through the GitHub web interface must use a branch and a reviewed pull request.

## Pull request process

1. Start from an up-to-date `main` and create a branch in this repository for each independent feature or fix. Do not push directly to `main`.
2. Use a descriptive branch name, such as `fix-readme-typo` or `add-eda-figure`, and keep changes focused.
3. Follow the [tidyverse R style guide](https://style.tidyverse.org/) and write meaningful commit messages.
4. Render the report before opening the pull request and check the output. Run `renv::status()` to check environment consistency.
5. Open a pull request into `main` explaining what changed, why, and how you verified it. Link the related issue, for example with `Closes #12`.
6. Have at least one other teammate review and approve the pull request. Address feedback before merging; a human reviewer merges the approved changes.

MILESTONE 2

## Initial Setup

Before developing inside the container, complete the initial setup steps in [README.md](https://github.com/UBC-MDS-2026-27/DSCI522-group-15/blob/main/README.md) (generating your SSH key with `ssh-keygen -t ed25519` and pulling the container image with `docker compose pull`). Do not install R packages globally on your host computer to work on this project; all development happens inside the `analysis-env` container defined in [docker-compose.yml](https://github.com/UBC-MDS-2026-27/DSCI522-group-15/blob/main/docker-compose.yml).

## Working in the Container with Positron over SSH

We work inside the Docker container using **Positron** over SSH by following the [Positron SSH guide](https://ubc-mds.github.io/DSCI_522_dsci-workflows_students/assignments/milestone2.html#positron-ssh) in [Milestone 2](https://ubc-mds.github.io/DSCI_522_dsci-workflows_students/assignments/milestone2.html):

1. **Install Positron:** Install Positron on your computer if it is not already installed.
2. **Connect to the container over SSH:** Follow the [Positron SSH guide](https://ubc-mds.github.io/DSCI_522_dsci-workflows_students/assignments/milestone2.html#positron-ssh) to connect Positron over SSH to the `analysis-env` container and open the repository folder inside the container session.
3. **Select the interpreter:** Inside Positron, select the project's R interpreter so it uses the `renv` environment configured in the container.
4. **Check your Git name and email:** Before committing changes from the container, check your Git configuration:
   ```bash
   git config --list\

## Adding or Updating Packages and Making Changes
Use the GitHub flow (a small branch for each feature or fix, reviewed in a pull request by at least one teammate before merging into main):

1. Create a new branch from main with a clear name (for example, git switch -c add-package).

2. If adding or updating R packages: Add or update the package using renv inside the container, record the pinned version (== x.y.z) in DESCRIPTION (keeping knitr and rmarkdown listed), and keep renv.lock, .Rprofile, and renv/ in sync.
   Stage and commit your code changes together with DESCRIPTION and renv.lock, then push the branch to GitHub.

3. Wait for the GitHub Actions workflow in .github/workflows/publish-dockerhub.yml to build the multi-platform image (linux/amd64 and linux/arm64) and commit the new sha- image tag to docker-compose.yml on your branch. Run git pull and docker compose pull so your local branch has updated docker-compose.yml and pulled image.

4. Open a pull request, get a teammate review, and merge into main.

5. After merging into main, wait for the GitHub Actions workflow to commit the updated sha- tag to main, then switch to main and run:

Bash
git pull
docker compose pull


**##Publishing the Updated Report**

Whenever you update analysis/restaurant-net-margin-prediction.qmd, re-render the report inside the container and update the published copy on GitHub Pages so the live report at https://ubc-mds-2026-27.github.io/DSCI522-group-15/ stays current:

Ensure the YAML header of analysis/restaurant-net-margin-prediction.qmd sets embed-resources: true under format: html: so the HTML output is self-contained.

Render the report in the container:
  docker compose run --rm analysis-env quarto render analysis/restaurant-net-margin-prediction.qmd

Copy the rendered HTML file into docs/index.html and keep docs/.nojekyll in place:
    mkdir -p docs
    cp analysis/restaurant-net-margin-prediction.html docs/index.html
    touch docs/.nojekyll

Commit and push docs/ (verifying .gitignore does not ignore docs/ or .html files) so GitHub Pages serves the updated report.

## AI use policy

Contributors may use generative AI to help draft, debug, explain, or check code and documentation. Disclose the tools used and how they assisted in the pull request description, including representative prompts where relevant. Maintain the project's AI-use statement in the README.

Contributors are responsible for understanding and verifying all submitted work, including code execution, analysis, references, and licensing. Do not share credentials, private data, or confidential reports with AI tools.

Humans must open GitHub issues and pull requests. AI may assist with code checks, but human reviewers must make the final review, approval, and merge decisions. Contributors must follow the course's AI-use expectations.

## Attribution

Adapted from the [DSCI 522 Breast Cancer Predictor project template](https://github.com/UBC-MDS/DSCI_522_project-template-breast-cancer-predictor) and the [dplyr contributing guidelines](https://github.com/tidyverse/dplyr/blob/master/.github/CONTRIBUTING.md).
