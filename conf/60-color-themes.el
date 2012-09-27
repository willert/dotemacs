(defun sbw/color-theme-switch-to-sunshine ()
  (interactive)
  (sbw/color-theme-sunshine (selected-frame))
)

(defun sbw/color-theme-sunshine (frame)

  (set-face-attribute
   'default frame
   :foreground "#000000" :background "#ffffff"
   :inherit nil :stipple nil :inverse-video nil :box nil
   :strike-through nil :overline nil :underline nil)

  (set-face-attribute
   'fringe frame
   :foreground nil :background "white smoke")

;  (set-face-attribute
;   'show-paren-match nil
;   :background "RoyalBlue4")

  (set-face-attribute
   'font-lock-builtin-face frame
   :foreground "dark magenta" :weight 'bold)

;  (set-face-attribute
;   'font-lock-keyword-face frame
;   :foreground "Cyan1" :weight 'normal)

  (set-face-attribute
   'font-lock-string-face frame
   :foreground "blue violet")

  (set-face-attribute
   'font-lock-comment-face frame
   :foreground "PaleVioletRed3")

  (set-face-attribute
   'font-lock-variable-name-face frame
   :foreground "red1")

  (set-face-attribute
   'font-lock-function-name-face frame
   :foreground "SteelBlue3" :weight 'bold)

;  (set-face-attribute
;   'cperl-nonoverridable-face frame
;   :foreground "orchid1" :weight 'normal)

  (set-face-attribute
   'cperl-array-face frame
   :background nil :foreground "red1" :weight 'normal)

  (set-face-attribute
   'cperl-hash-face frame
   :background nil :foreground "red1" :weight 'normal)

  (set-face-attribute
   'flyspell-duplicate frame
   :background nil :foreground nil :underline nil :slant 'italic :weight 'normal)

  (set-face-attribute
   'flyspell-incorrect frame
   :background nil :foreground nil :weight 'normal)

  (set-face-attribute
   'mode-line frame
   :inverse-video t)

  (set-cursor-color "Black")

  (setq default-frame-alist
        (append default-frame-alist
                '((cursor-color . "Black"))))

  (setq ansi-color-names-vector
        ["black" "red" "green" "yellow" "blue" "magenta" "cyan" "white"])
  (setq ansi-color-map (ansi-color-make-color-map))

  (setq frame-background-mode 'light)
  (sbw/adjust-terminal-colors frame)
)


(defun sbw/color-theme-switch-to-nighttimes ()
  (interactive)
  (sbw/color-theme-nighttimes (selected-frame))
)

(defun sbw/color-theme-nighttimes (frame)

  (set-face-attribute
   'default frame
   :background "#0b2626" :foreground "#bbbbbb"
   :inherit nil :stipple nil :inverse-video nil :box nil
   :strike-through nil :overline nil :underline nil)

  (set-face-attribute
   'fringe frame
   :background "#000000" :foreground "#dddddd")

  (set-face-attribute
   'show-paren-match frame
   :background "RoyalBlue4")

  (set-face-attribute
   'font-lock-builtin-face frame
   :foreground "LightSteelBlue" :weight 'bold)

  (set-face-attribute
   'font-lock-keyword-face frame
   :foreground "Cyan1" :weight 'normal)


  (set-face-attribute
   'font-lock-string-face frame
   :foreground "LightSalmon")

  (set-face-attribute
   'font-lock-comment-face frame
   :foreground "chocolate1")

  (set-face-attribute
   'font-lock-variable-name-face frame
   :foreground "LightGoldenrod" :weight 'normal)

  (set-face-attribute
   'font-lock-function-name-face frame
   :foreground "LightSkyBlue" :weight 'normal)

  (set-face-attribute
   'cperl-nonoverridable-face frame
   :foreground "orchid1" :weight 'normal)

  (set-face-attribute
   'cperl-array-face frame
   :background nil :foreground "LightGoldenrod" :weight 'normal)

  (set-face-attribute
   'cperl-hash-face frame
   :background nil :foreground "LightGoldenrod" :weight 'normal)

  (set-face-attribute
   'flyspell-duplicate frame
   :background nil :foreground nil :underline nil :slant 'italic :weight 'normal)

  (set-face-attribute
   'flyspell-incorrect frame
   :background nil :foreground nil :weight 'normal)

  (set-face-attribute
   'mode-line frame
   :inverse-video nil)

  (set-cursor-color "Orchid")

  (setq default-frame-alist
        (append default-frame-alist
                '((cursor-color . "Orchid"))))

  (setq ansi-color-names-vector
        ["black" "red" "green" "yellow" "DeepSkyBlue" "magenta" "cyan" "white"])
  (setq ansi-color-map (ansi-color-make-color-map))

  (setq frame-background-mode 'dark)
  (sbw/adjust-terminal-colors frame)
)
