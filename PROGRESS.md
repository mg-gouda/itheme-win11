# Win11 Theme — Progress Tracker

Update this file as you complete tasks. Claude reads it at the start of every session
to know where you are and what to work on next.

---

## Current Status

```
Phase:    01 — Setup & Study
Status:   IN PROGRESS
Blocker:  None
```

---

## Quick Summary for Claude

> Update this block every few sessions so Claude has instant context.

```
Last worked on : 2026-09-03
Last completed : Folder scaffold run, Git repo initialized, Python 3.12 +
                 GIMP installed globally, package-release.py written
Currently on   : Phase 1 — VM/VirtualBox/Resource Hacker/SecureUxTheme
                 setup still needed (deliberately left manual — see notes)
Next action    : Set up the Win11 VM (tasks 1.5-1.10), then explore
                 aero.msstyles in Resource Hacker (tasks 1.11-1.15)
Blockers       : None
```

---

## Phase Tracker

### ✅ Complete
- [x] Project planning
- [x] Tool selection (free route confirmed)
- [x] Three variants decided: Dark, Light, Colorful
- [x] Roadmap written (see project roadmap artifact)
- [x] CLAUDE.md, MEMORY.md, PROGRESS.md created

---

### 🔵 Phase 01 — Setup & Study
**Timeline:** Week 1 (~6–8 hrs)
**Branch:** `phase/01-setup`

| # | Task | Status | Notes |
|---|---|---|---|
| 1.1 | Run folder scaffolding script | ✅ Done | `scripts/powershell/scaffold.ps1` generated and run |
| 1.2 | Download Resource Hacker | ⬜ Not started | rhsoftware.net — manual download, needed inside the VM |
| 1.3 | Download GIMP 2.10+ | ✅ Done | Installed globally via `winget install GIMP.GIMP` |
| 1.4 | Create Figma free account | ⬜ Not started | figma.com |
| 1.5 | Download VirtualBox | ✅ Done | Installed globally via `winget install Oracle.VirtualBox` (7.2.16) |
| 1.6 | Download Windows 11 evaluation ISO | 🔨 In progress | Win11 25H2 Pro ISO downloading via BITS to `iTheme_Win11_VM\iso\` |
| 1.7 | Create and configure Win11 VM | 🔨 In progress | `iTheme_Win11_VM\create-vm.ps1` written (4GB RAM, 64GB disk, UEFI+TPM2.0+Secure Boot, unattended install) — awaiting ISO |
| 1.8 | Download & install SecureUxTheme on VM | ⬜ Not started | github.com/namazso/SecureUxTheme — after VM boots |
| 1.9 | Install Resource Hacker on VM | ⬜ Not started | rhsoftware.net — after VM boots |
| 1.10 | Set up VirtualBox shared folder → theme-files/ | ✅ Done | Configured in `create-vm.ps1` as shared folder "win11-theme" -> repo root, automount |
| 1.11 | Download 2–3 reference themes from DeviantArt | ⬜ Not started | Search "windows 11 theme msstyles" |
| 1.12 | Open reference themes in Resource Hacker — study structure | ⬜ Not started | Note which resource types exist (BITMAP, String Table, etc.) |
| 1.13 | Copy aero.msstyles to theme-files/base/ | ⬜ Not started | Path: `C:\Windows\Resources\Themes\aero\aero.msstyles` |
| 1.14 | Open aero.msstyles in Resource Hacker — explore | ⬜ Not started | Note down bitmap IDs for title bar, scrollbar, buttons |
| 1.15 | Fill in Bitmap Dimension Reference in MEMORY.md | ⬜ Not started | Note dimensions as you find them |
| 1.16 | Initialize Git repo and make first commit | 🔨 In progress | `git init` done, all files staged — first commit awaiting your go-ahead |

**Phase 1 Complete when:** All tools installed, VM running with SecureUxTheme, aero.msstyles explored, first commit made.

---

### ⬜ Phase 02 — Design System
**Timeline:** Weeks 2–3 (~10–12 hrs)
**Branch:** `phase/02-design-system`
**Prerequisite:** Phase 1 complete

| # | Task | Status | Notes |
|---|---|---|---|
| 2.1 | Create Figma file: "Win11 Theme Design System" | ⬜ Not started | |
| 2.2 | Finalize Dark palette (all 20 tokens in MEMORY.md) | ⬜ Not started | Adjust draft values to taste |
| 2.3 | Finalize Light palette | ⬜ Not started | |
| 2.4 | Finalize Colorful palette | ⬜ Not started | |
| 2.5 | Update MEMORY.md color-system with final hex values | ⬜ Not started | These become the source of truth |
| 2.6 | Create Figma mockup: title bar (all 3 variants) | ⬜ Not started | |
| 2.7 | Create Figma mockup: taskbar (all 3 variants) | ⬜ Not started | |
| 2.8 | Create Figma mockup: context menu (all 3 variants) | ⬜ Not started | |
| 2.9 | Create Figma mockup: a full window with controls | ⬜ Not started | |
| 2.10 | Fill component map resource IDs in MEMORY.md | ⬜ Not started | From Phase 1 Resource Hacker exploration |
| 2.11 | Create design/color-system.md | ⬜ Not started | Ask Claude: "Generate design/color-system.md from MEMORY.md" |
| 2.12 | Create design/component-map.md | ⬜ Not started | Ask Claude: "Generate design/component-map.md" |
| 2.13 | Export Figma color reference as PDF | ⬜ Not started | Keep open while working in GIMP |
| 2.14 | Commit: "feat: design system v1" | ⬜ Not started | |

**Phase 2 Complete when:** All three palettes finalized and written to MEMORY.md, Figma mockups done, component map has resource IDs filled in.

---

### ⬜ Phase 03 — Base Theme Build (Dark)
**Timeline:** Weeks 3–6 (the longest phase)
**Branch:** `phase/03-base-build`
**Prerequisite:** Phase 2 complete

| # | Task | Status | Notes |
|---|---|---|---|
| 3.1 | Copy base/aero.msstyles → dark/MyTheme_Dark.msstyles | ⬜ Not started | Start of actual editing |
| 3.2 | **Title bars** — create GIMP .xcf source files | ⬜ Not started | Active + inactive states |
| 3.3 | Export title bar BMPs → assets/dark/ | ⬜ Not started | Match exact pixel dimensions |
| 3.4 | Import title bar BMPs into MyTheme_Dark.msstyles | ⬜ Not started | Via Resource Hacker Replace Resource |
| 3.5 | Test title bars on VM | ⬜ Not started | Apply theme, screenshot result |
| 3.6 | **Window chrome buttons** — create in GIMP (close/min/max) | ⬜ Not started | All 3 states each: normal, hover, pressed |
| 3.7 | Import and test chrome buttons | ⬜ Not started | |
| 3.8 | **Scrollbars** — create track + thumb + arrows in GIMP | ⬜ Not started | Vertical and horizontal |
| 3.9 | Import and test scrollbars | ⬜ Not started | |
| 3.10 | **Buttons** — normal, hover, pressed, disabled | ⬜ Not started | |
| 3.11 | Import and test buttons | ⬜ Not started | |
| 3.12 | **Checkboxes & radio buttons** — all states | ⬜ Not started | |
| 3.13 | Import and test checkboxes/radios | ⬜ Not started | |
| 3.14 | **Progress bars** — track + fill | ⬜ Not started | |
| 3.15 | **Context menus** — background, separator, highlight | ⬜ Not started | |
| 3.16 | **Edit system color strings** in Resource Hacker | ⬜ Not started | Use RGB values from MEMORY.md dark palette |
| 3.17 | Full VM test — Dark variant complete | ⬜ Not started | Every modified element working correctly |
| 3.18 | Generate MyTheme_Dark.theme file | ⬜ Not started | Ask Claude: "Generate the .theme file for the dark variant" |
| 3.19 | Test .theme file on VM (clean apply) | ⬜ Not started | |
| 3.20 | Log every modified resource ID in docs/mod-log.md | ⬜ Not started | Critical for Phase 4 |
| 3.21 | Commit: "feat(dark): base theme complete" | ⬜ Not started | |

**Phase 3 Complete when:** Dark variant is a fully working .msstyles + .theme that applies cleanly on a fresh VM, with every component on the component map addressed.

---

### ⬜ Phase 04 — Three Variants
**Timeline:** Weeks 6–8
**Branch:** `phase/04-variants`
**Prerequisite:** Phase 3 complete, mod-log.md filled

| # | Task | Status | Notes |
|---|---|---|---|
| 4.1 | Duplicate MyTheme_Dark.msstyles → MyTheme_Light.msstyles | ⬜ Not started | |
| 4.2 | Duplicate MyTheme_Dark.msstyles → MyTheme_Colorful.msstyles | ⬜ Not started | |
| 4.3 | **Light** — recreate all GIMP assets in Light palette | ⬜ Not started | Ask Claude: "Write a GIMP Script-Fu to swap Dark palette to Light palette in all source files" |
| 4.4 | Export Light BMPs → assets/light/ | ⬜ Not started | |
| 4.5 | Import Light BMPs into MyTheme_Light.msstyles | ⬜ Not started | Use mod-log.md as the import checklist |
| 4.6 | Update color strings in Light .msstyles | ⬜ Not started | RGB values from MEMORY.md light palette |
| 4.7 | Generate MyTheme_Light.theme file | ⬜ Not started | |
| 4.8 | VM test — Light variant | ⬜ Not started | |
| 4.9 | **Colorful** — recreate GIMP assets in Colorful palette | ⬜ Not started | Title bar likely needs gradient bitmap |
| 4.10 | Export Colorful BMPs → assets/colorful/ | ⬜ Not started | |
| 4.11 | Import Colorful BMPs into MyTheme_Colorful.msstyles | ⬜ Not started | |
| 4.12 | Update color strings in Colorful .msstyles | ⬜ Not started | |
| 4.13 | Generate MyTheme_Colorful.theme file | ⬜ Not started | |
| 4.14 | VM test — Colorful variant | ⬜ Not started | |
| 4.15 | Full VM test: apply all 3 variants in sequence, fresh each time | ⬜ Not started | |
| 4.16 | Commit: "feat: all three variants complete" | ⬜ Not started | |

**Phase 4 Complete when:** All three .msstyles + .theme files apply cleanly on a fresh VM with no artifacts from each other.

---

### ⬜ Phase 05 — Supporting Assets
**Timeline:** Weeks 8–9
**Branch:** `phase/05-assets`

| # | Task | Status | Notes |
|---|---|---|---|
| 5.1 | **Wallpapers Dark** — create 4 × 3840×2160 | ⬜ Not started | In GIMP or AI-generated + GIMP polish |
| 5.2 | **Wallpapers Light** — create 4 × 3840×2160 | ⬜ Not started | |
| 5.3 | **Wallpapers Colorful** — create 4 × 3840×2160 | ⬜ Not started | |
| 5.4 | Update .theme files to reference wallpapers | ⬜ Not started | |
| 5.5 | **Cursor pack** — design 14 cursors in RealWorld Cursor Editor | ⬜ Not started | See MEMORY.md cursor spec |
| 5.6 | Generate cursors/install.inf | ⬜ Not started | Ask Claude: "Write the install.inf for the cursor pack" |
| 5.7 | Test cursor installation on VM | ⬜ Not started | |
| 5.8 | **Sound scheme** (optional) — source 12 .wav clips | ⬜ Not started | freesound.org for royalty-free clips |
| 5.9 | Add sounds section to .theme files | ⬜ Not started | |
| 5.10 | **Icon pack** with 7tsp GUI (optional) | ⬜ Not started | Only tackle if time allows — adds significant effort |
| 5.11 | Commit: "feat: supporting assets complete" | ⬜ Not started | |

---

### ⬜ Phase 06 — Test & Package
**Timeline:** Weeks 9–10
**Branch:** `phase/06-package`

| # | Task | Status | Notes |
|---|---|---|---|
| 6.1 | Fresh VM clean-install test — Dark | ⬜ Not started | No prior theme history on VM |
| 6.2 | Fresh VM clean-install test — Light | ⬜ Not started | |
| 6.3 | Fresh VM clean-install test — Colorful | ⬜ Not started | |
| 6.4 | Follow your own INSTALL.md step-by-step | ⬜ Not started | Fix any step that is unclear or broken |
| 6.5 | Write docs/INSTALL.md | ⬜ Not started | Ask Claude: "Write the user installation guide" |
| 6.6 | Take preview screenshots 1920×1080 — Dark | ⬜ Not started | Desktop, open window, File Explorer, right-click menu |
| 6.7 | Take preview screenshots 1920×1080 — Light | ⬜ Not started | |
| 6.8 | Take preview screenshots 1920×1080 — Colorful | ⬜ Not started | |
| 6.9 | Organize final release folder structure | ⬜ Not started | See CLAUDE.md for required structure |
| 6.10 | Write packaging script | ⬜ Not started | Ask Claude: "Write the Python packaging script for release/" |
| 6.11 | Run packaging script → MyTheme_v1.0.zip | ⬜ Not started | |
| 6.12 | Install from the zip on a clean VM — final acceptance test | ⬜ Not started | |
| 6.13 | Commit: "chore: package v1.0 release" + tag `v1.0` | ⬜ Not started | |

---

### ⬜ Phase 07 — Publish
**Timeline:** Week 10
**Branch:** `phase/07-publish`

| # | Task | Status | Notes |
|---|---|---|---|
| 7.1 | Create GitHub repository | ⬜ Not started | Public, MIT license, include README |
| 7.2 | Write GitHub README.md | ⬜ Not started | Ask Claude: "Write the GitHub README for this theme" |
| 7.3 | Upload MyTheme_v1.0.zip as GitHub Release | ⬜ Not started | Tag: `v1.0` |
| 7.4 | Create DeviantArt account (if needed) | ⬜ Not started | deviantart.com |
| 7.5 | Upload to DeviantArt with all preview screenshots | ⬜ Not started | Minimum 5 screenshots |
| 7.6 | Write DeviantArt description | ⬜ Not started | Ask Claude: "Write the DeviantArt submission description" |
| 7.7 | Add tags on DeviantArt | ⬜ Not started | windows11, msstyles, theme, windowscustomization, dark, light |
| 7.8 | Post to r/windowscustomization | ⬜ Not started | Best screenshot, link to DeviantArt |
| 7.9 | Post to r/desktops | ⬜ Not started | |
| 7.10 | Build showcase landing page (optional) | ⬜ Not started | Ask Claude to build it |
| 7.11 | Commit: "docs: add README and publish materials" | ⬜ Not started | |

---

## Issues & Blockers

> Log any problems here so Claude can help resolve them next session.

| Date | Issue | Severity | Resolved? |
|---|---|---|---|
| — | None yet | — | — |

---

## Resource ID Discovery Log

> Fill this in during Phase 1 exploration of aero.msstyles in Resource Hacker.
> This supplements the full mod-log.md in docs/.

| Resource Type | ID Range / Pattern | What it controls |
|---|---|---|
| BITMAP | TBD | Window bitmaps |
| String Table | TBD | Color RGB values |

---

## How to Start Each Claude Session

Paste this at the beginning of a new Claude Code session:

```
Read CLAUDE.md, MEMORY.md, and PROGRESS.md.
Current phase: [PHASE NUMBER AND NAME]
I need help with: [SPECIFIC TASK FROM PROGRESS.md]
```
