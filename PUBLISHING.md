# Publishing Guide

All platform copy, templates, and checklists for the release.
Write and refine these during Phase 6 so publishing day is copy-paste, not writing.

---

## Theme Name & Tagline

> Decide before publishing. Used consistently across all platforms.

```
Name:      [YOUR THEME NAME]
Tagline:   [One line — what makes this theme distinctive]
Version:   v1.0
Author:    [Your name / handle]
License:   MIT (or your choice)
```

**Tagline examples to riff on:**
- "Three moods. One design system."
- "The Windows 11 theme for people who care about their workspace."
- "Dark. Light. Colorful. Actually finished."

---

## DeviantArt Submission

### Checklist

- [ ] Account created / logged in
- [ ] Screenshots prepared (minimum 5, see docs/TESTING.md screenshot protocol)
- [ ] Cover image prepared: `docs/screenshots/all_three_variants.png` — side by side, 1920×1080
- [ ] Download link ready (GitHub Release URL)
- [ ] Description written (see template below)
- [ ] Tags prepared (see tag list below)

### Description Template

```
[THEME NAME] — Windows 11 Theme (Dark · Light · Colorful)

[YOUR TAGLINE HERE]

─────────────────────────────────────────
VARIANTS
─────────────────────────────────────────
■ Dark       — [2-sentence mood description from VISION.md]
■ Light      — [2-sentence mood description from VISION.md]
■ Colorful   — [2-sentence mood description from VISION.md]

─────────────────────────────────────────
WHAT'S INCLUDED
─────────────────────────────────────────
✔ 3 × custom .msstyles visual styles
✔ 3 × .theme configuration files
✔ 12 × 4K wallpapers (4 per variant, 3840×2160)
✔ Custom cursor pack (14 cursors)
✔ Sound scheme (optional)
✔ Full installation guide

─────────────────────────────────────────
REQUIREMENTS
─────────────────────────────────────────
• Windows 11 (22H2 or later)
• SecureUxTheme patcher (free, link below)
  → github.com/namazso/SecureUxTheme

─────────────────────────────────────────
INSTALLATION
─────────────────────────────────────────
Full step-by-step guide included in the download (INSTALL.txt).
Short version:
1. Install & run SecureUxTheme patcher, reboot
2. Extract the download to C:\Windows\Resources\Themes\
3. Double-click the .theme file for your chosen variant
4. Done

─────────────────────────────────────────
DOWNLOAD
─────────────────────────────────────────
→ [GitHub Release URL]

─────────────────────────────────────────
ISSUES / FEEDBACK
─────────────────────────────────────────
Found a bug? Open an issue on GitHub:
→ [GitHub Issues URL]
Or comment below — I read everything.

─────────────────────────────────────────

If you use this theme, I'd love to see your desktop.
Post a screenshot and tag me / link back here.

─────────────────────────────────────────
CREDITS
─────────────────────────────────────────
Built with Resource Hacker, GIMP, and Figma.
[Any credits for inspiration or reference themes you studied]
```

### DeviantArt Tags

```
windows11 msstyles theme windowstheme windowscustomization
darktheme lighttheme customization desktop desktoppersonalization
themepack visualstyle windows11theme colorfultheme
```

---

## GitHub Repository

### README.md Template

> Ask Claude: "Write the GitHub README for this theme using PUBLISHING.md and MEMORY.md"
> The README should include: screenshots, features, requirements, install steps, screenshots section, license.

```markdown
# [THEME NAME]

> [TAGLINE]

![Cover](docs/screenshots/all_three_variants.png)

Three custom Windows 11 visual styles — Dark, Light, and Colorful —
built from scratch with free tools.

## Variants

| Dark | Light | Colorful |
|:---:|:---:|:---:|
| ![dark](docs/screenshots/dark_desktop.png) | ![light](docs/screenshots/light_desktop.png) | ![colorful](docs/screenshots/colorful_desktop.png) |

## What's Included

- 3 × `.msstyles` visual style files
- 3 × `.theme` configuration files
- 12 × 4K wallpapers (4 per variant)
- Custom cursor pack
- Sound scheme (optional)
- Installation guide

## Requirements

- Windows 11 22H2 or later
- [SecureUxTheme](https://github.com/namazso/SecureUxTheme) (free patcher)

## Installation

1. Download and run [SecureUxTheme](https://github.com/namazso/SecureUxTheme), reboot
2. Download the latest release below
3. Extract the zip to `C:\Windows\Resources\Themes\`
4. Double-click the `.theme` file for your chosen variant

See `INSTALL.txt` in the download for full step-by-step instructions.

## Download

**[→ Latest Release](../../releases/latest)**

## Issues

Found a bug? [Open an issue](../../issues) — please include your Windows version,
which variant you applied, and a screenshot.

## License

MIT — free to use, modify, share. Credit appreciated.
```

### Release Checklist

- [ ] Create GitHub repo (public)
- [ ] Push all commits
- [ ] Add `README.md`
- [ ] Add `LICENSE` file
- [ ] Go to Releases → "Create a new release"
- [ ] Tag: `v1.0`
- [ ] Title: `[Theme Name] v1.0`
- [ ] Attach: `MyTheme_v1.0.zip`
- [ ] Write release notes (see template below)
- [ ] Publish release

### Release Notes Template

```markdown
## [Theme Name] v1.0

Initial release.

### What's new
- Dark variant
- Light variant  
- Colorful variant
- 4K wallpaper set (12 images)
- Custom cursor pack
- Sound scheme

### Requirements
- Windows 11 22H2+
- SecureUxTheme patcher

### Known issues
- [List any known visual glitches before release if any]
```

---

## Reddit Posts

### r/windowscustomization

**Post type:** Link (to DeviantArt) with a screenshot image

```
Title: [Theme Name] — Windows 11 theme with Dark, Light & Colorful variants [OC]

Body:
Built this over the past [X weeks] using Resource Hacker and GIMP.
Three full visual styles, each with 4K wallpapers and a custom cursor pack.

[Brief sentence about the Dark variant aesthetic]
[Brief sentence about the Light variant aesthetic]
[Brief sentence about the Colorful variant aesthetic]

Free download on DeviantArt (link in comments) — requires SecureUxTheme patcher.
Happy to answer questions about the process.
```

**Comment 1 (post right after):**
```
Download: [DeviantArt link]
GitHub: [GitHub link]
```

### r/desktops

**Post type:** Image post (best single screenshot — probably Dark variant desktop)

```
Title: My custom Windows 11 theme — [Theme Name]

Body:
Dark variant of [Theme Name], a Windows 11 .msstyles theme I've been working on.
Also has Light and Colorful variants. Free download in comments.
```

**Comment 1:**
```
Theme: [Theme Name] (my own, free) → [DeviantArt link]
Wallpaper: [wallpaper name/source]
```

---

## Post-Launch Checklist

- [ ] Monitor DeviantArt comments for bug reports
- [ ] Monitor GitHub Issues
- [ ] Reply to Reddit comments
- [ ] Update CHANGELOG.md with v1.0 release date
- [ ] If bugs found: patch and release v1.1 within 2 weeks
- [ ] Announce v1.1 as a comment on the original DeviantArt post
