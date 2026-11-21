# Contributing to Predicting Restaurant Net Margin from Food Delivery Orders

We welcome bug reports, suggestions, and improvements to the analysis and documentation. Please follow our [Code of Conduct](CODE_OF_CONDUCT.md) when participating.

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

The report downloads the data if the raw CSV is missing, so an initial download requires internet access. See the [README](README.md) for detailed setup instructions and troubleshooting.

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

## AI use policy

Contributors may use generative AI to help draft, debug, explain, or check code and documentation. Disclose the tools used and how they assisted in the pull request description, including representative prompts where relevant. Maintain the project's AI-use statement in the README.

Contributors are responsible for understanding and verifying all submitted work, including code execution, analysis, references, and licensing. Do not share credentials, private data, or confidential reports with AI tools.

Humans must open GitHub issues and pull requests. AI may assist with code checks, but human reviewers must make the final review, approval, and merge decisions. Contributors must follow the course's AI-use expectations.

## Attribution

Adapted from the [DSCI 522 Breast Cancer Predictor project template](https://github.com/UBC-MDS/DSCI_522_project-template-breast-cancer-predictor) and the [dplyr contributing guidelines](https://github.com/tidyverse/dplyr/blob/master/.github/CONTRIBUTING.md).
