
; WarterMark-remove.scm
; by kiyoken

; Version 1.0

; Description
;
; WarterMark remove
;

;This program is builded by cited and altered "https://qiita.com/appin/items/173abe8fe169789d0617"(written by appin).

(define (WarterMark-remove inDir inLoadType outDir inFile inMode inOpacity)
  (let*
    (
      (varLoadStr "")
        (varFileList 0)
    )
    (set! varLoadStr
      (cond 
        (( equal? inLoadType 0 ) ".jpg" )
        (( equal? inLoadType 1 ) ".bmp" )
        (( equal? inLoadType 2 ) ".png" )
        (( equal? inLoadType 3 ) ".gif" )
      )
    )
    (set! varFileList (cadr (file-glob (string-append inDir "\\*" varLoadStr)  1)))

    (while (not (null? varFileList))
      (let* 
        ((filename (car varFileList))
          (short_filename (substring filename (+ (string-length inDir) 1) (string-length filename)))
          (image (car (gimp-file-load 1 filename filename)))
          (W_image (car (gimp-file-load 1 inFile inFile)))
          (drawable (car (gimp-image-get-active-layer image)))
          (layer (car (gimp-file-load-layer 1 image inFile)))
          (width (car (gimp-image-width image)))
          (height (car (gimp-image-height image)))
          (W_width (car (gimp-image-width W_image)))
          (W_height (car (gimp-image-height W_image)))
          (move_width (- (/ width 2) (/ W_width  2)))
          (move_height (- (/ height 2) (/ W_height  2)))
          ;保存ファイル名
          (newfilename (string-append outDir "\\" (string-append "" short_filename)))
        )
        (gimp-layer-set-name layer "layer")
        (gimp-layer-set-opacity layer inOpacity)
        (gimp-layer-set-mode layer inMode)
        (gimp-layer-set-visible layer TRUE)
        (gimp-layer-set-visible drawable TRUE)
        (gimp-layer-set-offsets layer move_width move_height)
        (gimp-image-insert-layer image layer 0 0)
        (gimp-file-save 1 image (car (gimp-image-merge-visible-layers image 1)) newfilename short_filename)
        (gimp-image-delete image)
        (gimp-image-delete W_image)
      )
      (set! varFileList (cdr varFileList))
    )

    (gimp-patterns-refresh)
  )
)

(script-fu-register "WarterMark-remove"
  "<Image>/Script-Fu/WarterMark remove..."
  "WarterMark remove."
  "kiyoken"
  "kiyoken"
  "March 2024"
  ""
  SF-DIRNAME    "Load from" ""
  SF-OPTION     "Load File Type" (list "jpg" "bmp" "png" "gif")
  SF-DIRNAME    "Save to"  ""
  SF-FILENAME    "WarterMark" ""
  SF-OPTION "Synthesis method" (list "NOMA-LEGACY" "DISSOVE" "BEHIND-LEGACY" "MULTIPY-LEGACY" "SCREEN-LEGACY"
   "OVERAY-LEGACY" "DIFFERNCE-LEGACY" "ADDITION-LEGACY" "SUBTRACT-LEGACY" "DARKEN-ONLY-LEGACY"
   "LIGHTTEN-ONLY-LEGACY" "HSV-HUE-LEGACY" "HSV-SATURATION-LEGACY" "HSL-COLOR-LEGACY" "HSV-VALUE-LEGACY"
   "DIVIDE-LEGACY" "DODGE-LEGACY" "BURN-LEGACY" "HARDOLIGHT-LEGACY" "SOFTLIGHT-LEGACY"
   "GRAIN-EXTRACT-LEGACY" "GRAIN-MERGE-LEGACY" "COLOR-ERASE-LEGACY" "OVERLAY" "LHH-HUE"
   "LCH-CHROMA" "LCH-COLOR" "LCH-LIGHTNESS" "NOMAL" "BEHIND"
   "MULTIPLY" "SCREEN" "DIFFERENCE" "ADDITION" "SUBTRACT"
   "DARKEN-ONLY" "LIGHTEN-ONLY" "HSV-HUE" "HSV-SATURATION" "HSL-COLOR"
   "HSV-VALUE" "DIVIDE" "DODGE" "BURN" "HARDLIGHT"
   "SOFTLIGHT" "GRAIN-EXTRACT" "GRAIN-MERGE" "VIVID-LIGHT" "PIN-LIGHT"
   "LINEAR-LIGHT" "HARD-MIX" "EXCLUSION" "LINEAR-BURN" "LUMA-DARKEN-ONLY"
   "LUMA-LIGHTEN-ONLY" "LUMINANCE" "COLOR-ERASE" "ERASE" "MERGE"
   "SPLIT" "PASS-THROUGH" "REPLACE" "ANTIERASE")
  SF-VALUE "opacity" ""

)