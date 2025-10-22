# Git LFS Setup Guide

## What is Git LFS?

Git Large File Storage (LFS) is an extension that helps Git handle large files efficiently by storing them outside the main repository while keeping references in Git.

## Why Use It?

Your project has large images (like `cover_page_v2.png` which is >5MB). Without LFS:
- Git repository becomes bloated
- Cloning becomes slow
- Every file version is stored in full

With LFS:
- Only references stored in Git
- Large files stored separately
- Faster cloning and operations

## Already Configured

This repository now has a `.gitattributes` file that tells Git to use LFS for:
- Images: `*.png`, `*.jpg`, `*.jpeg`
- PDFs: `*.pdf`
- Videos: `*.mp4`, `*.mov`
- Archives: `*.zip`, `*.tar.gz`

## Installation (One-time per developer)

### On Your Local Machine

1. **Install Git LFS**:
   ```bash
   # macOS (with Homebrew)
   brew install git-lfs

   # Ubuntu/Debian
   sudo apt-get install git-lfs

   # Windows (with Chocolatey)
   choco install git-lfs

   # Or download from: https://git-lfs.github.com/
   ```

2. **Initialize Git LFS** (run once per user):
   ```bash
   git lfs install
   ```

3. **Migrate existing large files** (optional, for existing large files):
   ```bash
   # See what would be migrated
   git lfs migrate info --include="*.png,*.jpg,*.pdf"

   # Actually migrate (creates new commits, so coordinate with team)
   git lfs migrate import --include="*.png,*.jpg,*.pdf"
   ```

## Usage

Once configured, Git LFS works automatically:

```bash
# Add large files normally
git add images/new_large_image.png
git commit -m "Add new cover image"
git push

# Git LFS handles it automatically!
```

## Checking What's in LFS

```bash
# See LFS-tracked files
git lfs ls-files

# See LFS status
git lfs status

# See what patterns are tracked
git lfs track
```

## For This Project

The `.gitattributes` file is already set up. New contributors just need to:

1. Install Git LFS (see above)
2. Clone the repository normally
   ```bash
   git clone <repo-url>
   cd Data-Analysis-in-Natural-Sciences
   ```
3. Large files will be automatically handled!

## Troubleshooting

### "This repository is over its data quota"

GitHub Free has LFS bandwidth limits. Solutions:
- Use GitHub Pro (more bandwidth)
- Host large files elsewhere (S3, CDN)
- Reduce file sizes

### Files not being tracked

```bash
# Verify .gitattributes exists
cat .gitattributes

# Manually track a pattern
git lfs track "*.png"

# Refresh LFS
git lfs pull
```

### Want to stop using LFS for a file type

Edit `.gitattributes` and remove or comment out the line.

## Benefits for This Project

✅ **Book cover images** handled efficiently
✅ **Rendered PDFs** don't bloat repository
✅ **Future videos/tutorials** ready for LFS
✅ **Faster cloning** for new contributors
✅ **Better performance** overall

## Resources

- Official docs: https://git-lfs.github.com/
- Tutorial: https://www.atlassian.com/git/tutorials/git-lfs
- GitHub docs: https://docs.github.com/en/repositories/working-with-files/managing-large-files
