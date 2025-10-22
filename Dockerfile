# Dockerfile for Data Analysis in Natural Sciences
# Provides reproducible environment for building the book

FROM rocker/r-ver:4.2.0

# Set labels
LABEL maintainer="Data Analysis Team"
LABEL description="Reproducible environment for Data Analysis in Natural Sciences book"
LABEL version="1.0"

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV QUARTO_VERSION=1.3.450

# Install system dependencies
RUN apt-get update && apt-get install -y \
    # Core utilities
    wget \
    curl \
    git \
    pandoc \
    # R package dependencies
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgdal-dev \
    libproj-dev \
    libgeos-dev \
    libudunits2-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    # Clean up
    && rm -rf /var/lib/apt/lists/*

# Install Quarto
RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb \
    && dpkg -i quarto-${QUARTO_VERSION}-linux-amd64.deb \
    && rm quarto-${QUARTO_VERSION}-linux-amd64.deb

# Verify Quarto installation
RUN quarto --version

# Set working directory
WORKDIR /book

# Copy dependency installation scripts first (for Docker cache optimization)
COPY scripts/install_packages.R /tmp/install_packages.R
COPY scripts/install_spatial_packages.R /tmp/install_spatial_packages.R

# Install R packages
RUN Rscript /tmp/install_packages.R \
    && Rscript /tmp/install_spatial_packages.R

# Install additional packages for testing and linting
RUN R -e "install.packages(c('testthat', 'lintr', 'styler', 'covr', 'future', 'furrr'), repos='https://cloud.r-project.org/')"

# Copy project files
COPY . /book/

# Create necessary directories
RUN mkdir -p logs data docs

# Run data validation (optional, comment out if datasets not available)
# RUN Rscript scripts/data_validation.R || true

# Build the book
RUN quarto render

# Verify build
RUN test -f docs/index.html || (echo "Build failed!" && exit 1)

# Expose port for serving (if using quarto preview)
EXPOSE 8080

# Default command
CMD ["quarto", "preview", "--host", "0.0.0.0", "--port", "8080", "--no-browser"]

# Build instructions:
# docker build -t data-analysis-book .
#
# Run instructions:
# docker run -p 8080:8080 data-analysis-book
#
# Or mount local directory for development:
# docker run -v $(pwd):/book -p 8080:8080 data-analysis-book
