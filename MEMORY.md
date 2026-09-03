# Win11 Theme — Project Memory

Persistent design decisions, color specs, and component map.
Update this file as decisions are finalized. Claude reads this every session.

---

## Theme Identity

| Field | Value |
|---|---|
| Theme name | `MyTheme` (rename before publishing) |
| Target OS | Windows 11 22H2+ |
| Variants | Dark · Light · Colorful |
| Distribution | DeviantArt + GitHub Releases |
| License | To be decided (MIT recommended for open source) |
| Version | v0.1.0 (in development) |

---

## Color System

### Naming Convention
Each palette uses the same token names — only values differ per variant.
Tokens map directly to what gets edited in Resource Hacker color strings and .theme [Colors].

---

### Dark Variant

> Status: **Draft — adjust to taste in Figma before locking**

| Token | Hex | RGB | Used for |
|---|---|---|---|
| `bg` | `#0c0f1a` | 12 15 26 | Desktop background |
| `surface-0` | `#141828` | 20 24 40 | Window backgrounds |
| `surface-1` | `#1c2336` | 28 35 54 | Elevated surfaces, menus |
| `surface-2` | `#232a44` | 35 42 68 | Hover states, selected items |
| `border` | `#2b3258` | 43 50 88 | Window frames, dividers |
| `border-soft` | `#1d2340` | 29 35 64 | Subtle separators |
| `title-active` | `#181d32` | 24 29 50 | Active window title bar |
| `title-inactive` | `#10131e` | 16 19 30 | Inactive window title bar |
| `title-text` | `#edf0f8` | 237 240 248 | Title bar button text |
| `accent` | `#0078d4` | 0 120 212 | Windows accent (keep default or override) |
| `accent-hover` | `#1084d8` | 16 132 216 | Accent hover state |
| `text-primary` | `#edf0f8` | 237 240 248 | Primary readable text |
| `text-secondary` | `#8b95b6` | 139 149 182 | Secondary / descriptions |
| `text-disabled` | `#4a5272` | 74 82 114 | Disabled controls |
| `scrollbar-bg` | `#141828` | 20 24 40 | Scrollbar track |
| `scrollbar-thumb` | `#2b3258` | 43 50 88 | Scrollbar handle |
| `button-face` | `#1c2336` | 28 35 54 | Button backgrounds |
| `highlight` | `#0078d4` | 0 120 212 | Selection highlight |
| `highlight-text` | `#ffffff` | 255 255 255 | Text on highlight |

---

### Light Variant

> Status: **Draft**

| Token | Hex | RGB | Used for |
|---|---|---|---|
| `bg` | `#f0f3fa` | 240 243 250 | Desktop background |
| `surface-0` | `#ffffff` | 255 255 255 | Window backgrounds |
| `surface-1` | `#f4f7fd` | 244 247 253 | Menus, dropdowns |
| `surface-2` | `#eaecf8` | 234 236 248 | Hover, selected |
| `border` | `#d2d8ef` | 210 216 239 | Window frames |
| `border-soft` | `#e2e6f4` | 226 230 244 | Subtle separators |
| `title-active` | `#e8edf8` | 232 237 248 | Active title bar |
| `title-inactive` | `#f2f4fa` | 242 244 250 | Inactive title bar |
| `title-text` | `#0c1025` | 12 16 37 | Title bar text |
| `accent` | `#0067c0` | 0 103 192 | Accent (slightly darker for light bg) |
| `text-primary` | `#0c1025` | 12 16 37 | Primary text |
| `text-secondary` | `#404878` | 64 72 120 | Secondary text |
| `text-disabled` | `#909ab8` | 144 154 184 | Disabled |
| `scrollbar-bg` | `#f0f3fa` | 240 243 250 | Scrollbar track |
| `scrollbar-thumb` | `#c0c8e0` | 192 200 224 | Scrollbar handle |
| `button-face` | `#f4f7fd` | 244 247 253 | Buttons |
| `highlight` | `#0067c0` | 0 103 192 | Selection |
| `highlight-text` | `#ffffff` | 255 255 255 | Text on highlight |

---

### Colorful Variant

> Status: **Draft — this palette is intentionally bold**

| Token | Hex | RGB | Used for |
|---|---|---|---|
| `bg` | `#14082a` | 20 8 42 | Desktop background |
| `surface-0` | `#1e0d3d` | 30 13 61 | Window backgrounds |
| `surface-1` | `#2a1452` | 42 20 82 | Menus |
| `surface-2` | `#361b68` | 54 27 104 | Hover, selected |
| `border` | `#5c2490` | 92 36 144 | Window frames |
| `border-soft` | `#3d1870` | 61 24 112 | Subtle dividers |
| `title-active` | gradient | — | Title bar: `#7928ca` → `#e84393` (gradient bitmap) |
| `title-inactive` | `#2a1452` | 42 20 82 | Inactive title bar |
| `title-text` | `#f0e8ff` | 240 232 255 | Title bar text |
| `accent` | `#ff6b35` | 255 107 53 | Accent — warm orange against purple |
| `accent-hover` | `#ff8255` | 255 130 85 | Accent hover |
| `text-primary` | `#f0e8ff` | 240 232 255 | Primary text |
| `text-secondary` | `#c4a8f0` | 196 168 240 | Secondary |
| `text-disabled` | `#7055a8` | 112 85 168 | Disabled |
| `scrollbar-bg` | `#1e0d3d` | 30 13 61 | Track |
| `scrollbar-thumb` | `#5c2490` | 92 36 144 | Handle |
| `button-face` | `#2a1452` | 42 20 82 | Buttons |
| `highlight` | `#7928ca` | 121 40 202 | Selection |
| `highlight-text` | `#ffffff` | 255 255 255 | Text on highlight |

---

## UI Component Map

> As resource IDs are discovered in Resource Hacker, record them in the `Resource ID` column.
> See also: `docs/mod-log.md` for the live change log.

### Window Chrome

| Component | Bitmap or String | Resource ID | Status | Notes |
|---|---|---|---|---|
| Active title bar background | BITMAP | TBD | Not started | |
| Inactive title bar background | BITMAP | TBD | Not started | |
| Title bar close button | BITMAP | TBD | Not started | Normal + hover + pressed states |
| Title bar minimize button | BITMAP | TBD | Not started | |
| Title bar maximize button | BITMAP | TBD | Not started | |
| Window border (active) | String/BITMAP | TBD | Not started | |
| Window border (inactive) | String | TBD | Not started | |
| Window shadow | BITMAP | TBD | Not started | 32-bit with alpha |

### Taskbar

| Component | Bitmap or String | Resource ID | Status | Notes |
|---|---|---|---|---|
| Taskbar background | BITMAP | TBD | Not started | |
| Start button | BITMAP | TBD | Not started | Normal + hover + pressed |
| Task button (running app) | BITMAP | TBD | Not started | |
| Task button (active app) | BITMAP | TBD | Not started | |
| System tray background | BITMAP | TBD | Not started | |

### Controls

| Component | Bitmap or String | Resource ID | Status | Notes |
|---|---|---|---|---|
| Scrollbar track (vertical) | BITMAP | TBD | Not started | |
| Scrollbar thumb (vertical) | BITMAP | TBD | Not started | |
| Scrollbar track (horizontal) | BITMAP | TBD | Not started | |
| Scrollbar thumb (horizontal) | BITMAP | TBD | Not started | |
| Scrollbar arrow up | BITMAP | TBD | Not started | |
| Scrollbar arrow down | BITMAP | TBD | Not started | |
| Button (normal) | BITMAP | TBD | Not started | |
| Button (hover) | BITMAP | TBD | Not started | |
| Button (pressed) | BITMAP | TBD | Not started | |
| Button (disabled) | BITMAP | TBD | Not started | |
| Checkbox (unchecked) | BITMAP | TBD | Not started | |
| Checkbox (checked) | BITMAP | TBD | Not started | |
| Checkbox (indeterminate) | BITMAP | TBD | Not started | |
| Radio button (off) | BITMAP | TBD | Not started | |
| Radio button (on) | BITMAP | TBD | Not started | |
| Progress bar track | BITMAP | TBD | Not started | |
| Progress bar fill | BITMAP | TBD | Not started | |
| Tooltip background | String | TBD | Not started | |

### Menus & Explorer

| Component | Bitmap or String | Resource ID | Status | Notes |
|---|---|---|---|---|
| Context menu background | BITMAP/String | TBD | Not started | |
| Context menu separator | BITMAP | TBD | Not started | |
| Context menu highlight | BITMAP/String | TBD | Not started | |
| Menu bar background | BITMAP | TBD | Not started | |
| Explorer address bar | BITMAP | TBD | Not started | |
| Explorer sidebar | BITMAP/String | TBD | Not started | |
| Tab (active) | BITMAP | TBD | Not started | |
| Tab (inactive) | BITMAP | TBD | Not started | |

### Dialog Boxes

| Component | Bitmap or String | Resource ID | Status | Notes |
|---|---|---|---|---|
| Dialog background | String | TBD | Not started | |
| Group box border | BITMAP | TBD | Not started | |
| Text input background | BITMAP/String | TBD | Not started | |
| Text input border | BITMAP | TBD | Not started | |

---

## Bitmap Dimension Reference

> Fill in as you discover these in Resource Hacker

| Component | Width (px) | Height (px) | Bit depth |
|---|---|---|---|
| Active title bar | TBD | TBD | 24-bit |
| Close button | TBD | TBD | 32-bit |
| Scrollbar thumb | TBD | TBD | 24-bit |
| Button normal | TBD | TBD | 24-bit |
| Checkbox unchecked | TBD | TBD | 32-bit |
| Progress bar fill | TBD | TBD | 24-bit |

---

## Wallpaper Specs

- **Format:** JPEG or PNG
- **Resolution:** 3840 × 2160 (4K)
- **Quality:** JPEG 95+ or lossless PNG
- **Count per variant:** 4 minimum
- **Naming:** `dark_1.jpg`, `dark_2.jpg`, `light_1.jpg`, etc.

### Wallpaper Direction
| Variant | Mood | Visual direction |
|---|---|---|
| Dark | Deep space, midnight city, abstract dark gradients | Dark blues/purples, near-black, subtle glow |
| Light | Morning light, clean architecture, soft sky | Whites, cool greys, light blue |
| Colorful | Abstract vibrant, neon energy, bold gradients | Purple-to-pink-to-orange gradients, vivid |

---

## Cursor Pack Spec

Standard Windows cursor set to design:

| Cursor | Filename | Animated? |
|---|---|---|
| Normal select | `Arrow.cur` | No |
| Help select | `Help.cur` | No |
| Background working | `AppStarting.ani` | Yes |
| Busy / loading | `Wait.ani` | Yes |
| Text select | `Beam.cur` | No |
| Precision select | `Cross.cur` | No |
| Link select | `Link.cur` | No |
| Unavailable | `No.cur` | No |
| Vertical resize | `SizeNS.cur` | No |
| Horizontal resize | `SizeWE.cur` | No |
| Diagonal resize 1 | `SizeNWSE.cur` | No |
| Diagonal resize 2 | `SizeNESW.cur` | No |
| Move | `Move.cur` | No |
| Alternate select | `UpArrow.cur` | No |

---

## Decisions Log

> Record design and technical decisions here as they are made.

| Date | Decision | Reason |
|---|---|---|
| Project start | Free route (Resource Hacker) over StyleBuilder | Cost — StyleBuilder is $30 |
| Project start | Dark variant built first | Most distinctive, defines the identity |
| Project start | Three variants: Dark, Light, Colorful | User requirement |
| Project start | Accent color: Windows blue `#0078d4` / `#0067c0` | Familiar, fits Windows conventions |
| Project start | Colorful accent: orange `#ff6b35` | Contrast against purple backgrounds |
