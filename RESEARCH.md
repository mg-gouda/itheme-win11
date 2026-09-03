# Win11 Theme — Research Notes

Populated during Phase 1. Record everything you discover when studying
aero.msstyles and reference themes in Resource Hacker. This becomes
the technical foundation for Phase 3.

---

## Reference Themes Studied

> Find themes on DeviantArt (search: "windows 11 msstyles") or GitHub.
> Download the .msstyles, open in Resource Hacker, take notes below.

| Theme name | Source URL | Author | Style | Rating (1–5) | What it does well |
|---|---|---|---|---|---|
| | | | | | |
| | | | | | |
| | | | | | |

---

## aero.msstyles — Resource Structure

> Discovered during Phase 1 exploration. Fill in as you explore.

### Resource Types Found

| Type | Count | Description |
|---|---|---|
| BITMAP | TBD | Graphical elements (title bars, buttons, etc.) |
| String Table | TBD | Color values, text strings |
| IMAGE | TBD | Additional image resources |
| RCDATA | TBD | Raw data sections |
| _OTHER_ | TBD | |

---

## Bitmap Resource IDs Discovered

> This is the most important section. Record every BITMAP ID you find.
> This directly feeds into MEMORY.md component map and docs/mod-log.md.

### Window Chrome IDs

| Resource ID | Sublevel | What it is | Dimensions | Bit depth |
|---|---|---|---|---|
| | 1033 | | | |
| | 1033 | | | |

### Scrollbar IDs

| Resource ID | Sublevel | What it is | Dimensions | Bit depth |
|---|---|---|---|---|
| | 1033 | | | |

### Button IDs

| Resource ID | Sublevel | What it is | Dimensions | Bit depth |
|---|---|---|---|---|
| | 1033 | | | |

### Checkbox / Radio IDs

| Resource ID | Sublevel | What it is | Dimensions | Bit depth |
|---|---|---|---|---|
| | 1033 | | | |

### Progress Bar IDs

| Resource ID | Sublevel | What it is | Dimensions | Bit depth |
|---|---|---|---|---|
| | 1033 | | | |

### Menu IDs

| Resource ID | Sublevel | What it is | Dimensions | Bit depth |
|---|---|---|---|---|
| | 1033 | | | |

### Taskbar IDs

| Resource ID | Sublevel | What it is | Dimensions | Bit depth |
|---|---|---|---|---|
| | 1033 | | | |

---

## String Table — Color Value Locations

> String tables hold RGB values for system colors.
> Record which string table IDs control which colors.

| String Table ID | Key / Name | Default value | Controls |
|---|---|---|---|
| | | | Window background |
| | | | Title bar text |
| | | | Button face |
| | | | Border |

---

## Technique Notes

> Anything you learn about how to work with .msstyles files that
> isn't obvious from reading the documentation.

### How Resource Hacker handles .msstyles
- [ ] Notes TBD during Phase 1 exploration

### Replacing a BITMAP resource
1. Right-click the resource → Replace Resource
2. Select your BMP file
3. The dimensions must match exactly
4. Save As — never overwrite the source
5. Test on VM before continuing

### Known quirks
- [ ] Document quirks as discovered (e.g. "changing resource X also affects Y unexpectedly")

---

## Reference Theme Technique Discoveries

> Things other theme authors did that are worth understanding or borrowing the technique from (not the art).

| Theme | Technique | How they did it | Worth using? |
|---|---|---|---|
| | | | |

---

## Tools Notes

### Resource Hacker Tips
- [ ] Fill in during Phase 1

### GIMP Notes for .msstyles Bitmaps
- Export must be: File → Export As → .bmp (not "Save As")
- Flatten image before export (Layer → Flatten Image)
- Do not use GIMP's built-in BMP indexed mode — use RGB or RGBA only
- To check your dimensions match: Image → Canvas Size

### GIMP 3.x Script-Fu quirks (installed version is 3.2.4, not 2.10)

Found while writing and testing `scripts/gimp/*.scm` headlessly via
`gimp-console-3.2.exe`. None of these are documented obviously anywhere —
recording them here so nobody has to rediscover them:

- **Batch mode needs an explicit interpreter flag.** GIMP 2.10 defaulted
  `-b` batch commands to Script-Fu. GIMP 3.x doesn't — you must pass
  `--batch-interpreter=plug-in-script-fu-eval`, or it silently fails at the
  first batch command with "No batch interpreter specified."
- **Never pass `-i` (interactive) in an unattended/scripted invocation.**
  It keeps a REPL open reading from stdin after your `-b` commands finish,
  which hangs forever with no output if nothing is feeding it stdin. Use
  `-n` and redirect `< /dev/null` (or `< NUL` on plain cmd) instead.
- **Each `-b` flag is an isolated evaluation — state doesn't carry over
  between them.** `(load "foo.scm")` in one `-b` and `(foo-function)` in
  the next `-b` fails with "unbound variable," even though it looks like
  they should share one session. Combine them into one expression instead:
  `-b '(begin (load "foo.scm") (foo-function))'`.
- **Several PDB procedures were renamed or had their signatures simplified**
  (drawable/raw-name args frequently dropped). Confirmed by testing, not by
  guessing from 2.10 docs:
  - `gimp-edit-fill` → `gimp-drawable-edit-fill`
  - `file-bmp-save` (5 args) → `file-bmp-export` (3 args: run-mode, image, path — no drawable, no raw-name)
  - `gimp-xcf-save` (5 args) → same 3-arg simplification
  - `gimp-file-load` dropped its raw-filename arg — now just (run-mode, filename)
  - `gimp-image-get-active-drawable` doesn't exist — keep the layer reference from when you created/inserted it instead
  - `gimp-image-width`/`gimp-image-height` → `gimp-image-get-width`/`gimp-image-get-height`
  - `gimp-layer-new`'s argument order is `(image name width height type opacity mode)` — name comes right after image, not after width/height
  - When unsure whether a name exists, the error tells you: "unbound variable" = doesn't exist; "Invalid value for argument N" = exists, wrong argument
- **`file-glob` only matches with backslash-style Windows paths** —
  `D:/foo/*.xcf` silently returns zero matches, `D:\foo\*.xcf` works. Every
  other file API tested here (`gimp-file-load`, `gimp-xcf-save`,
  `file-bmp-export`) is fine with forward slashes; `file-glob` alone wants
  backslashes.
- **`(car (file-glob pattern 1))` is the files list directly in 3.x** —
  there's no separate leading file-count element like 2.10's docs describe.
- **`strbreakup` does not split on a backslash separator** — it silently
  returns the whole string as one element. Don't use it for splitting
  Windows paths; walk the string manually with `string-ref` instead (see
  `last-index-of` in `scripts/gimp/export-bitmaps.scm`).
- **A literal `"\\"` backslash escape inside a `-b` command-line string
  gets eaten to nothing** (an extra unescaping layer GIMP's own
  command-line argument parsing applies, on top of the Scheme reader) —
  but the exact same `"\\"` inside a `.scm` **file** loaded via `load`
  works correctly and gives one real backslash. Only matters when
  hand-testing snippets on the command line; files are unaffected.
- **`gimp-drawable-edit-fill` on an EMPTY selection fills the ENTIRE
  drawable**, not nothing — GIMP's "no active selection = everything
  selected" convention applies here too. When doing exact-color
  substitution in a loop (select-color for color X, fill with color Y,
  repeat for the next color), you MUST check
  `(= (car (gimp-selection-bounds image)) 1)` before filling, or a
  no-match iteration silently overwrites every pixel already correctly
  recolored by an earlier iteration in the same loop. This was a real bug
  caught by testing `export-bitmaps.scm` end-to-end against real pixels,
  not something guessable from the API alone.
- Given all of the above, **CLAUDE.md's "GIMP 2.10+" target should be
  read as "2.10 or 3.x, but verify batch-mode scripts against whichever is
  actually installed"** — the GUI workflow (Script-Fu console, manual
  painting) is unaffected, but the automation scripts are 3.x-specific
  where noted in their own headers.

### SecureUxTheme Notes
- Installs as a boot-level patch
- Must be run as Administrator
- Reboot required after patching before custom themes will load
- [ ] Add any other notes during Phase 1

---

## Useful External Resources

| Resource | URL | What it covers |
|---|---|---|
| DeviantArt Windows Customization | deviantart.com/tag/windows11 | Reference themes + community |
| Seven Forums Themes section | sevenforums.com/customization | Older but lots of .msstyles technique info |
| Resource Hacker docs | angusj.com/resourcehacker | Official documentation |
| SecureUxTheme GitHub | github.com/namazso/SecureUxTheme | Patcher source + instructions |
| VirtualBox Win11 guide | virtualbox.org/wiki/Windows11 | VM-specific setup notes |
| Freesound.org | freesound.org | Royalty-free .wav files for sound scheme |
| RealWorld Cursor Editor | rw-designer.com | Cursor creation tool |

---

## Phase 1 Exit Checklist

Before moving to Phase 2, confirm all of these:

- [ ] aero.msstyles fully explored — at least 10 BITMAP IDs recorded above
- [ ] At least 2 reference themes opened and studied in Resource Hacker
- [ ] String table color locations identified
- [ ] MEMORY.md component map resource ID column started
- [ ] GIMP export workflow tested (made a test BMP, imported it, confirmed it didn't break the VM)
- [ ] VM applies a theme from the shared folder without manual copy steps
