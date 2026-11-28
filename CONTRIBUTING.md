# Contributing to Predicting Restaurant Net Margin from Food Delivery Orders

Thank you for contributing to **Predicting Restaurant Net Margin from Food Delivery Orders**. Please follow these guidelines and workflows when making changes to the project. We welcome bug reports, suggestions, and improvements to the analysis and documentation. Please follow our [Code of Conduct](https://github.com/UBC-MDS-2026-27/DSCI522-group-15/blob/main/CODE_OF_CONDUCT.md) when participating.

## Reporting bugs and proposing changes

Open a GitHub issue describing the problem or proposed improvement before starting substantial work, and discuss it with the team.

For bug reports, include:

- The command or steps you ran.

- The expected and actual behaviour.

- Relevant error messages.

- Your operating system and any relevant environment information.

- A small reproducible example, where possible.

Do not include private information, credentials, or confidential data in issues.

## Initial setup

All development takes place inside the Docker container. Complete the [README setup and image download](README.md#run-the-analysis) first, including the SSH key and Git configuration checks. Do not install project packages globally on your computer.

Install [Positron](https://positron.posit.co/download.html). Its Remote SSH feature is built in. The instructions below adapt the [course SSH guide](https://ubc-mds.github.io/DSCI_522_dsci-workflows_students/assignments/milestone2.html#positron-ssh) to this project.

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

Check that `docker compose ps` lists `analysis-env` as running. In Positron, open the Command Palette with `Cmd+Shift+P` on macOS or `Ctrl+Shift+P` on Windows. Run **Remote SSH: Show Remote Menu**, choose **Connect to Host**, and enter `root@localhost:2222`.

Choose **Linux** if asked for the remote platform. Accept the host fingerprint for this local container. The first connection may take several minutes while Positron installs its server.

In the remote window, select **Open Folder** and enter `/workspace`. The initial terminal may open in `/root`; the project files are in `/workspace`. Edits there are also saved to the mounted repository on your computer.

### 3. Select the R interpreter

Click the interpreter button at the top right, choose **New Console Session…**, and select the container's R 4.6.1 interpreter. Open the project at `/workspace` so `.Rprofile` activates `renv`. In the R console, check `R.version.string` and `.libPaths()`; the project's library is `/opt/renv/library`.

The Terminal, Console, and Render button in this remote window execute inside the container.

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

### Connection troubleshooting

If `docker compose ps` does not show a running service, inspect `docker compose logs analysis-env`. Ensure Docker Desktop is running before restarting the container.

If `~/.ssh/id_ed25519.pub` or `~/.gitconfig` is a directory, follow the [README troubleshooting instructions](README.md#troubleshooting). If SSH asks for a password, check that your public key is named `id_ed25519.pub` and that the private key `~/.ssh/id_ed25519` is available to your SSH client. If you use another key, update the public-key mount and SSH identity configuration to match.

After rebuilding your local container, an expected host-key change can be cleared with `ssh-keygen -R "[localhost]:2222"` before reconnecting. If port 2222 is already occupied, stop the conflicting container or use another host port in Compose and connect to that port.

On Linux laptops, the mounted public key can have an owner other than root. Follow the course guide's Linux-specific `StrictModes no` Dockerfile adjustment and rebuild the image if SSH rejects the key for this reason. If GitHub asks for authentication when pushing, sign in through the browser window opened by Positron.

## Developing and Updating the Project

### Working on changes

Follow the [pull request process](#pull-request-process) below for all changes. Make and test your changes inside the container using Positron.

For example, create a branch from an up-to-date `main`:

```bash
git checkout main
git pull
git checkout -b update-analysis
```

### Updating R packages

If you need to add or update an R package:

1.  Work inside the container on a separate branch.

2.  Add or update the dependency using `renv`.

3.  Add the direct dependency to `DESCRIPTION` with an exact constraint, such as `package_name (== x.y.z)`. Keep `knitr` and `rmarkdown` listed for Quarto rendering, and keep every declared version consistent with `renv.lock`.

4.  Run `renv::snapshot()` to update `renv.lock`.

5.  Test that the analysis renders successfully.

6.  Commit the dependency changes and push your branch.

For example, to install a package:

```
renv::install("package_name@x.y.z")
```

Then update the lockfile:

```
renv::snapshot()
```

Include `DESCRIPTION` and `renv.lock` together, plus any changes to `.Rprofile` or `renv/`. The lockfile also records transitive dependencies. Run `renv::status()` and resolve inconsistencies before pushing. Replace the example package name and version above with a real package and version.

### Updating the Docker image

The project uses GitHub Actions to build and publish the Docker image to Docker Hub.

Changes to `renv.lock`, the Dockerfile, or the other paths listed in the workflow trigger builds for `linux/amd64` and `linux/arm64`. A `DESCRIPTION`-only change does not currently trigger a build; use **Actions → Publish image to Docker Hub → Run workflow** on your branch when a manual build is needed.

The workflow also updates the image tag in `docker-compose.yml` to identify the image built from the relevant commit.

When the image has been updated on your branch:

```
git pull
docker compose pull
```

Wait for the branch build and automatic Compose-tag commit, then pull the branch and image before merging through a reviewed pull request. After merging environment changes into `main`, wait for its build and automatic tag commit before contributors run:

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

Keep `format: html: embed-resources: true` in the report's YAML header so the HTML includes its figures and styling. Inspect the rendered report, then copy it to the Pages directory from the repository root in the container terminal:

```bash
mkdir -p docs
cp analysis/restaurant-net-margin-prediction.html docs/index.html
touch docs/.nojekyll
```

Commit and push the source changes and updated report files, including `docs/`, through a reviewed pull request. Do not ignore `docs/` or HTML files in `.gitignore`. Repeat the copy every time the report is re-rendered. GitHub Pages serves `main`'s `/docs` folder; after merging, check that the live report and figures match the submitted version.

The published report is available at:

[View the project report](https://ubc-mds-2026-27.github.io/DSCI522-group-15/)

## Pull Request Process

1.  Start from an up-to-date `main` branch.

2.  Create a descriptive branch for each independent feature or fix.

3.  Keep changes focused and follow the [tidyverse R style guide](https://style.tidyverse.org/).

4.  Use meaningful commit messages that describe the changes.

5.  Render the report and verify the output before opening a pull request.

6.  Run `renv::status()` to check environment consistency and verify that the required files are included.

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
