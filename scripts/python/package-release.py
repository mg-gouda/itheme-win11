"""
Assembles the final release zip from the project's built assets.
Only uses the standard library — no pip installs required.

Usage:
    python package-release.py --version 1.0
    python package-release.py --version 1.0 --variant dark   # single variant only
"""

import argparse
import sys
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
RELEASE_DIR = ROOT / "release"

VARIANTS = ["dark", "light", "colorful"]

# Root-level files every variant's download should carry
COMMON_FILES = [
    ROOT / "docs" / "INSTALL.md",
    ROOT / "README.md",
    ROOT / "LICENSE",
]

# Extensions that must never end up in a shipped zip (source/editable files)
FORBIDDEN_SUFFIXES = {".xcf", ".psd", ".kra"}


def _real_files(*globs: Path) -> list[Path]:
    files: list[Path] = []
    for pattern in globs:
        files += sorted(
            p for p in pattern.parent.glob(pattern.name)
            if p.is_file() and not p.name.startswith(".")
        )
    return files


def variant_files(variant: str) -> list[Path]:
    return _real_files(
        ROOT / "theme-files" / variant / "*",
        ROOT / "wallpapers" / variant / "*",
    )


def shared_files() -> list[Path]:
    return _real_files(
        ROOT / "cursors" / "*",
        ROOT / "sounds" / "*",
    )


def check_forbidden(paths: list[Path]) -> list[Path]:
    return [p for p in paths if p.suffix.lower() in FORBIDDEN_SUFFIXES]


def build_zip(version: str, variants: list[str]) -> Path:
    RELEASE_DIR.mkdir(exist_ok=True)
    out_path = RELEASE_DIR / f"MyTheme_v{version}.zip"

    all_files: list[tuple[Path, str]] = []

    for variant in variants:
        vfiles = variant_files(variant)
        if not vfiles:
            print(f"WARNING: no files found for variant '{variant}' — skipping", file=sys.stderr)
            continue
        for f in vfiles:
            arcname = f"MyTheme/{variant}/{f.relative_to(ROOT / 'theme-files' / variant).as_posix()}" \
                if f.is_relative_to(ROOT / "theme-files" / variant) \
                else f"MyTheme/{variant}/wallpapers/{f.name}"
            all_files.append((f, arcname))

    for f in shared_files():
        all_files.append((f, f"MyTheme/shared/{f.relative_to(ROOT).as_posix()}"))

    for f in COMMON_FILES:
        if f.exists():
            all_files.append((f, f"MyTheme/{f.name}"))
        else:
            print(f"WARNING: expected file missing: {f.relative_to(ROOT)}", file=sys.stderr)

    real_files = [f for f, _ in all_files if f.is_file()]
    forbidden = check_forbidden(real_files)
    if forbidden:
        print("ERROR: source/editable files would be included in the release zip:", file=sys.stderr)
        for f in forbidden:
            print(f"  - {f.relative_to(ROOT)}", file=sys.stderr)
        sys.exit(1)

    if not real_files:
        print("ERROR: nothing to package — no built files found. Run this after Phase 3+.", file=sys.stderr)
        sys.exit(1)

    with zipfile.ZipFile(out_path, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as zf:
        for f, arcname in all_files:
            if f.is_file():
                zf.write(f, arcname)

    print(f"Packaged {len(real_files)} files -> {out_path.relative_to(ROOT)}")
    return out_path


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--version", required=True, help="Release version, e.g. 1.0")
    parser.add_argument(
        "--variant",
        choices=VARIANTS,
        action="append",
        dest="variants",
        help="Limit packaging to one variant (repeatable). Default: all three.",
    )
    args = parser.parse_args()
    build_zip(args.version, args.variants or VARIANTS)


if __name__ == "__main__":
    main()
