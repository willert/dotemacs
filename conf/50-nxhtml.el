(load "nxhtml/autostart.el")

(defun sbw/remove-mumamo-backgrounds ()
  (set-face-attribute
   'mumamo-background-chunk-major nil
   :background nil)

  (set-face-attribute
   'mumamo-background-chunk-submode1 nil
   :background nil)

  (set-face-attribute
   'mumamo-background-chunk-submode2 nil
   :background nil)
  (set-face-attribute
   'mumamo-background-chunk-submode3 nil
   :background nil)
  (set-face-attribute
   'mumamo-background-chunk-submode4 nil
   :background nil)

  (set-face-attribute
   'mumamo-border-face-in nil
   :underline nil :slant 'normal)
)

(add-hook 'mumamo-turn-on-hook 'sbw/remove-mumamo-backgrounds)
(add-hook 'mumamo-after-change-major-mode-hook 'flymake-mode-off)
;; Mason submode config
; mason-nxhtml-mumamo-mode is to buggy

(setq
 auto-mode-alist
 (cons '("\\/root/"         . nxhtml-mode)
 (cons '("\\/htdocs/"       . nxhtml-mode)
 (cons '("\\/widgets/"      . nxhtml-mode)
 (cons '("\\/dhandler$"     . nxhtml-mode)
 (cons '("\\/autohandler$"  . nxhtml-mode)
 (cons '("\\.mc$"           . nxhtml-mode)
       auto-mode-alist)))))))

