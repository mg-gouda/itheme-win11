; Opens every .xcf in assets/source/ and prints its dimensions, so they can
; be cross-checked against the real values recorded in MEMORY.md's Bitmap
; Dimension Reference (filled in from Resource Hacker inspection).
;
; Verified against the actual installed GIMP 3.2.4 Script-Fu PDB. Two 3.x
; quirks this accounts for (not present in GIMP 2.10):
;   - file-glob only matches with BACKSLASH-style Windows paths, even though
;     gimp-file-load/gimp-xcf-save happily accept forward slashes.
;   - (car (file-glob pattern 1)) is the files list directly in 3.x —
;     there's no separate leading file-count element like in 2.10.
;
; Load in the Script-Fu console, then call:
;   (check-all-dimensions)

(define win11-theme-root "D:\\Projects\\iTheme_Win11")

(define (check-all-dimensions)
  (let* ((pattern (string-append win11-theme-root "\\assets\\source\\*.xcf"))
         (files (car (file-glob pattern 1))))
    (if (null? files)
        (gimp-message "No .xcf files found in assets/source/")
        (for-each
          (lambda (path)
            (let* ((image (car (gimp-file-load RUN-NONINTERACTIVE path)))
                   (width (car (gimp-image-get-width image)))
                   (height (car (gimp-image-get-height image))))
              (gimp-message (string-append
                              path " -> " (number->string width) " x " (number->string height)))
              (gimp-image-delete image)))
          files))
    (length files)))
