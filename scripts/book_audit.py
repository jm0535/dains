#!/usr/bin/env python3
"""Fast, dependency-free integrity checks for the Quarto book.

This is intentionally separate from the R tests: it checks the manuscript's
contracts (paths, labels, citations, and the known dataset mappings) without
requiring R or Quarto.
"""
from __future__ import annotations

import csv
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

DATASETS = {
    "agriculture/crop_yields.csv": {"Entity", "Year"},
    "botany/plant_traits.csv": {"country", "year", "num_events"},
    "ecology/biodiversity.csv": {"binomial_name", "red_list_category"},
    "economics/economic.csv": {"total_cup_points", "country_of_origin"},
    "entomology/insects.csv": {"year", "animal_type", "outcome", "Total"},
    "environmental/climate_data.csv": {"species", "bill_length_mm", "body_mass_g"},
    "epidemiology/disease_data.csv": {"name", "lat", "long", "wind"},
    "forestry/forest_inventory.csv": {"name", "height", "species"},
    "geography/spatial.csv": {"medicine_name", "authorisation_status"},
    "marine/ocean_data.csv": {"year", "lake", "species", "values"},
}


def fail(message: str, errors: list[str]) -> None:
    errors.append(message)


def main() -> int:
    errors: list[str] = []
    qmd_files = sorted(ROOT.glob("**/*.qmd"))

    # Every referenced bundled CSV must exist. Validate a small, stable header
    # contract so exercises cannot silently drift away from their data.
    referenced = set()
    for path in qmd_files:
        text = path.read_text(encoding="utf-8")
        for raw in re.findall(r"(?:\.\./)?data/([^`\"')\s]+\.csv)", text):
            referenced.add(raw)
        for label in re.findall(r"^#\| label:\s*([^\s]+)", text, flags=re.MULTILINE):
            # Labels are checked globally below; this branch makes the regex
            # explicit and keeps the source easy to extend.
            pass

    for rel in sorted(referenced | set(DATASETS)):
        data_path = ROOT / "data" / rel
        if not data_path.exists():
            fail(f"missing dataset referenced or documented: data/{rel}", errors)
            continue
        if rel in DATASETS:
            with data_path.open(newline="", encoding="utf-8-sig") as handle:
                header = set(next(csv.reader(handle)))
            missing = DATASETS[rel] - header
            if missing:
                fail(f"data/{rel} is missing expected columns: {sorted(missing)}", errors)

    # Quarto labels must be unique across the book; duplicate labels produce
    # ambiguous cross-references and are easy to introduce during editing.
    labels: dict[str, Path] = {}
    for path in qmd_files:
        text = path.read_text(encoding="utf-8")
        for label in re.findall(r"^#\| label:\s*([^\s]+)", text, flags=re.MULTILINE):
            if label in labels:
                fail(f"duplicate chunk label '{label}' in {path} and {labels[label]}", errors)
            labels[label] = path
        for label in re.findall(r"\{#([^}]+)\}", text):
            if label in labels:
                fail(f"duplicate label '{label}' in {path} and {labels[label]}", errors)
            labels[label] = path

    # All authored citations should resolve to references.bib. Ignore Quarto's
    # cross-reference syntax such as @fig- and @tbl-.
    bib = ROOT.joinpath("references.bib").read_text(encoding="utf-8")
    bib_keys = set(re.findall(r"^@\w+\{([^,]+),", bib, flags=re.MULTILINE))
    citations = set()
    for path in qmd_files:
        citations.update(re.findall(r"@([A-Za-z][\w-]*)", path.read_text(encoding="utf-8")))
    ignored = {"book", "param", "get"} | {x for x in citations if x.startswith(("fig-", "tbl-"))}
    unresolved = sorted((citations - ignored) - bib_keys)
    for key in unresolved:
        fail(f"citation '@{key}' has no entry in references.bib", errors)

    if errors:
        print("Book audit failed:")
        print("- " + "\n- ".join(errors))
        return 1
    print(f"Book audit passed: {len(qmd_files)} QMD files, {len(DATASETS)} dataset contracts, {len(labels)} labels.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
