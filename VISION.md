# Win11 Theme — Vision & Design Direction

The creative bible. Read this when you're six weeks in and losing the thread.
Every pixel decision should trace back to something written here.

---

## The Premise

Windows 11 ships with one theme and calls it done. This theme starts
from the assumption that the operating system is a space people live in —
and like any space, it should have a character. Not decoration on top of
function, but a coherent visual language where every surface, border, and
control feel like they belong to the same world.

Three variants, three moods. One design system underneath all of them.

---

## Variant Visions

### Dark — "Midnight Infrastructure"

**Feeling:** The calm of working late. Deep focus. Purposeful.

**The world it evokes:** A city seen from altitude at night. Server rooms.
Terminal windows glowing in a dark studio. The UI recedes so your work
comes forward.

**Visual rules:**
- Surfaces get darker as they go further back, lighter as they come
  forward. Depth through value, not shadow.
- Borders are structural, not decorative — thin, just bright enough
  to separate, never to draw attention.
- The accent (Windows blue) is used sparingly. One pop per area.
  When everything is an accent, nothing is.
- Text is never pure white. Slightly cool, slightly muted.
  Pure white reads as a mistake on dark surfaces.
- Zero gradients on interactive controls. Flat, with state changes
  handled purely through value shifts. Gradients are reserved for
  the title bar only if used at all.

**What to avoid:**
- Teal. Don't drift toward teal.
- Glows or bloom effects on UI chrome. That's wallpaper territory.
- Rounded corners that feel like a different OS. Keep the Windows
  geometry — this is a Windows theme, not a Mac emulator.

---

### Light — "Morning Clarity"

**Feeling:** Clean start. Focused. Room to breathe.

**The world it evokes:** An overcast morning through a large window.
Paper on a desk. The anti-clutter. A workspace cleared before starting.

**Visual rules:**
- Backgrounds are not white. They're the faintest cool blue-grey —
  enough to make white surfaces pop without feeling clinical.
- Elevation reads as slight warmth: surfaces lift slightly toward
  warm white, not pure white.
- Borders are nearly invisible. Surfaces define themselves through
  their subtle difference in tone, not through lines.
- Accent is slightly darker here than in Dark — same blue family,
  shifted for legibility on light backgrounds.
- Shadows are ultra-light. Almost not there.
- Nothing competes with the content. If you're not sure whether
  an element should show, it shouldn't.

**What to avoid:**
- Cream or warm white backgrounds. This is cool, not warm.
- Heavy drop shadows that feel like skeuomorphism.
- Making it look like macOS. The geometry stays Windows.

---

### Colorful — "Signal"

**Feeling:** Energy. Expressive. Unapologetically itself.

**The world it evokes:** A DJ booth. A neon-lit arcade. A creative studio
that doesn't apologize for its aesthetic. This is the variant people
screenshot and post.

**Visual rules:**
- Purple is the ground. Everything lives on purple — it's not an accent,
  it's the world.
- The gradient on the title bar is the signature move: `#7928ca` → `#e84393`.
  This is the one place the design shouts.
- The accent is warm orange (`#ff6b35`) — the complement of purple.
  It appears on interactive elements and highlights only.
- Text on purple surfaces goes lavender-white, not pure white.
  Pure white on purple vibrates uncomfortably at small sizes.
- Every other surface is restrained — the gradient does the work,
  controls stay quiet.
- Saturation drops as you get further from the title bar. The deeper
  you go into the UI, the more it settles. The title bar is the loudest
  thing; dialogs are nearly as dark as the Dark variant.

**What to avoid:**
- Rainbow / multi-color accents. One warm accent, full stop.
- Neon green. Stay in the purple-pink-orange family.
- Making every surface colorful. The title bar earns attention
  because everything else doesn't fight it.

---

## Cross-Variant Rules (apply to all three)

These hold regardless of which variant you're working on:

1. **State changes are value shifts, not color changes.**
   Hover → slightly lighter. Pressed → slightly darker. Disabled → muted.
   Don't change hue on hover.

2. **Borders at 1px only.** Never thicker. If you need more definition,
   change the surface value, not the border weight.

3. **The taskbar is flat.** No gradient, no texture, no shadow from the
   desktop into the taskbar. It's a surface, not a panel.

4. **Title bar buttons follow the surface.** Close button turns red on
   hover only. Min/Max stay within the variant's value range.
   Don't import foreign accent colors into the button states.

5. **Scrollbars are invisible at rest.** Visible only on hover.
   The thumb is the accent color at 30% opacity at rest,
   60% on hover. (Implement via bitmap states.)

6. **Menu separators are 1px at 15% opacity of the text color.**
   Barely there.

7. **Progress bars fill with the accent. Tracks are the surface-2 tone.**
   No animation in the .msstyles itself — Windows handles the animation.

---

## What Makes This Theme "Done"

A theme is complete when you can spend a full workday inside it without
once noticing the UI. It disappears. The work is what you see.
Any element that draws attention to itself when it shouldn't is unfinished.

---

## Reference Points

These are mood references, not things to copy:

- **Dark:** Arc theme for Linux (the original dark ambiance), Windows Terminal dark defaults
- **Light:** Things 3 for Mac (surface hierarchy without lines), Notion light mode
- **Colorful:** arc-dark-gtk with purple, Spotify's old dark purple era, Notion's gradient covers

---

## What This Theme Is Not

- Not a macOS clone
- Not a Material Design port
- Not an anime theme (despite the Colorful variant's energy)
- Not a "glass" theme (no heavy acrylic/blur — that's a separate technique)
- Not trying to fix Windows 11 — trying to give it a distinct personality it ships without
