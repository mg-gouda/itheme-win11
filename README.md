# Scripts

All automation scripts for this project.
Claude generates these on request — ask for them by name.

---

## How to Request a Script

In a Claude CLI session, say:
```
Generate scripts/[folder]/[filename] — [what it should do]
```

Example:
```
Generate scripts/powershell/scaffold.ps1 —
create the full project folder structure from CLAUDE.md
```

---

## Script Inventory

### PowerShell (`scripts/powershell/`)

#### `scaffold.ps1`
**Status:** ✅ Generated  
**Purpose:** Creates the complete project folder structure from scratch.  
**Run:** `.\scaffold.ps1` from the project root (PowerShell as Administrator not required)  
**Generates:** All folders defined in CLAUDE.md Project Structure  

---

#### `apply-theme.ps1`
**Status:** ✅ Generated  
**Purpose:** Copies the built .msstyles and .theme files to the VM shared folder and triggers application.  
**Run:** `.\apply-theme.ps1 -Variant dark` (or light, colorful)  
**Requires:** VirtualBox shared folder configured  

---

#### `clean-vm.ps1`
**Status:** ✅ Generated  
**Purpose:** Resets the VM's theme to Windows default for clean testing.  
**Run on VM:** `.\clean-vm.ps1`  
**Use case:** Before testing a new build to avoid stale state  

---

### GIMP Script-Fu (`scripts/gimp/`)

Run via: GIMP → Filters → Script-Fu → Console → `(load "/path/to/script.scm")` then call the function

---

#### `export-bitmaps.scm`
**Status:** ✅ Generated  
**Purpose:** Opens every .xcf in assets/source/ and exports three BMP copies — one per variant — to assets/dark/, assets/light/, and assets/colorful/.  
**Run:** Load in Script-Fu console, then call `(export-all-variants)`  
**Requires:** All palette colors defined in the script constants at the top  

---

#### `palette-swap.scm`
**Status:** ✅ Generated  
**Purpose:** Given a .xcf file using Dark palette colors, replaces every color with the equivalent Light or Colorful palette color.  
**Run:** `(palette-swap "/path/to/file.xcf" "light")` or `"colorful"`  
**How it works:** Uses GIMP's color-select + bucket-fill to replace specific hex values  
**Limitation:** Works best on flat-color bitmaps; gradients require manual adjustment  

---

#### `new-bitmap.scm`
**Status:** ✅ Generated  
**Purpose:** Creates a new blank .xcf file at the correct dimensions for a named component.  
**Run:** `(new-bitmap "title-bar-active" 800 30)` — creates the file with correct canvas size and base layers  
**Generates:** `assets/source/title-bar-active.xcf` with a layer structure ready to design  

---

#### `check-dimensions.scm`
**Status:** ✅ Generated  
**Purpose:** Opens all .xcf files in assets/source/ and prints their dimensions for cross-checking against the aero.msstyles originals in MEMORY.md.  
**Run:** `(check-all-dimensions)` → outputs a table to the Script-Fu console  

---

### Python (`scripts/python/`)

Run with: `python scripts/python/[filename].py`

---

#### `package-release.py`
**Status:** ✅ Generated  
**Purpose:** Assembles the final release .zip from the correct folder structure.  
**Run:** `python package-release.py --version 1.0`  
**Generates:** `release/MyTheme_v1.0.zip` with the exact structure defined in CLAUDE.md  
**Checks before zipping:**
- All required files exist
- No .xcf source files accidentally included
- INSTALL.txt present

---

#### `verify-assets.py`
**Status:** ✅ Generated  
**Purpose:** Reads ASSETS.md and checks that every file marked ✅ actually exists on disk.  
**Run:** `python verify-assets.py`  
**Output:** Pass/fail per file, summary count  
**Use case:** Before packaging, to catch missing files  

---

#### `update-progress.py`
**Status:** ✅ Generated  
**Purpose:** Scans assets/ folder for existing files and updates the completion counts in ASSETS.md automatically.  
**Run:** `python update-progress.py`  
**Output:** Updated ASSETS.md with accurate Done counts and percentages  
**Run this:** After every significant work session  

---

#### `color-contrast.py`
**Status:** ✅ Generated  
**Purpose:** Reads the color palettes from MEMORY.md and calculates WCAG contrast ratios for every text/background pair.  
**Run:** `python color-contrast.py`  
**Output:** A table of contrast ratios with PASS/WARN/FAIL per pair  
**Use case:** Verify your Light variant text is legible before Phase 3 build begins  
**Note:** Windows themes don't legally require WCAG compliance, but low-contrast choices cause user complaints  

---

## Script Dependencies

| Script | Requires |
|---|---|
| `scaffold.ps1` | PowerShell 7+ |
| `apply-theme.ps1` | PowerShell 7+, VirtualBox shared folder |
| `*.scm` files | GIMP 2.10+, Script-Fu console |
| `package-release.py` | Python 3.10+ |
| `verify-assets.py` | Python 3.10+ |
| `update-progress.py` | Python 3.10+ |
| `color-contrast.py` | Python 3.10+ |

No external Python packages required — only standard library.
