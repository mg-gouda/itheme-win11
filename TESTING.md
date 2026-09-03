# Testing Protocol

A systematic approach to QA on the VM. Follow this every time you apply a new build.
Don't eyeball it — go through the checklist. That's how shipping themes with zero
bug reports actually happens.

---

## VM Setup for Testing

```
OS:          Windows 11 (clean install, no customizations)
RAM:         4GB minimum allocated to VM
Display:     Set VM display to 1920×1080
DPI:         100% scaling (96 DPI) — test at 125% scaling too
Patched:     SecureUxTheme applied, VM rebooted
Shared:      VirtualBox shared folder → /theme-files/ mapped as Z:\
```

---

## How to Apply the Theme for Testing

```powershell
# From inside the VM:
# 1. Navigate to Z:\dark\ (or light\, colorful\)
# 2. Double-click MyTheme_Dark.theme
# 3. Windows will prompt to apply — confirm
# 4. Wait for theme to fully apply (taskbar may flash once)
# 5. Begin testing protocol below
```

---

## Testing Checklist

Run through this after every significant build change.
Annotate with the date and build number when you run it.

**Build:** `___________`  **Date:** `___________`  **Variant:** `Dark / Light / Colorful`

---

### 1. Desktop

- [ ] Wallpaper loads correctly (correct variant)
- [ ] Desktop icons readable — text visible against wallpaper
- [ ] No tearing or graphical artifacts on desktop
- [ ] Right-click on desktop → context menu: background correct
- [ ] Context menu text readable
- [ ] Context menu highlight visible and correct color
- [ ] Context menu separator visible but subtle

---

### 2. Taskbar

- [ ] Taskbar background correct color/surface
- [ ] Start button visible and responds to hover
- [ ] Search bar (if visible) styled correctly
- [ ] Clock and system tray area — text readable
- [ ] Notification center icon visible
- [ ] Open an app → taskbar button appears, styling correct
- [ ] Hover over taskbar button → hover state correct
- [ ] Taskbar button for active window looks distinct from inactive

---

### 3. Window Chrome (open Notepad for this section)

- [ ] Title bar — active window — correct color
- [ ] Title bar — click another window — inactive color changes correctly
- [ ] Title bar text readable in both active and inactive states
- [ ] Close button (X) — normal state correct
- [ ] Close button — hover state turns red ✓ (Windows handles this but verify)
- [ ] Minimize button — hover state correct
- [ ] Maximize button — hover state correct
- [ ] Window border visible and correct weight (1px)
- [ ] Window border color correct for active window
- [ ] Window border color changes when window loses focus
- [ ] Resize the window — border handles visible during resize
- [ ] Maximize the window — title bar still correct
- [ ] Restore the window — title bar reverts correctly

---

### 4. Scrollbars (open a long document or webpage in Edge)

- [ ] Vertical scrollbar track — correct background
- [ ] Vertical scrollbar thumb — correct color at rest
- [ ] Hover over scrollbar → thumb changes state
- [ ] Scrollbar arrows visible
- [ ] Horizontal scrollbar — same checks
- [ ] Scrollbar works functionally (not just visual)
- [ ] Scrollbar disappears / fades at rest if implemented that way

---

### 5. Buttons & Controls (open Control Panel → System)

- [ ] Button normal state — correct surface and border
- [ ] Button hover state — visibly different from normal
- [ ] Button pressed state — visibly different from hover
- [ ] Button text readable in all states
- [ ] Default button (blue/accent) — correct
- [ ] Disabled button — muted correctly, not just greyed
- [ ] Tab controls — active vs inactive tab distinct
- [ ] Group box borders visible

---

### 6. Form Controls (open Settings → Personalization)

- [ ] Checkbox unchecked — visible border
- [ ] Checkbox checked — checkmark and fill correct
- [ ] Checkbox hover state — correct
- [ ] Radio button off — correct
- [ ] Radio button on — correct
- [ ] Progress bar (run Windows Update or similar to trigger) — track and fill correct
- [ ] Text input field — border correct
- [ ] Text input focused — focus state visible
- [ ] Dropdown / combo box — correct styling

---

### 7. Menus (open any app menu bar — try Paint or Notepad)

- [ ] Menu bar background correct
- [ ] Menu item text readable
- [ ] Menu item hover/highlight correct
- [ ] Submenu arrow visible and correct
- [ ] Separator between menu groups subtle but visible
- [ ] Keyboard shortcut text (Ctrl+S) readable alongside menu item
- [ ] Disabled menu item text visibly different from enabled

---

### 8. File Explorer

- [ ] Navigation pane (left sidebar) background correct
- [ ] Selected item in sidebar highlighted correctly
- [ ] Main content area (file grid) background correct
- [ ] File name text readable
- [ ] Address bar background and text correct
- [ ] Search bar visible and correctly styled
- [ ] Toolbar (ribbon or compact bar) background correct
- [ ] Folder icons visible (if using default icons, confirm no conflicts)
- [ ] Context menu from right-click in Explorer → (re-run section 1 checks)

---

### 9. Dialogs (trigger via File → Save As in Notepad)

- [ ] Dialog background correct
- [ ] Dialog title bar correct (active state)
- [ ] Dialog text readable
- [ ] OK / Cancel buttons correct
- [ ] File name input field correct
- [ ] File type dropdown correct

---

### 10. Multi-Window Test

- [ ] Open 3 windows — Notepad, File Explorer, Settings
- [ ] Click between them — active/inactive title bars change correctly on all three
- [ ] Overlapping windows — no visual glitches at window edges
- [ ] Alt+Tab switcher — thumbnail cards visible

---

### 11. DPI / Scaling Test

- [ ] Go to Settings → Display → Scale
- [ ] Change to 125% → apply → observe theme
- [ ] Check for bitmap blur or misalignment at 125%
- [ ] Check title bar buttons still aligned at 125%
- [ ] Return to 100%

---

### 12. Edge Cases

- [ ] Apply the theme, then switch to Windows default theme, then re-apply your theme — no artifacts
- [ ] Open Task Manager — styled correctly (or acceptably unstyled)
- [ ] Open Calculator — check window chrome
- [ ] Open Edge browser — check window chrome and any themed controls

---

## Bug Recording Format

If you find a visual bug, record it here before fixing:

```
Bug #001
Date:      [DATE]
Variant:   [Dark / Light / Colorful]
Severity:  [Visual glitch / Incorrect color / Crash / Unreadable text]
Location:  [Component name, e.g. "Title bar inactive state"]
Steps:     [How to reproduce]
Expected:  [What it should look like]
Actual:    [What it actually looks like]
Resource:  [Which resource ID is responsible, if known]
Fixed:     [Date fixed]
```

---

## Screenshot Protocol

After a clean passing test, take these screenshots for the docs/screenshots/ folder:

```
Resolution:  1920×1080 (set VM display to this)
Format:      PNG
Tool:        Windows Snipping Tool or PrtScn

Required shots per variant:
1. Full desktop — wallpaper + taskbar + clean desktop
2. Notepad open — shows title bar + window chrome + scrollbar
3. File Explorer open — navigation pane + content area
4. Right-click context menu on desktop
5. Settings window — shows controls (checkboxes, buttons, dropdowns)
6. (Bonus) All 3 windows open, overlapping — shows depth
```
