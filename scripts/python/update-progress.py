"""
Scans the project folders and rewrites ASSETS.md status columns + summary
tables to reflect what actually exists on disk. Safe to re-run — idempotent.
Standard library only.

Usage:
    python update-progress.py
"""

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
ASSETS_MD = ROOT / "ASSETS.md"

VARIANTS = ["dark", "light", "colorful"]
NOT_STARTED, DONE = "⬜", "✅"

# Per-variant bitmap category rows. Two table shapes exist in ASSETS.md:
#   Window Chrome:        | name.xcf | dims | variants | Dark | Light | Colorful |
#   everything else:      | name.xcf | dims | Dark | Light | Colorful |
# Match generically off cell count rather than assuming a fixed column layout.
BITMAP_ROW = re.compile(r"^\|\s*`([\w.\-]+\.xcf)`\s*\|(.+)\|\s*$")

# Single-status tables: | `path` | ... | STATUS | ... |  (status is a lone ⬜/✅/⏭ cell)
SINGLE_STATUS_ROW = re.compile(r"^(\|\s*`([^`]+)`\s*\|.*?\|\s*)([⬜✅⏭])(\s*\|.*)$")

BITMAP_CATEGORIES = [
    "Window Chrome",
    "Scrollbars",
    "Buttons",
    "Form Controls",
    "Menus",
    "Taskbar",
]


def cell_status(current: str, is_done: bool) -> str:
    stripped = current.strip()
    if stripped == "—":  # not applicable for this variant (e.g. window-shadow, dark-only)
        return current
    return f" {DONE} " if is_done else f" {NOT_STARTED} "


def update_bitmap_tables(lines: list[str]) -> tuple[list[str], dict[str, int]]:
    counts = {cat: {v: 0 for v in VARIANTS} for cat in BITMAP_CATEGORIES}
    totals = {cat: 0 for cat in BITMAP_CATEGORIES}
    current_category = None
    out = []

    for line in lines:
        heading = re.match(r"^###\s+(.+)$", line.strip())
        if heading and heading.group(1).strip() in BITMAP_CATEGORIES:
            current_category = heading.group(1).strip()

        m = BITMAP_ROW.match(line)
        if m and current_category:
            stem_xcf, rest = m.groups()
            # rest is "dims | [variants |] Dark | Light | Colorful" (trailing cell already stripped by \s*$)
            cells = rest.split("|")
            lead_cells, variant_cells = cells[:-3], cells[-3:]
            if len(variant_cells) != 3:
                out.append(line)  # unrecognized shape — leave untouched rather than guess
                continue
            stem = Path(stem_xcf).stem
            totals[current_category] += 1
            new_cells = []
            for variant, cell in zip(VARIANTS, variant_cells):
                bmp = ROOT / "assets" / variant / f"{stem}.bmp"
                is_done = bmp.exists()
                if is_done:
                    counts[current_category][variant] += 1
                new_cells.append(cell_status(cell, is_done))
            lead = "|".join(lead_cells)
            out.append(f"| `{stem_xcf}` |{lead}|{new_cells[0]}|{new_cells[1]}|{new_cells[2]}|")
            continue

        out.append(line)

    return out, {"counts": counts, "totals": totals}


def update_single_status_tables(lines: list[str]) -> list[str]:
    out = []
    for line in lines:
        m = SINGLE_STATUS_ROW.match(line)
        if m and m.group(2).endswith(".xcf"):
            m = None  # bitmap category rows are handled by update_bitmap_tables — don't double-process
        if m:
            prefix, rel_path, _status, suffix = m.groups()
            target = ROOT / rel_path
            new_status = DONE if target.exists() else NOT_STARTED
            out.append(f"{prefix}{new_status}{suffix}")
        else:
            out.append(line)
    return out


def rewrite_count_table(lines: list[str], stats: dict) -> list[str]:
    counts, totals = stats["counts"], stats["totals"]
    out = []
    in_count_table = False
    for line in lines:
        if line.strip().startswith("| Category | Total files | Dark"):
            in_count_table = True
            out.append(line)
            continue
        if in_count_table and line.strip().startswith("|---"):
            out.append(line)
            continue
        if in_count_table and line.strip().startswith("| **Total**"):
            total_files = sum(totals.values())
            d = sum(counts[c]["dark"] for c in BITMAP_CATEGORIES)
            li = sum(counts[c]["light"] for c in BITMAP_CATEGORIES)
            co = sum(counts[c]["colorful"] for c in BITMAP_CATEGORIES)
            out.append(f"| **Total** | **{total_files}** | **{d}** | **{li}** | **{co}** |")
            in_count_table = False
            continue
        if in_count_table:
            m = re.match(r"^\|\s*([\w &]+?)\s*\|", line)
            if m and m.group(1) in totals:
                cat = m.group(1)
                out.append(
                    f"| {cat} | {totals[cat]} | {counts[cat]['dark']} "
                    f"| {counts[cat]['light']} | {counts[cat]['colorful']} |"
                )
                continue
        out.append(line)
    return out


def main() -> None:
    text = ASSETS_MD.read_text(encoding="utf-8")
    lines = text.splitlines()

    lines, stats = update_bitmap_tables(lines)
    lines = update_single_status_tables(lines)
    lines = rewrite_count_table(lines, stats)

    newline = "\r\n" if "\r\n" in text else "\n"
    ASSETS_MD.write_text(newline.join(lines) + newline, encoding="utf-8", newline="")

    totals = stats["totals"]
    counts = stats["counts"]
    total_files = sum(totals.values())
    done = sum(counts[c][v] for c in BITMAP_CATEGORIES for v in VARIANTS)
    print(f"Updated ASSETS.md — bitmap exports {done}/{total_files} done.")


if __name__ == "__main__":
    main()
