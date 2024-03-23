; WarterMark-remove.scm
; by kiyoken

; Version 1.0

; Description
;
; WarterMark remove
;

;This program is builded by cited and altered "https://qiita.com/appin/items/173abe8fe169789d0617"(written by appin).

(define (WarterMark-remove inDir inLoadType outDir inFile inHeight inWidth inOpacity)
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
          (drawable (car (gimp-image-get-active-layer image)))
          (layer (car (gimp-file-load-layer 1 image inFile)))
          (height (car (gimp-image-height image)))
          (width (car (gimp-image-width image)))
          (move_height (- (/ height 2) (/ inHeight  2)))
          (move_width (- (/ width 2) (/ inWidth  2)))
          ;保存ファイル名
          (newfilename (string-append outDir "\\" (string-append "" short_filename)))
        )
        (gimp-layer-set-name layer "layer")
        (gimp-layer-set-opacity layer inOpacity)
        (gimp-layer-set-mode layer 34)
        (gimp-layer-set-visible layer TRUE)
        (gimp-layer-set-visible drawable TRUE)
        (gimp-layer-set-offsets layer move_width move_height)
        (gimp-image-insert-layer image layer 0 0)
        (gimp-file-save 1 image (car (gimp-image-merge-visible-layers image 1)) newfilename short_filename)
        (gimp-image-delete image)
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
  SF-VALUE "wartermark height" ""
  SF-VALUE "wartermark width" ""
  SF-VALUE "opacity" ""

)