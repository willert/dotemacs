(defun sbw/progmodes-write-hooks ()
  "Hooks which run on file write for programming modes"
  (prog1 nil
    (set-buffer-file-coding-system 'utf-8-unix)
    (untabify-buffer)
    (delete-trailing-whitespace)))


(setq espect-buffer-settings
      '(
        ((:mode c-mode)
         (:mode cperl-mode)
         (:mode emacs-lisp-mode)
         (lambda ()
           (flyspell-prog-mode)
           (setq fill-column 78)
           (yas/minor-mode-on)
           (add-hook 'before-save-hook 'sbw/progmodes-write-hooks nil t)
           ))
        ((:mode nxhtml-mode)
         (lambda ()
           (yas/minor-mode-on)
           (add-hook 'before-save-hook 'sbw/progmodes-write-hooks nil t)
           ))
        ))
