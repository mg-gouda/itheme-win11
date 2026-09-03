; Creates a new blank .xcf source file at the correct canvas size for a
; named component, with one transparent RGBA layer ready to design in.
;
; Verified against the actual installed GIMP 3.2.4 Script-Fu PDB (function
; names/signatures changed from GIMP 2.10 — see docs/mod-log.md notes).
;
; Load in the Script-Fu console, then call:
;   (new-bitmap "title-bar-active" 800 30)
; -> writes assets/source/title-bar-active.xcf

(define win11-theme-root "D:/Projects/iTheme_Win11")

(define (new-bitmap name width height)
  (let* ((path (string-append win11-theme-root "/assets/source/" name ".xcf"))
         (image (car (gimp-image-new width height RGB)))
         (layer (car (gimp-layer-new image "base" width height RGBA-IMAGE 100 LAYER-MODE-NORMAL))))
    (gimp-image-insert-layer image layer 0 -1)
    (gimp-drawable-edit-clear layer)
    (gimp-xcf-save RUN-NONINTERACTIVE image path)
    (gimp-image-delete image)
    (gimp-message (string-append "Created " path " (" (number->string width) "x" (number->string height) ")"))
    path))
