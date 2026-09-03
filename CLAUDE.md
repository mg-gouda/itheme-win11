# Win11 Theme — Claude Project Context

> Read MEMORY.md for color specs and design decisions.
> Read PROGRESS.md for current phase status and next actions.

---

## Project Overview

A full custom Windows 11 visual style (`.msstyles`) with three color variants —
**Dark**, **Light**, and **Colorful** — built entirely with free tools.
Target: publish on DeviantArt and GitHub.

This is a binary resource editing project. Claude's role is to write scripts,
generate configs, produce documentation, and automate repetitive work.
Claude cannot open or render `.msstyles` files directly — that happens in
Resource Hacker on Windows.

---

## Tech Stack

### Theme Editing (Windows / VM only)
| Tool | Version | Purpose |
|---|---|---|
| Resource Hacker | Latest | Open and edit `.msstyles` PE resource files |
| GIMP | 2.10+ | Create and export replacement bitmap assets |
| SecureUxTheme | Latest | Patch Windows to load unsigned custom themes |
| VirtualBox | Latest | Isolated Windows 11 test environment |
| 7tsp GUI | Latest | Optional icon pack replacement |
| RealWorld Cursor Editor | Latest | Custom `.ani` / `.cur` cursor files |

### Design
| Tool | Purpose |
|---|---|
| Figma (free tier) | Color system design, component mockups |
| GIMP | Bitmap asset production |

### Scripting & Automation (Claude writes these)
| Language | Used For |
|---|---|
| Python 3.10+ | Asset batch processing, palette swap scripts, packaging |
| GIMP Script-Fu | Automated GIMP operations, batch bitmap export |
| PowerShell 7+ | Windows file management, VM automation |
| Bash | Cross-platform utility scripts |

### Distribution
| Platform | Role |
|---|---|
| Git + GitHub | Version control, file hosting via Releases |
| DeviantArt | Primary community — screenshots + download link |
| Reddit | r/windowscustomization, r/desktops |

---

## Environment Requirements

### Work Machine (any OS with Git + Python)
```
Python     3.10+
GIMP       2.10+  (Script-Fu console must be accessible)
Git        Latest
VS Code    Recommended editor
```

### Test VM (VirtualBox)
```
OS         Windows 11 (evaluation ISO from Microsoft is free)
Patched    SecureUxTheme applied at boot
Tools      Resource Hacker installed inside VM
Share      VirtualBox shared folder pointing to /theme-files/ in this repo
```

### Environment Variables (set these in your shell profile)
```
WIN11_THEME_ROOT  = /path/to/win11-theme/          # this repo
AERO_SOURCE       = C:\Windows\Resources\Themes\aero\aero.msstyles
VM_SHARED         = \\vboxsvr\win11-theme\theme-files\
```

---

## Project Structure

```
win11-theme/
├── CLAUDE.md               # ← you are here
├── MEMORY.md               # Design decisions, color specs, component map
├── PROGRESS.md             # Phase tracker, completed tasks, next actions
│
├── design/
│   ├── color-system.md     # All hex values for all 3 palettes (source of truth)
│   └── component-map.md    # Every UI element + known resource IDs to modify
│
├── assets/
│   ├── source/             # Master .xcf GIMP files (the editable originals)
│   │   └── components/     # One .xcf per UI component group
│   ├── dark/               # Exported BMPs ready to import — Dark variant
│   ├── light/              # Exported BMPs — Light variant
│   └── colorful/           # Exported BMPs — Colorful variant
│
├── theme-files/
│   ├── base/               # Read-only copy of aero.msstyles (never edit)
│   ├── dark/
│   │   ├── MyTheme_Dark.msstyles
│   │   └── MyTheme_Dark.theme
│   ├── light/
│   │   ├── MyTheme_Light.msstyles
│   │   └── MyTheme_Light.theme
│   └── colorful/
│       ├── MyTheme_Colorful.msstyles
│       └── MyTheme_Colorful.theme
│
├── scripts/
│   ├── gimp/               # Script-Fu scripts (.scm) run inside GIMP
│   ├── python/             # Standalone Python scripts
│   └── powershell/         # PowerShell scripts (.ps1) for Windows tasks
│
├── wallpapers/
│   ├── dark/               # 4 images at 3840×2160
│   ├── light/
│   └── colorful/
│
├── cursors/
│   ├── *.ani               # Animated cursors
│   ├── *.cur               # Static cursors
│   └── install.inf         # INF file for one-click cursor install
│
├── sounds/                 # Optional — *.wav system sound scheme
│
├── docs/
│   ├── INSTALL.md          # User-facing install guide
│   ├── mod-log.md          # Log of every resource ID changed (critical)
│   └── screenshots/        # Preview images for publishing (1920×1080)
│
└── release/
    └── MyTheme_v1.0.zip    # Final packaged distribution file
```

---

## .theme File Format (INI)

Every variant needs one of these. Claude can generate these.

```ini
[Theme]
DisplayName=MyTheme Dark

[Control Panel\Desktop]
Wallpaper=%ResourceDir%\Themes\MyTheme\Wallpapers\dark_1.jpg
TileWallpaper=0
WallpaperStyle=10

[VisualStyles]
Path=%ResourceDir%\Themes\MyTheme\dark\MyTheme_Dark.msstyles
ColorStyle=NormalColor
Size=NormalSize
AutoColorization=0

[Colors]
; RGB triples — these set fallback system colors
ActiveTitle=26 31 53
Background=12 15 26
ButtonFace=28 32 50
ButtonText=237 240 248
GrayText=79 88 120
Highlight=0 120 212
HighlightText=255 255 255
HotTrackingColor=0 120 212
InactiveTitle=16 19 36
InactiveTitleText=139 149 182
InfoText=237 240 248
InfoWindow=20 24 43
Menu=20 24 43
MenuText=237 240 248
Scrollbar=28 32 50
TitleText=237 240 248
Window=14 18 32
WindowFrame=43 50 88
WindowText=237 240 248

[Sounds]
; optional — reference a custom sound scheme
```

---

## What Claude Can Generate in This Project

| Deliverable | Command hint to use |
|---|---|
| Project folder scaffolding | "Create the full folder structure as a PowerShell script" |
| GIMP Script-Fu for bitmaps | "Write a Script-Fu to create a title bar bitmap at 800×30 in the dark palette" |
| Python palette swap script | "Write a Python script to batch-replace colors across all light variant BMPs" |
| .theme INI files | "Generate the .theme file for the Colorful variant" |
| Mod log template | "Create docs/mod-log.md" |
| Packaging script | "Write a Python script to zip the release folder with correct structure" |
| INSTALL.md for users | "Write the user-facing installation guide" |
| GitHub README | "Write the GitHub README with install steps and screenshots section" |
| Component map | "List all the Windows UI elements and likely resource types in aero.msstyles" |
| Cursor INF file | "Write the install.inf for the cursor pack" |

---

## Key Rules (Never Break These)

1. **Never edit `theme-files/base/` directly** — it is a read-only reference copy of `aero.msstyles`.
2. **Test on VM first, always** — applying a broken `.msstyles` on your main machine can leave the desktop unresponsive.
3. **Log every resource change** in `docs/mod-log.md` as you work — this is how you replicate the Dark build for Light and Colorful.
4. **Match bitmap pixel dimensions exactly** — Resource Hacker shows dimensions on hover; your GIMP export must match.
5. **Dark variant is the master** — build it to completion first, then duplicate and re-palette for Light and Colorful.
6. **Commit after every working build** — at minimum one commit per completed phase.
7. **Version your releases** — tag releases `v1.0`, `v1.1`, etc. on GitHub.

---

## Resource Hacker Workflow (for reference)

```
1. Open MyTheme_Dark.msstyles in Resource Hacker
2. Expand: BITMAP → [ID] → 1033
3. Right-click the bitmap → "Replace Resource..."
4. Select your exported BMP from assets/dark/
5. File → Save As (never overwrite the original)
6. Copy saved file to VM shared folder
7. Apply theme on VM via .theme file double-click
8. Observe, adjust, repeat
```

---

## GIMP Export Settings for .msstyles Bitmaps

Resource Hacker requires standard Windows BMP format:
- File → Export As → `.bmp`
- Bit depth: **24-bit** (RGB, no alpha) for most elements
- **32-bit** (RGBA) only where transparency is required (e.g. window shadows)
- Do NOT use indexed color mode
- Match dimensions to the original exactly (check Resource Hacker)

---

## Git Conventions

```bash
# Branch per phase
git checkout -b phase/01-setup
git checkout -b phase/02-design-system
git checkout -b phase/03-base-build
# etc.

# Commit format
git commit -m "feat(dark): replace title bar bitmaps"
git commit -m "feat(cursors): add animated pointer set"
git commit -m "fix(light): correct border color in scrollbar"
git commit -m "chore: package v1.0 release zip"
```
