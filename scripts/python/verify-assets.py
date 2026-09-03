"""
Checks that every file referenced in ASSETS.md status tables actually exists on disk.
Standard library only.

Usage:
    python verify_assets.py
"""

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
ASSETS_MD = ROOT / "ASSETS.md"

VARIANTS = ["dark", "light", "colorful"]
STATUS_DONE = "✅"  # done marker used in ASSETS.md tables

# Matches bitmap rows: | `name.xcf` | dims | variants | Dark | Light | Colorful |
BITMAP_ROW = re.compile(
    r"^\|\s*`([\w.\-]+\.xcf)`\s*\|[^|]*\|[^|]*\|\s*([^|]+)\|\s*([^|]+)\|\s*([^|]+)\|"
)


def bitmap_targets() -> list[tuple[Path, bool]]:
    """Return (path, expected_done) pairs for every dark/light/colorful bitmap cell."""
    targets: list[tuple[Path, bool]] = []
    text = ASSETS_MD.read_text(encoding="utf-8")
    for line in text.splitlines():
        m = BITMAP_ROW.match(line.strip())
        if not m:
            continue
        source_xcf, dark_cell, light_cell, colorful_cell = m.groups()
        stem = Path(source_xcf).stem
        for variant, cell in zip(VARIANTS, (dark_cell, light_cell, colorful_cell)):
            done = STATUS_DONE in cell
            bmp_path = ROOT / "assets" / variant / f"{stem}.bmp"
            targets.append((bmp_path, done))
    return targets


def main() -> int:
    if not ASSETS_MD.exists():
        print(f"ERROR: {ASSETS_MD} not found", file=sys.stderr)
        return 1

    targets = bitmap_targets()
    if not targets:
        print("No bitmap rows parsed from ASSETS.md — check the table format hasn't changed.")
        return 0

    missing_but_marked_done = [p for p, done in targets if done and not p.exists()]
    present_but_not_marked = [p for p, done in targets if not done and p.exists()]

    total = len(targets)
    done_count = sum(1 for _, done in targets if done)

    print(f"Checked {total} bitmap slots ({done_count} marked done in ASSETS.md)\n")

    if missing_but_marked_done:
        print(f"MISSING ({len(missing_but_marked_done)}) — marked done in ASSETS.md but not on disk:")
        for p in missing_but_marked_done:
            print(f"  - {p.relative_to(ROOT)}")
        print()

    if present_but_not_marked:
        print(f"UNTRACKED ({len(present_but_not_marked)}) — on disk but not marked done in ASSETS.md:")
        for p in present_but_not_marked:
            print(f"  - {p.relative_to(ROOT)}")
        print()

    if not missing_but_marked_done and not present_but_not_marked:
        print("PASS — ASSETS.md status matches what's on disk.")
        return 0

    return 1 if missing_but_marked_done else 0


if __name__ == "__main__":
    sys.exit(main())
