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

> Discovered during Phase 1 exploration (2026-09-10, Windows 11 25H2, build
> 10.0.26200.8037). **This is the modern Vista+ theme engine format, not the
> classic Win9x/XP BITMAP-resource format this doc originally assumed** — see
> "IMPORTANT: theme format reality check" below before doing anything else.

### Resource Types Found (actual tree in Resource Hacker)

| Type | Count | Description |
|---|---|---|
| AMAP | 1 | Alpha map — likely opacity/blend table |
| BCMAP | ? | Border/color map (not yet explored) |
| CMAP | ? | Color map (not yet explored) |
| DESKTOP | ? | Desktop-related settings (not yet explored) |
| IMAGE | 1611 | The actual PNG bitmaps. IDs run 508–2125 (with gaps), all sub-ID 1033 (LANGID for en-US) |
| IMMERSIVE | 1 | Single UCS-2/binary resource — modern Fluent/WinUI theming data (see below) |
| MINCOLORDEPTH | 1 | Minimum color depth requirement |
| MUI | ? | Localized strings (not yet explored) |
| PACKTHEM_VERSION | ? | Theme package version metadata |
| PVL | ? | Not yet explored |
| RMAP | ? | Resource map — likely PART/STATE → IMAGE ID lookup (not yet explored) |
| STREAM | ? | Binary theme definition data — the actual "compiled style". Not human-readable in Resource Hacker; this is where PART/STATE really gets tied to IMAGE IDs |
| VARIANT | ? | Color/size variant definitions |
| VMAP | ? | Not yet explored |
| Version Info | 1 | Standard PE version resource |

**No `BITMAP` or `String Table` resource types exist in this file at all.**
Everything visual is a PNG under `IMAGE`. Color strings (`ActiveTitle`,
`ButtonFace`, etc.) live in the `.theme` INI file instead, not inside the
`.msstyles` binary — that part of the original plan is correct.

---

## IMPORTANT: theme format reality check

Windows 11's `aero.msstyles` is **not** simple "one bitmap per UI element"
like classic visual styles. Sampled ~25 of the 1611 `IMAGE` entries by paging
through Resource Hacker (IDs 508 through 2125):

- Low IDs (508–650ish): checkbox / radio button / expander-arrow sprite
  sheets — multiple states stacked vertically in one PNG (e.g. ID 508 is a
  13×260 PNG containing unchecked/checked/indeterminate/hover states for a
  checkbox). **These are genuinely swappable, matches the original plan.**
- Mid-to-high IDs (1000+): shrink down to small glyphs (chevrons, arrows,
  9×15px dropdown indicators) and eventually to **1×1 and 2×1 pixel PNGs** —
  these are solid-color fill swatches, not graphics.
- **No large title-bar-sized or window-border-sized bitmaps were found
  anywhere in the sampled range.** Classic Aero glass (Vista/7) rendered
  title bars from big pre-drawn bitmaps; Windows 11 does not work that way.

**What this means:** window chrome (title bar, window border, the colored
strip behind the caption buttons) is composited by DWM at runtime from
accent-color settings and the `IMMERSIVE` resource (modern Fluent theming
data, serialized as UCS-2/binary — not a simple bitmap or readable XML in
Resource Hacker's text view), not from a paintable bitmap image the way
`ASSETS.md`'s `title-bar-active.xcf` / `window-border-active.xcf` entries
assume. Recoloring the title bar almost certainly means editing small
fill-color swatches and/or `.theme` `[Colors]` values and DWM accent
settings, **not** drawing a custom 800×30 title bar graphic in GIMP.

**Tool note:** [msstyleEditor](https://github.com/nptr/msstyleEditor)
(community tool, MIT, supports Vista–11) fails to open this exact file with
`Error loading style! ... Style contains no class map!` — likely a version
mismatch between the tool (last release tag `2.1.2.0`) and this Windows 11
25H2 build's compiled style format. Installed at
`C:\Users\Gouda\Tools\msstyleEditor\` in the VM in case a future version
fixes this — worth retrying if the tool gets updated.

**Before starting Phase 3 (Base Theme Build), re-scope which elements are
realistically bitmap-editable** (checkboxes, radio buttons, scrollbar
thumbs/arrows, button states, menu separators/arrows — all confirmed as
swappable sprite sheets) **vs. which need a DWM/accent-color/fill-swatch
approach instead** (title bar, window border, taskbar background). This
probably means revising `ASSETS.md`'s asset list before Phase 3, not just
filling in IDs for what's already listed there.

---

## IMAGE Resource IDs Discovered

> Renamed from "Bitmap Resource IDs" — the resource type is `IMAGE` (PNG),
> not `BITMAP`, in this file. All entries below are sub-ID 1033.
> Found by paging through Resource Hacker's IMAGE tree (508–2125), not an
> exhaustive scan — only ~25 of 1611 entries sampled so far. Each sprite
> sheet holds multiple states stacked vertically (normal/hover/pressed/etc.)
> in one PNG, not separate images per state.

| Resource ID | What it is | Dimensions | Notes |
|---|---|---|---|
| 508 | Checkbox states sprite sheet | 13×260 PNG | unchecked/checked/indeterminate + hover variants, 20px per state |
| 509 | Checkbox states, alt size/DPI variant | 16×320 PNG | 10 states stacked |
| 527 | Radio button states sprite sheet | 13×104 PNG | off/hover/on (blue filled) variants, 8 states |
| 545 | Right-arrow / expander indicator | 40×200 PNG | 5 states (normal/hover/disabled/pressed/focused) |
| 563 | Checkbox states, dark-theme color variant | 20×400 PNG | 20 states — confirms multiple color variants ship in one file |
| 653 | Divider / separator line | 3×72 PNG | thin vertical rule, likely toolbar or menu separator |
| 743 | Double-chevron dropdown indicator | 9×15 PNG | small "more options" style glyph |
| 1013 | Down-chevron | 24×26 PNG | |
| 1377 | Solid-color fill swatch | 2×1 PNG | not a graphic — a tintable fill color |
| 1830 | Solid-color fill swatch | 1×1 PNG | same pattern as 1377, further into the ID range |

**Not yet found/identified:** title bar, window border, close/min/max
buttons, scrollbar track/thumb/arrows, push button states, progress bar,
menu background/highlight, taskbar background. Per the "theme format
reality check" above, some of these (title bar, window border, taskbar)
may not exist as large bitmaps at all — needs the STREAM/RMAP data decoded
or a working class-map tool to confirm rather than more manual paging.

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
- File → Open dialog remembers the last-browsed folder, so it lands back in
  `aero`'s theme folder on subsequent opens — convenient for re-opening
  after a crash/restart.
- Selecting an IMAGE entry shows exact PNG dimensions and format in the
  status bar at the bottom (e.g. "13 x 260 PNG") — no need to export just
  to check size.
- BMP export format note (`GIMP Notes` below) doesn't actually apply to this
  file — see the "theme format reality check" section above. This file's
  images are PNG, not BMP.
- Launching `ResourceHacker.exe "<path>"` from the command line does **not**
  reliably auto-open the file in this build — had to use File → Open every
  time. Worth knowing if scripting VM automation around it.

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
