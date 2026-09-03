; Given a .xcf file authored in the Dark palette (MEMORY.md), replaces every
; flat-fill Dark color with its Light or Colorful equivalent and saves the
; result as a new .xcf alongside the original — for reviewing/touching up in
; the GIMP GUI before final export. For unattended batch export straight to
; BMP, use export-bitmaps.scm instead (same substitution logic).
;
; Limitation: exact-color substitution only — works on flat fills, not
; gradients (see VISION.md's Colorful title bar, which must be hand-authored
; per variant). KNOWN AMBIGUITY: MEMORY.md's Dark palette intentionally
; reuses the same hex across a few tokens (scrollbar-bg = surface-0,
; button-face = surface-1, scrollbar-thumb = border, highlight = accent,
; text-primary = title-text) but other variants assign them different
; values — color-only matching can't tell these apart, and the
; first-defined token in Dark's table wins for a tied source color.
;
; Verified against the actual installed GIMP 3.2.4 Script-Fu PDB.
;
; Load in the Script-Fu console, then call:
;   (palette-swap "D:/Projects/iTheme_Win11/assets/source/button-normal.xcf" "light")
; -> writes assets/source/button-normal-light.xcf

(define (hex->rgb hex)
  (list (string->number (substring hex 0 2) 16)
        (string->number (substring hex 2 4) 16)
        (string->number (substring hex 4 6) 16)))

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
  ; gimp-drawable-edit-fill on an EMPTY selection fills the whole drawable
  ; rather than doing nothing — every pair must be skipped when its source
  ; color isn't actually present, or it clobbers everything already remapped.
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
  (let loop ((i (- (string-length str) 1)))
    (cond ((< i 0) -1)
          ((char=? (string-ref str i) ch) i)
          (else (loop (- i 1))))))

(define (path-dir-and-stem full-path)
  (let* ((slash-i (last-index-of full-path #\/))
         (dot-i (last-index-of full-path #\.))
         (dir (substring full-path 0 (+ slash-i 1)))
         (stem-end (if (> dot-i slash-i) dot-i (string-length full-path))))
    (cons dir (substring full-path (+ slash-i 1) stem-end))))

(define (palette-swap xcf-path target-variant)
  (let* ((target-palette (cond ((string=? target-variant "light") light-palette)
                                ((string=? target-variant "colorful") colorful-palette)
                                (else (error "target-variant must be \"light\" or \"colorful\""))))
         (swap-pairs (build-swap-pairs dark-palette target-palette))
         (dir-stem (path-dir-and-stem xcf-path))
         (out-path (string-append (car dir-stem) (cdr dir-stem) "-" target-variant ".xcf"))
         (image (car (gimp-file-load RUN-NONINTERACTIVE xcf-path)))
         (layer (car (gimp-image-flatten image))))
    (remap-colors image layer swap-pairs)
    (gimp-xcf-save RUN-NONINTERACTIVE image out-path)
    (gimp-image-delete image)
    (gimp-message (string-append "Wrote " out-path))
    out-path))
