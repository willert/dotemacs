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

(set-face-attribute
   'mumamo-border-face-out nil
   :underline nil :slant 'normal)
)

(add-hook 'mumamo-turn-on-hook 'sbw/remove-mumamo-backgrounds)
(add-hook 'mumamo-after-change-major-mode-hook 'flymake-mode-off)
;; Mason submode config
; mason-nxhtml-mumamo-mode is to buggy

(define-key nxhtml-mode-map (kbd "C-c /") 'nxml-finish-element)

(setq
 auto-mode-alist
 (cons '("\\/root/"         . mason-nxhtml-mumamo-mode)
 (cons '("\\/htdocs/"       . mason-nxhtml-mumamo-mode)
 (cons '("\\/widgets/"      . mason-nxhtml-mumamo-mode)
 (cons '("\\/dhandler$"     . mason-nxhtml-mumamo-mode)
 (cons '("\\/autohandler$"  . mason-nxhtml-mumamo-mode)
 (cons '("\\.mc$"           . mason-nxhtml-mumamo-mode)
       auto-mode-alist)))))))

(setq nxhtml-flymake-setup nil)
