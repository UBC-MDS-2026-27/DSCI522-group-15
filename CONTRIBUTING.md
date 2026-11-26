# Contributing to Predicting Restaurant Net Margin from Food Delivery Orders

Thank you for contributing to **Predicting Restaurant Net Margin from Food Delivery Orders**. Please follow these guidelines and workflows when making changes to the project.. We welcome bug reports, suggestions, and improvements to the analysis and documentation. Please follow our [Code of Conduct](https://github.com/UBC-MDS-2026-27/DSCI522-group-15/blob/main/CODE_OF_CONDUCT.md) when participating.

## Reporting bugs and proposing changes

Open a GitHub issue describing the problem or proposed improvement before starting substantial work, and discuss it with the team.

For bug reports, include:

- The command or steps you ran.

- The expected and actual behaviour.

- Relevant error messages.

- Your operating system and any relevant environment information.

- A small reproducible example, where possible.

Do not include private information, credentials, or confidential data in issues.

[**MILESTONE 1**]{.underline}

## Setting up the project

Install R 4.6.1 and the [Quarto CLI](https://quarto.org/docs/get-started/). Clone the repository and enter its root directory in a terminal:

``` bash
git clone https://github.com/UBC-MDS-2026-27/DSCI522-group-15.git
cd DSCI522-group-15
Rscript -e 'renv::restore()'
```

Render the complete analysis from the repository root:

``` bash
quarto render analysis/restaurant-net-margin-prediction.qmd
```

The report downloads the data if the raw CSV is missing, so an initial download requires internet access. See the [README](https://github.com/UBC-MDS-2026-27/DSCI522-group-15/blob/main/README.md) for detailed setup instructions and troubleshooting.

If you add an R dependency, install it in the project environment, verify that the report renders, and run `renv::snapshot()` in the R console. Include the resulting `renv.lock` changes in your pull request and explain why the dependency is needed.

## Editing documentation

Edit the source files, including `analysis/restaurant-net-margin-prediction.qmd`, rather than manually editing generated HTML. After changing the report, render it again and include the updated HTML. Even small typo fixes made through the GitHub web interface must use a branch and a reviewed pull request.

## Pull request process

1.  Start from an up-to-date `main` and create a branch in this repository for each independent feature or fix. Do not push directly to `main`.
2.  Use a descriptive branch name, such as `fix-readme-typo` or `add-eda-figure`, and keep changes focused.
3.  Follow the [tidyverse R style guide](https://style.tidyverse.org/) and write meaningful commit messages.
4.  Render the report before opening the pull request and check the output. Run `renv::status()` to check environment consistency.
5.  Open a pull request into `main` explaining what changed, why, and how you verified it. Link the related issue, for example with `Closes #12`.
6.  Have at least one other teammate review and approve the pull request. Address feedback before merging; a human reviewer merges the approved changes.

[**MILESTONE 2**]{.underline}

### **\### Getting Started and Environment Setup\*\*\*\***

All project development and analysis should take place inside the Docker container to ensure that contributors use a consistent environment.

You do not need to install R packages or Quarto locally to run the project.

### Prerequisites

Before getting started, install:

- [Git](https://git-scm.com/downloads).

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Windows or macOS).

- [Positron](https://positron.posit.co/) for editing and working inside the container.

For initial setup, follow the instructions in the [README.md](README.md).Working in the Container with Positron over SSH

We develop inside the Docker container using **Positron** over SSH following the [Positron SSH guide](https://ubc-mds.github.io/DSCI_522_dsci-workflows_students/assignments/milestone2.html#positron-ssh):

### 1. Generate an SSH key

The project uses SSH to connect Positron to the running Docker container.

If you do not already have an SSH key, open a terminal and run:

```         
ssh-keygen -t ed25519
```

Press Enter at each prompt to accept the default file location and settings.

The Docker Compose configuration mounts the public key at `~/.ssh/id_ed25519.pub`. Make sure this file exists before starting the container.

### 2. Download the Docker image

From the repository root, download the pre-built image:

```         
docker compose pull
```

The image contains the R environment, required R packages, and Quarto.

### 3. Clone the repository

If you have not already cloned the repository:

```         
git clone https://github.com/UBC-MDS-2026-27/DSCI522-group-15.git
cd DSCI522-group-15
```

If you already have the repository, navigate to its root directory and pull the latest changes:

```         
git pull
docker compose pull
```

## Working in the Container with Positron over SSH

We use [Positron over SSH](https://ubc-mds.github.io/DSCI_522_dsci-workflows_students/assignments/milestone2.html#positron-ssh) to develop inside the `analysis-env` container.

This allows contributors to edit and execute project files using the same environment, regardless of their local operating system.

### 1. Start the container

From the repository root, run:

```         
docker compose up -d
```

This starts the `analysis-env` service in the background. The container exposes SSH on port `2222`.

### 2. Connect Positron to the container

Follow the [course Positron SSH guide](https://ubc-mds.github.io/DSCI_522_dsci-workflows_students/assignments/milestone2.html#positron-ssh) to configure the SSH connection.

The connection uses the following settings from the project's Docker Compose configuration:

- **Host:** `localhost`

- **Port:** `2222`

- **Username:** `root`

- **Identity file:** your SSH private key (`~/.ssh/id_ed25519`)

- **Project directory:** `/workspace`

Open the project folder at `/workspace` after connecting.

### 3. Select the R interpreter

Inside the remote Positron session:

1.  Open the project folder at `/workspace`.

2.  Select the R interpreter available inside the container.

3.  Confirm that the project `.Rprofile` activates the `renv` environment.

4.  Check that the required packages are available before running the analysis.

### 4. Verify your Git identity

Before committing changes, verify that your Git name and email are configured:

```         
git config --list
```

The project's Docker Compose configuration mounts your local `.gitconfig` into the container. If your Git identity is missing, configure it on your host computer:

```         
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
```

Reconnect or check the Git configuration inside the container:

```         
git config --list
```

Use the email address associated with your GitHub account where appropriate.

## Developing and Updating the Project

### Working on changes

1.  Start from an up-to-date `main` branch.

2.  Create a separate branch for your change.

3.  Make your changes inside the container using Positron.

4.  Test the changes before committing.

5.  Push your branch and open a pull request.

For example:

```         
git checkout main
git pull
git checkout -b update-analysis
```

Use descriptive branch names such as:

- `fix-data-cleaning`

- `update-model-evaluation`

- `add-visualization`

- `update-documentation`

Do not push directly to `main`.

### Updating R packages

If you need to add or update an R package:

1.  Work inside the container on a separate branch.

2.  Add or update the dependency using `renv`.

3.  Update the project's `DESCRIPTION` file with the package dependency and its pinned version.

4.  Run `renv::snapshot()` to update `renv.lock`.

5.  Test that the analysis renders successfully.

6.  Commit the dependency changes and push your branch.

For example, to install a package:

```         
renv::install("package_name")
```

Then update the lockfile:

```         
renv::snapshot()
```

Include all relevant dependency changes in your pull request, including `DESCRIPTION` and `renv.lock`.

### Updating the Docker image

The project uses GitHub Actions to build and publish the Docker image to Docker Hub.

When changes are made to the environment-related files, the workflow builds and publishes an updated image for both `linux/amd64` and `linux/arm64`.

The workflow also updates the image tag in `docker-compose.yml` to identify the image built from the relevant commit.

When the image has been updated on your branch:

```         
git pull
docker compose pull
```

After the branch is merged into `main`, contributors should pull the latest repository changes and image:

```         
git checkout main
git pull
docker compose pull
```

This ensures everyone is using the latest project environment.

## Rendering and Updating the Report

The main analysis source file is:

`analysis/restaurant-net-margin-prediction.qmd`

Make changes to the `.qmd` source file rather than manually editing the generated HTML.

To render the report inside the container, run:

```         
docker compose run --rm analysis-env quarto render analysis/restaurant-net-margin-prediction.qmd
```

The generated HTML report is saved at:

`analysis/restaurant-net-margin-prediction.html`

After changing the report:

1.  Render the `.qmd` file.

2.  Check the generated HTML and confirm that the analysis and visualizations are correct.

3.  Update `docs/index.html` with the latest rendered report so that GitHub Pages displays the current version.

4.  Include the updated report files in your pull request when required.

The published report is available at:

[View the project report](https://ubc-mds-2026-27.github.io/DSCI522-group-15/)

## Pull Request Process

1.  Start from an up-to-date `main` branch.

2.  Create a descriptive branch for each independent feature or fix.

3.  Keep changes focused and follow the [tidyverse R style guide](https://style.tidyverse.org/).

4.  Use meaningful commit messages that describe the changes.

5.  Render the report and verify the output before opening a pull request.

6.  Check environment consistency and verify that the required files are included.

7.  Open a pull request targeting `main`, explaining what changed, why it was necessary, and how the changes were tested.

8.  Link the related issue where applicable, for example, `Closes #12`.

9.  Request at least one teammate to review the pull request.

10. Address review feedback before merging.

A human reviewer must approve and merge the pull request. Do not push directly to `main`.

## Stopping the Container

When you finish an interactive development session, stop the container using:

```         
docker compose down
```

If you only render the report using `docker compose run --rm`, Docker automatically removes the temporary container after the command finishes.

## AI Use Policy

Contributors may use generative AI tools to help draft, debug, explain, or review code and documentation.

If AI tools are used, disclose the tools and how they assisted in the pull request description, including representative prompts where relevant.

Contributors are responsible for understanding and verifying all submitted work, including code execution, analysis, references, and licensing.

Humans must create GitHub issues and pull requests. AI may assist with code checks, but human reviewers must make the final review, approval, and merge decisions. All contributors must follow the course's AI-use expectations.

## Attribution

Adapted from the [DSCI 522 Breast Cancer Predictor project template](https://github.com/UBC-MDS/DSCI_522_project-template-breast-cancer-predictor) and the [dplyr contributing guidelines](https://github.com/tidyverse/dplyr/blob/master/.github/CONTRIBUTING.md).
