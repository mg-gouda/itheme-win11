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
| DESKTOP | 4 bytes | Tiny flag/metadata, not explored further |
| IMAGE | 1611 | The actual PNG bitmaps. IDs run 508–2125 (with gaps), all sub-ID 1033 (LANGID for en-US) |
| IMMERSIVE | 4 bytes | Tiny flag/version marker — **not** a Fluent/WinUI theming blob (see correction below) |
| MINCOLORDEPTH | 2 bytes | Minimum color depth requirement |
| MUI | 400 bytes | Localized strings — contains resource-type name strings (`AMAP`, `BCMAP`, ...), likely a self-describing schema table |
| PACKTHEM_VERSION | 2 bytes | Theme package version metadata |
| PVL | 4 bytes | Not yet explored, tiny |
| RMAP | 488 bytes | Just metadata strings (`Aero`, `12-xx-2004`) — a version/name stamp, not a lookup table |
| STREAM | 3 resources, ~70–95KB each | **These are large PNG image atlases** (confirmed via `IHDR`/`IDAT` PNG chunk signatures) — not property/definition data. Likely packed multi-element textures, one per size/DPI variant |
| VARIANT | 449KB (`NORMAL`) | **This is the real compiled theme property data** — the binary "class data file" described in Microsoft's own patent (see below). Almost all binary, near-zero readable strings — class/part/state/property IDs are numeric, not string names |
| VMAP | 76 bytes | Variant name list: `Normal`, `NormalSize`, `NormalColor` — matches `.theme`'s `ColorStyle=NormalColor`/`Size=NormalSize` |
| CMAP | 18.7KB | **Class name catalog** — plain UTF-16LE strings, human-readable, extremely informative (see below) |
| AMAP | 41KB | Not yet explored |
| BCMAP | 1.5KB | Not yet explored |
| Version Info | 1 | Standard PE version resource |

**No `BITMAP` or `String Table` resource types exist in this file at all.**
Everything visual is a PNG under `IMAGE`. Color strings (`ActiveTitle`,
`ButtonFace`, etc.) live in the `.theme` INI file instead, not inside the
`.msstyles` binary — that part of the original plan is correct.

**Correction to an earlier note in this file:** an initial pass through this
research (see git history) guessed at what `STREAM`, `RMAP`, and `IMMERSIVE`
contained based on their names alone, and concluded from *visually sampling
25 of 1611 `IMAGE` entries in Resource Hacker* that DWM must be compositing
window chrome from accent color with no msstyles-side bitmap involved at
all. That visual-sampling conclusion is now **superseded** by the extraction
below, which is evidence-based rather than a guess — read on.

---

## Extracting and reading the binary resources directly (not just Resource Hacker)

Rather than continuing to page through 1611 unnamed images by eye, extracted
the raw resource bytes directly using Python's `pefile` library (installed
via `pip install pefile` — `aero.msstyles` is a valid PE file underneath the
custom extension) and searched for embedded strings. Script at
`scratchpad` (not committed — one-off analysis, not project tooling).

**Reference used:** Microsoft's own patent
[US7137066B2](https://patents.google.com/patent/US7137066B2) — "Binary
cache file format for themeing the visual appearance of a computer system"
— describes the exact `.msstyles` compiled binary structure: a header,
class index section, and hierarchical property sections (state → part →
class → global, most-specific-first) made of `property data item` records
(derived property ID, primitive property ID, data length, data). Two
property types matter most here:
- **Imagefile properties**: reference a bitmap via **9-slice/9-grid
  stretching** — "sizing margins" and "content margins" let a *small*
  source image (not necessarily anywhere near the rendered element's full
  size) stretch to fill any width/height. This directly invalidates the
  "no bitmap is wide enough to be a title bar" reasoning from the earlier
  visual-sampling pass — a 9-sliced title bar source image could be as
  small as ~40px wide.
- **Color properties**: plain `R,G,B` triples, used directly or via a
  "sampled colors" optimization table for solid-color elements (this is
  almost certainly what the 1×1/2×1 px PNG "fill swatches" found earlier
  actually are — legitimate solid-fill assets, not junk/leftovers).

### What `CMAP` revealed (the actual breakthrough)

`CMAP` (18.7KB) is almost entirely plain UTF-16LE strings — a **catalog of
every class name** the theme defines, including many namespaced variants.
Extracted and grepped around the window-related entries:

```
14280  Window
14296  DWMWindow
14320  DWMTouch
14344  DWMPen
14360  CompositedWindow::Window
```

**This confirms the DWM theory directly and concretely, with an important
nuance:** window chrome is controlled by dedicated classes named
`DWMWindow` / `CompositedWindow::Window` (plus touch/pen input variants
`DWMTouch`/`DWMPen`) — **separate from** a plain `Window` class. Windows 11
runs DWM composition essentially always, so **the classes that matter for
this project's title bar/window chrome work are `DWMWindow` and
`CompositedWindow::Window`, not `Window`.** These classes almost certainly
have their own Imagefile and/or Color properties per the patent structure
above — meaning **bitmap-based (or simple color-based) title bar theming
is plausible after all**, just under a different, DWM-specific class than
a naive search would find first.

**Second major finding — dark/light mode lives in this same file.** The
class catalog is full of namespaced variants:

```
DarkMode_DarkTheme::Button / TreeView / Link
DarkMode_Explorer::Pause / TreeView
DarkMode::ExplorerNavPane / ReadingPane / Menu / CommonItemsDialog / ProperTree
LightMode_ImmersiveStart::Menu
DarkMode_ImmersiveStart::Menu
ImmersiveStartDark::Menu
```

Windows 11's light/dark mode switching (and the Start menu's Fluent
"Immersive" styling) is **not** a separate mechanism or separate file —
it's the same `aero.msstyles`, with dark-mode-specific class variants
living alongside the light/default ones, distinguished by name prefix.
**This has a real implication for this project's Dark/Light/Colorful
variant plan**: rather than (or possibly in addition to) building three
separate `.msstyles` files, it may be possible/necessary to target the
`DarkMode_*` namespaced classes directly within one file for a proper dark
variant. Needs more investigation before Phase 3 planning locks this down.

### What's still unknown

- The exact byte layout connecting a `CMAP` class-name string to its
  numeric class ID, and from there to the `VARIANT_NORMAL` property
  records and the specific `IMAGE` resource IDs / colors it uses. The
  patent describes the structure at a high level (header → class index →
  hierarchical property sections) but not exact byte offsets — would need
  either a full clean-room parser, or a working alternative to
  `msstyleEditor` that understands this Windows 11 build's exact format.
- Whether `DWMWindow`/`CompositedWindow::Window` use Imagefile (bitmap)
  properties, Color properties, or both for the caption/frame/buttons.

**Practical next step before Phase 3:** don't keep manually paging through
`IMAGE` entries by eye — it's unreliable (already proven wrong once). Try
newer/alternate `.msstyles` editing tools against this exact file, or budget
time for a proper `VARIANT_NORMAL` binary parser using the patent as a
spec. Either would give a direct class name → part → image ID mapping
instead of continued guessing.

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
