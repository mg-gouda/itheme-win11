"""
Reads the color palettes from MEMORY.md and calculates WCAG contrast ratios
for every text/background pair. Standard library only.

Usage:
    python color-contrast.py
"""

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
MEMORY_MD = ROOT / "MEMORY.md"

# variant heading -> section title as it appears in MEMORY.md
VARIANT_HEADINGS = {
    "Dark Variant": "dark",
    "Light Variant": "light",
    "Colorful Variant": "colorful",
}

TOKEN_ROW = re.compile(
    r"^\|\s*`([\w-]+)`\s*\|\s*`(#[0-9a-fA-F]{6})`\s*\|"
)

# (text token, background token) pairs worth checking per variant
PAIRS = [
    ("text-primary", "surface-0"),
    ("text-primary", "bg"),
    ("text-secondary", "surface-0"),
    ("text-disabled", "surface-0"),
    ("title-text", "title-active"),
    ("highlight-text", "highlight"),
]

AA_NORMAL, AA_LARGE = 4.5, 3.0


def parse_palettes() -> dict[str, dict[str, str]]:
    text = MEMORY_MD.read_text(encoding="utf-8")
    lines = text.splitlines()
    palettes: dict[str, dict[str, str]] = {}
    current_variant = None

    for line in lines:
        heading = re.match(r"^###\s+(.+)$", line.strip())
        if heading:
            title = heading.group(1).strip()
            current_variant = VARIANT_HEADINGS.get(title)
            if current_variant:
                palettes[current_variant] = {}
            continue

        if current_variant:
            m = TOKEN_ROW.match(line)
            if m:
                token, hexval = m.groups()
                palettes[current_variant][token] = hexval

    return palettes


def relative_luminance(hexval: str) -> float:
    hexval = hexval.lstrip("#")
    r, g, b = (int(hexval[i:i + 2], 16) / 255 for i in (0, 2, 4))

    def channel(c: float) -> float:
        return c / 12.92 if c <= 0.03928 else ((c + 0.055) / 1.055) ** 2.4

    r, g, b = channel(r), channel(g), channel(b)
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


def contrast_ratio(hex_a: str, hex_b: str) -> float:
    l1, l2 = relative_luminance(hex_a), relative_luminance(hex_b)
    lighter, darker = max(l1, l2), min(l1, l2)
    return (lighter + 0.05) / (darker + 0.05)


def verdict(ratio: float) -> str:
    if ratio >= AA_NORMAL:
        return "PASS"
    if ratio >= AA_LARGE:
        return "WARN (large text only)"
    return "FAIL"


def main() -> None:
    palettes = parse_palettes()
    if not palettes:
        print(f"No palettes parsed from {MEMORY_MD.relative_to(ROOT)} — check the table format.")
        return

    for variant, tokens in palettes.items():
        print(f"\n{variant.upper()}")
        print("-" * 60)
        for fg_token, bg_token in PAIRS:
            fg, bg = tokens.get(fg_token), tokens.get(bg_token)
            if not fg or not bg:
                print(f"  {fg_token:16} on {bg_token:16}  SKIP (token not found)")
                continue
            ratio = contrast_ratio(fg, bg)
            print(f"  {fg_token:16} on {bg_token:16}  {ratio:5.2f}:1  {verdict(ratio)}")


if __name__ == "__main__":
    main()
