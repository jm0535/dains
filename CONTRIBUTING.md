# Contributing to Data Analysis in Natural Sciences

Thank you for your interest in contributing to this book! This document provides guidelines and instructions for contributing.

## How to Contribute

There are several ways you can contribute to this book:

1. **Content improvements**: Sharpen explanations, add clarifying examples, or fix awkward phrasing in existing chapters.
2. **Error corrections**: Fix errors in code, prose, statistics, or data. Statistical corrections (assumption violations, wrong test choice, misread output) are especially welcome.
3. **New examples or case studies**: Contribute domain examples that strengthen a chapter.
4. **Dataset additions**: If you have a dataset whose contents actually match one of the directory names listed in [`data/MISMATCHES.md`](data/MISMATCHES.md), open an issue and let's discuss swapping it in.
5. **Translations**: Help translate content to other languages.

What we ask you **not** to send:

- Solutions to chapter exercises on `main`. The instructor answer keys live on a separate `instructor-solutions` branch. Open an issue if you teach from the book and need access.
- AI-generated prose without a careful editing pass. The book has an active anti-AI-writing policy: no em-dashes, no rule-of-three filler, no "this serves as a testament to..." phrasing. See the humanizer notes if you want a quick checklist.

## Contribution Process

### For Small Changes

1. Fork the repository
2. Make your changes
3. Submit a pull request with a clear description of the changes
4. Ensure your PR title clearly describes the changes

### For Larger Contributions

1. Open an issue first to discuss the proposed changes
2. Fork the repository
3. Create a new branch for your feature
4. Make your changes
5. Submit a pull request referencing the original issue

## Validating Your Changes

GitHub Actions is currently unable to run on this repository (account billing lock), so CI will not check your PR. Until that is resolved, validate locally before pushing:

```bash
scripts/validate_local.sh
```

The script mirrors the CI checks: the book contracts audit, YAML validation, large-file and secrets scans, and the chapter R code parse test (when R is installed). Add `--render` to also run a full `quarto render` with the same render-time regression gate CI uses. Checks whose tools are missing on your machine are reported as SKIP rather than failing.

## Style Guidelines

### Code Style

- Follow the [tidyverse style guide](https://style.tidyverse.org/) for R code
- Include comments to explain complex operations
- Ensure all code examples are reproducible

### Writing Style

- Use clear, concise language. Short sentences are fine.
- Explain technical concepts in accessible terms; assume a smart reader who is new to the specific topic, not new to thinking.
- Include practical examples to illustrate concepts.
- Use active voice where possible.
- Avoid em-dashes (the long dash). Use commas, semicolons, parentheses, or two short sentences instead.
- Avoid AI-stamped patterns: "delve", "crucial", "pivotal", "testament", "tapestry", "in the evolving landscape of...", and rule-of-three filler ("X, Y, and Z" when only X is needed).
- Lead with the point. If a paragraph could be cut in half without losing meaning, cut it.

### Statistical content

- Always check assumptions before reporting a parametric test result. If assumptions fail, switch tests rather than ignoring the violation.
- Report effect sizes and confidence intervals, not just p-values.
- Be honest about what the data can and cannot tell you.

### Markdown Formatting

- Use proper heading hierarchy (# for main headings, ## for subheadings, etc.)
- Use backticks for inline code and code blocks for longer snippets
- Include alt text for images
- Use numbered lists for sequential steps and bullet points for non-sequential items

## Commit Messages

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally after the first line

## Review Process

All submissions will be reviewed by the maintainers. We may suggest changes, improvements, or alternatives.

## Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

## Questions?

If you have questions about the contribution process, feel free to open an issue with your question.

Thank you for your contributions to making this book better for everyone!
