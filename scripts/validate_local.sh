#!/usr/bin/env bash
#
# Local validation for the dains book.
#
# Mirrors the GitHub Actions checks in .github/workflows/pr-checks.yml and
# .github/workflows/publish.yml so they can be run without CI. Useful while
# Actions is unavailable (account billing lock) and as a pre-push habit.
#
# Usage:
#   scripts/validate_local.sh             run every check whose tools are installed
#   scripts/validate_local.sh --render    also run a full `quarto render` (slow)
#
# Tools are detected at runtime. Anything missing is reported as SKIP with a
# hint; skips do not fail the run. Any executed check that fails does.

set -u

# Re-exec under bash if started with sh (process substitution is used below).
if [ -z "${BASH_VERSION:-}" ]; then
  exec bash "$0" "$@"
fi

cd "$(dirname "$0")/.."

DO_RENDER=0
case "${1:-}" in
  --render) DO_RENDER=1 ;;
  --help|-h)
    sed -n '2,16p' "$0" | sed 's/^# \{0,1\}//'
    exit 0
    ;;
  "") ;;
  *) echo "Unknown option: $1 (try --help)"; exit 2 ;;
esac

PASS=0; WARN=0; FAIL=0; SKIP=0
TMPDIR_LOCAL=$(mktemp -d)
trap 'rm -rf "$TMPDIR_LOCAL"' EXIT

green()  { printf '\033[32m%s\033[0m\n' "$*"; }
red()    { printf '\033[31m%s\033[0m\n' "$*"; }
yellow() { printf '\033[33m%s\033[0m\n' "$*"; }

report() { # report <pass|warn|fail|skip> <label> [detail]
  local status="$1" label="$2" detail="${3:-}"
  case "$status" in
    pass) PASS=$((PASS + 1)); green  "  PASS  $label${detail:+: $detail}" ;;
    warn) WARN=$((WARN + 1)); yellow "  WARN  $label${detail:+: $detail}" ;;
    fail) FAIL=$((FAIL + 1)); red    "  FAIL  $label${detail:+: $detail}" ;;
    skip) SKIP=$((SKIP + 1)); yellow "  SKIP  $label${detail:+: $detail}" ;;
  esac
}

echo "dains local validation (mirrors .github/workflows checks)"
echo "----------------------------------------------------------------"

# --- 1. Book contracts audit (publish.yml: "Audit book contracts") ----------
if command -v python3 >/dev/null 2>&1; then
  if python3 scripts/book_audit.py >"$TMPDIR_LOCAL/audit.log" 2>&1; then
    report pass "Book contracts audit" "$(tail -n 1 "$TMPDIR_LOCAL/audit.log")"
  else
    report fail "Book contracts audit" "$(tail -n 1 "$TMPDIR_LOCAL/audit.log")"
    sed -n '1,20p' "$TMPDIR_LOCAL/audit.log"
  fi
else
  report skip "Book contracts audit" "python3 not found"
fi

# --- 2. YAML validation (pr-checks.yml: "Validate YAML files") -------------
if command -v python3 >/dev/null 2>&1 && python3 -c "import yaml" >/dev/null 2>&1; then
  yaml_bad=0
  yaml_total=0
  while IFS= read -r f; do
    yaml_total=$((yaml_total + 1))
    if ! python3 -c "import sys, yaml; yaml.safe_load(open(sys.argv[1]))" "$f" >/dev/null 2>&1; then
      echo "    invalid YAML: $f"
      yaml_bad=1
    fi
  done < <(find . \( -name '*.yml' -o -name '*.yaml' \) \
              -not -path './.git/*' -not -path './renv/*' -type f | sort)
  if [ "$yaml_bad" -eq 0 ]; then
    report pass "YAML validation" "$yaml_total files parsed"
  else
    report fail "YAML validation" "files listed above failed to parse"
  fi
else
  report skip "YAML validation" "python3 pyyaml module missing (pip install pyyaml)"
fi

# --- 3. Large files (pr-checks.yml: warning only, does not block) -----------
large_files=$(find . -type f -size +5M \
  -not -path './.git/*' \
  -not -path './renv/*' \
  -not -path './images/*' \
  -not -path './image/*' \
  -not -path './docs/*' \
  -not -path './_site/*' 2>/dev/null)
if [ -n "$large_files" ]; then
  echo "    large files:"
  echo "$large_files" | sed 's/^/      /'
  report warn "Large files check" "files over 5MB outside excluded dirs (non-blocking, same as CI)"
else
  report pass "Large files check" "none over 5MB outside excluded dirs"
fi

# --- 4. Secrets scan (pr-checks.yml: "Check for secrets") -------------------
pattern="(api_key|password|secret|token)\s*=\s*['\"][^'\"]+['\"]"
if grep -r -E "$pattern" --include='*.R' --include='*.qmd' . >"$TMPDIR_LOCAL/secrets.log" 2>&1; then
  sed -n '1,10p' "$TMPDIR_LOCAL/secrets.log"
  report fail "Secrets scan" "possible hardcoded credentials above"
else
  report pass "Secrets scan"
fi

# --- 5. Chapter R code parse test (publish.yml: "Run chapter tests") --------
if [ -f tests/test-chapters.R ]; then
  if command -v Rscript >/dev/null 2>&1; then
    if Rscript tests/test-chapters.R >"$TMPDIR_LOCAL/rtests.log" 2>&1; then
      n=$(grep -c 'Testing chapter:' "$TMPDIR_LOCAL/rtests.log" || true)
      report pass "Chapter R code parse test" "${n:-0} chapters parsed"
    else
      report fail "Chapter R code parse test" "see output below"
      tail -n 30 "$TMPDIR_LOCAL/rtests.log"
    fi
  else
    report skip "Chapter R code parse test" "Rscript not found (needs R plus the knitr and testthat packages)"
  fi
else
  report skip "Chapter R code parse test" "tests/test-chapters.R not present"
fi

# --- 6. Optional full book render (publish.yml: "Render Quarto book") -------
if [ "$DO_RENDER" -eq 1 ]; then
  if command -v quarto >/dev/null 2>&1; then
    start=$(date +%s)
    if quarto render >"$TMPDIR_LOCAL/render.log" 2>&1; then
      elapsed=$(( $(date +%s) - start ))
      if [ "$elapsed" -gt 2400 ]; then
        report fail "Quarto book render" "${elapsed}s exceeds the 40min hard limit (same gate as CI)"
      elif [ "$elapsed" -gt 1500 ]; then
        report warn "Quarto book render" "${elapsed}s exceeds the 25min soft limit (same gate as CI)"
      else
        report pass "Quarto book render" "${elapsed}s"
      fi
    else
      report fail "Quarto book render" "render errors, see tail below"
      tail -n 30 "$TMPDIR_LOCAL/render.log"
    fi
  else
    report skip "Quarto book render" "quarto not found (https://quarto.org/docs/download/)"
  fi
fi

echo "----------------------------------------------------------------"
echo "Summary: $PASS passed, $WARN warnings, $FAIL failed, $SKIP skipped"
if [ "$FAIL" -gt 0 ]; then
  red "Local validation FAILED."
  exit 1
fi
green "Local validation passed (skipped checks are listed above)."
exit 0
