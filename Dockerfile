# Adapted from docker-uv-renv by Daniel Chen (MIT License)
# https://github.com/chendaniely/docker-uv-renv

# Start from Ubuntu Linux with R installed.
# Change 4.6.2 to the R version in your renv.lock.
FROM rocker/r-ver:4.6.1

# Install the programs the project needs:
# curl downloads files, git/less/nano let you work in a terminal,
# make runs a Makefile, openssh-server lets Positron connect over ssh,
# libuv1-dev is needed by the R package fs
RUN apt-get update && apt-get install --yes \
    curl \
    git \
    less \
    libuv1-dev \
    make \
    nano \
    openssh-server

# Install Quarto (it comes with Typst for PDFs, so no LaTeX).
# dpkg --print-architecture gives amd64 or arm64, to match the computer.
RUN curl --location --output quarto.deb \
    https://github.com/quarto-dev/quarto-cli/releases/download/v1.11.9/quarto-1.11.9-linux-$(dpkg --print-architecture).deb \
  && apt-get install --yes ./quarto.deb \
  && rm quarto.deb

# Your project folder is mounted at /workspace,
# so the packages go in /opt instead
WORKDIR /workspace

# R packages (renv) go in /opt/renv/library
RUN echo "RENV_PATHS_LIBRARY=/opt/renv/library" >> /usr/local/lib/R/etc/Renviron.site
COPY renv.lock .Rprofile ./
COPY renv/activate.R renv/
RUN apt-get update && apt-get install -y --no-install-recommends \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libwebp-dev \
    && rm -rf /var/lib/apt/lists/*
RUN Rscript -e "renv::restore()"

# On a Linux laptop, remove the # from the next line.
# (sshd wants root to own the key file, but on Linux the mounted one is yours.)
# RUN echo "StrictModes no" > /etc/ssh/sshd_config.d/container.conf

# Start the ssh server when the container starts.
# -D keeps it in the foreground, so the container keeps running.
CMD ["/usr/sbin/sshd", "-D"]