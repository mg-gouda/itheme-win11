# Modification Log

Every change made to a .msstyles file goes here.
This is how you replicate the Dark build when creating Light and Colorful variants.
No entry = no audit trail = hours of rework.

**Format:** One row per resource change. Log it the moment you make it.

---

## How to Use This Log

1. Make a change in Resource Hacker (replace a bitmap or edit a string)
2. Immediately add a row to the correct table below
3. Record: the resource type, the ID, what it is, and which variant files it's been applied to
4. When building Light and Colorful, use this log as your checklist — every row in the Dark column should eventually be ticked in Light and Colorful too

---

## BITMAP Changes

| # | Resource ID | Sub-ID | Component | Source file in assets/ | Dark ✅ | Light ✅ | Colorful ✅ | Notes |
|---|---|---|---|---|---|---|---|---|
| 001 | — | 1033 | — | — | ⬜ | ⬜ | ⬜ | (first entry goes here) |

---

## String Table Changes

Color strings in .msstyles are stored as RGB triplets, e.g. `12 15 26`.
Record what you changed each key from and to.

| # | String Table ID | Key name | Original value | Dark value | Light value | Colorful value | Controls |
|---|---|---|---|---|---|---|---|
| 001 | — | — | — | — | — | — | Window background |

---

## INI / Config Changes

Changes to .theme files (not .msstyles):

| # | File | Section | Key | Dark value | Light value | Colorful value |
|---|---|---|---|---|---|---|
| 001 | Dark.theme | Colors | Background | 12 15 26 | 240 243 250 | 20 8 42 |
| 002 | Dark.theme | Colors | ActiveTitle | 24 29 50 | 232 237 248 | — (gradient bitmap) |
| 003 | Dark.theme | Colors | ButtonFace | 28 35 54 | 244 247 253 | 42 20 82 |
| 004 | Dark.theme | Colors | ButtonText | 237 240 248 | 12 16 37 | 240 232 255 |
| 005 | Dark.theme | Colors | GrayText | 74 82 114 | 144 154 184 | 112 85 168 |
| 006 | Dark.theme | Colors | Highlight | 0 120 212 | 0 103 192 | 121 40 202 |
| 007 | Dark.theme | Colors | HighlightText | 255 255 255 | 255 255 255 | 255 255 255 |
| 008 | Dark.theme | Colors | HotTrackingColor | 0 120 212 | 0 103 192 | 255 107 53 |
| 009 | Dark.theme | Colors | InactiveTitle | 16 19 30 | 242 244 250 | 42 20 82 |
| 010 | Dark.theme | Colors | InactiveTitleText | 139 149 182 | 12 16 37 | 196 168 240 |
| 011 | Dark.theme | Colors | InfoWindow | 20 24 43 | 255 255 255 | 42 20 82 |
| 012 | Dark.theme | Colors | InfoText | 237 240 248 | 12 16 37 | 240 232 255 |
| 013 | Dark.theme | Colors | Menu | 20 24 43 | 255 255 255 | 42 20 82 |
| 014 | Dark.theme | Colors | MenuText | 237 240 248 | 12 16 37 | 240 232 255 |
| 015 | Dark.theme | Colors | Scrollbar | 20 24 40 | 240 243 250 | 30 13 61 |
| 016 | Dark.theme | Colors | TitleText | 237 240 248 | 12 16 37 | 240 232 255 |
| 017 | Dark.theme | Colors | Window | 14 18 32 | 255 255 255 | 20 8 42 |
| 018 | Dark.theme | Colors | WindowFrame | 43 50 88 | 210 216 239 | 92 36 144 |
| 019 | Dark.theme | Colors | WindowText | 237 240 248 | 12 16 37 | 240 232 255 |

---

## Reverts

Resources that were changed and then reverted back to default (document these so you don't waste time redoing them):

| # | Resource ID | Why reverted | Date |
|---|---|---|---|
| — | — | — | — |

---

## Known Problematic Resources

Resources that caused unexpected side effects when modified:

| Resource ID | What went wrong | Solution / Workaround |
|---|---|---|
| — | — | — |

---

## Progress Summary

| Variant | Bitmap changes applied | String changes applied | .theme configured |
|---|---|---|---|
| Dark | 0 / TBD | 0 / 19 | ⬜ |
| Light | 0 / TBD | 0 / 19 | ⬜ |
| Colorful | 0 / TBD | 0 / 19 | ⬜ |
