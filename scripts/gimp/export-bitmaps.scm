; Opens every .xcf in assets/source/ and exports three BMP copies — one per
; variant — to assets/dark/, assets/light/, assets/colorful/.
;
; Source .xcf files are authored once, in the Dark palette (MEMORY.md).
; Light/Colorful exports are produced by exact-color substitution using the
; palette tables below — flat fills only (per VISION.md's "zero gradients on
; interactive controls" rule). Gradient bitmaps (e.g. the Colorful title bar)
; are NOT handled by this substitution and must be authored/exported by hand
; per variant — see CLAUDE.md's GIMP export settings.
;
; Requires the palette constants below to be kept in sync with MEMORY.md's
; Color System tables by hand — this script does not read MEMORY.md itself.
;
; Verified against the actual installed GIMP 3.2.4 Script-Fu PDB. Two 3.x
; quirks this accounts for (not present in GIMP 2.10):
;   - file-glob only matches with BACKSLASH-style Windows paths, even though
;     gimp-file-load/gimp-xcf-save/file-bmp-export accept forward slashes.
;   - (car (file-glob pattern 1)) is the files list directly in 3.x —
;     there's no separate leading file-count element like in 2.10.
;
; Load in the Script-Fu console, then call:
;   (export-all-variants)

(define win11-theme-root "D:/Projects/iTheme_Win11")
(define win11-theme-root-bs "D:\\Projects\\iTheme_Win11")

(define (hex->rgb hex)
  ; hex e.g. "0c0f1a" (no leading #)
  (list (string->number (substring hex 0 2) 16)
        (string->number (substring hex 2 4) 16)
        (string->number (substring hex 4 6) 16)))

; token . hex  — keep in sync with MEMORY.md's Color System tables.
; Tokens present on only one side (e.g. accent-hover, or Colorful's
; gradient title-active) are simply omitted from that palette's alist.

(define dark-palette
  (list (cons "bg" "0c0f1a") (cons "surface-0" "141828") (cons "surface-1" "1c2336")
        (cons "surface-2" "232a44") (cons "border" "2b3258") (cons "border-soft" "1d2340")
        (cons "title-active" "181d32") (cons "title-inactive" "10131e") (cons "title-text" "edf0f8")
        (cons "accent" "0078d4") (cons "text-primary" "edf0f8") (cons "text-secondary" "8b95b6")
        (cons "text-disabled" "4a5272") (cons "scrollbar-bg" "141828") (cons "scrollbar-thumb" "2b3258")
        (cons "button-face" "1c2336") (cons "highlight" "0078d4") (cons "highlight-text" "ffffff")))

(define light-palette
  (list (cons "bg" "f0f3fa") (cons "surface-0" "ffffff") (cons "surface-1" "f4f7fd")
        (cons "surface-2" "eaecf8") (cons "border" "d2d8ef") (cons "border-soft" "e2e6f4")
        (cons "title-active" "e8edf8") (cons "title-inactive" "f2f4fa") (cons "title-text" "0c1025")
        (cons "accent" "0067c0") (cons "text-primary" "0c1025") (cons "text-secondary" "404878")
        (cons "text-disabled" "909ab8") (cons "scrollbar-bg" "f0f3fa") (cons "scrollbar-thumb" "c0c8e0")
        (cons "button-face" "f4f7fd") (cons "highlight" "0067c0") (cons "highlight-text" "ffffff")))

(define colorful-palette
  (list (cons "bg" "14082a") (cons "surface-0" "1e0d3d") (cons "surface-1" "2a1452")
        (cons "surface-2" "361b68") (cons "border" "5c2490") (cons "border-soft" "3d1870")
        (cons "title-inactive" "2a1452") (cons "title-text" "f0e8ff")
        (cons "accent" "ff6b35") (cons "text-primary" "f0e8ff") (cons "text-secondary" "c4a8f0")
        (cons "text-disabled" "7055a8") (cons "scrollbar-bg" "1e0d3d") (cons "scrollbar-thumb" "5c2490")
        (cons "button-face" "2a1452") (cons "highlight" "7928ca") (cons "highlight-text" "ffffff")))

(define (rgb-equal? a b)
  (and (= (car a) (car b)) (= (cadr a) (cadr b)) (= (caddr a) (caddr b))))

(define (rgb-in-list? rgb lst)
  (cond ((null? lst) #f)
        ((rgb-equal? rgb (caar lst)) #t)
        (else (rgb-in-list? rgb (cdr lst)))))

(define (build-swap-pairs from-palette to-palette)
  ; (old-rgb . new-rgb) for every token present in both palettes.
  ;
  ; KNOWN LIMITATION: MEMORY.md's Dark palette intentionally reuses the same
  ; hex across some tokens (scrollbar-bg = surface-0, button-face = surface-1,
  ; scrollbar-thumb = border, highlight = accent, text-primary = title-text),
  ; but other variants assign those tokens different values. Color-only
  ; substitution can't tell these apart — first-defined token in from-palette
  ; wins for a tied source color. If a specific bitmap needs the other target,
  ; recolor it by hand or with palette-swap.scm's single-color override.
  (let loop ((tokens from-palette) (acc '()))
    (if (null? tokens)
        (reverse acc)
        (let* ((token (caar tokens))
               (from-rgb (hex->rgb (cdar tokens)))
               (to-entry (assoc token to-palette)))
          (loop (cdr tokens)
                (if (and to-entry (not (rgb-in-list? from-rgb acc)))
                    (cons (cons from-rgb (hex->rgb (cdr to-entry))) acc)
                    acc))))))

(define (remap-colors image drawable swap-pairs)
  ; IMPORTANT: gimp-drawable-edit-fill on an EMPTY selection fills the whole
  ; drawable (GIMP's "no selection = everything selected" convention) rather
  ; than doing nothing. Every select-color call whose target color isn't
  ; actually present in the image must be skipped, or it silently overwrites
  ; everything already remapped by earlier pairs in this loop.
  (gimp-context-set-sample-threshold 0.0)
  (for-each
    (lambda (pair)
      (gimp-image-select-color image CHANNEL-OP-REPLACE drawable (car pair))
      (if (= (car (gimp-selection-bounds image)) 1)
          (begin
            (gimp-context-set-foreground (cdr pair))
            (gimp-drawable-edit-fill drawable FILL-FOREGROUND))))
    swap-pairs)
  (gimp-selection-none image))

(define (last-index-of str ch)
  ; strbreakup does not split correctly on backslash in this GIMP build —
  ; walk the string manually instead.
  (let loop ((i (- (string-length str) 1)))
    (cond ((< i 0) -1)
          ((char=? (string-ref str i) ch) i)
          (else (loop (- i 1))))))

(define (path-stem full-path)
  (let* ((slash-i (last-index-of full-path #\\))
         (dot-i (last-index-of full-path #\.))
         (start (+ slash-i 1))
         (end (if (> dot-i slash-i) dot-i (string-length full-path))))
    (substring full-path start end)))

(define (export-one-variant xcf-path variant swap-pairs)
  (let* ((stem (path-stem xcf-path))
         (out-path (string-append win11-theme-root "/assets/" variant "/" stem ".bmp"))
         (image (car (gimp-file-load RUN-NONINTERACTIVE xcf-path)))
         (layer (car (gimp-image-flatten image))))
    (if (not (null? swap-pairs))
        (remap-colors image layer swap-pairs))
    (file-bmp-export RUN-NONINTERACTIVE image out-path)
    (gimp-image-delete image)
    out-path))

(define (export-all-variants)
  (let* ((pattern (string-append win11-theme-root-bs "\\assets\\source\\*.xcf"))
         (files (car (file-glob pattern 1)))
         (light-pairs (build-swap-pairs dark-palette light-palette))
         (colorful-pairs (build-swap-pairs dark-palette colorful-palette)))
    (if (null? files)
        (gimp-message "No .xcf files found in assets/source/")
        (for-each
          (lambda (xcf-path)
            (gimp-message (string-append "Exporting " xcf-path " ..."))
            (export-one-variant xcf-path "dark" '())
            (export-one-variant xcf-path "light" light-pairs)
            (export-one-variant xcf-path "colorful" colorful-pairs))
          files))
    (length files)))
