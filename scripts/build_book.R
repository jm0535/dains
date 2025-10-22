# Build Script for Data Analysis Book
# This script is called by RStudio when building the project

# Check if Quarto is available
if (Sys.which("quarto") == "") {
  stop("Quarto is not installed or not in PATH. Please install from https://quarto.org")
}

# Build the book
message("Building book with Quarto...")
system("quarto render")

# Check if build was successful
if (dir.exists("docs") && file.exists("docs/index.html")) {
  message("✅ Book built successfully!")
  message("Output directory: docs/")
  message("Open docs/index.html in a browser to view")
} else {
  stop("❌ Build failed. Check error messages above.")
}
