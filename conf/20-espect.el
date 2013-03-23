; "prog-mode" stuff (fromerly done via espect)

(defun sbw/progmodes-write-hooks ()
  "Hooks which run on file write for programming modes"
  (prog1 nil
    (set-buffer-file-coding-system 'utf-8-unix)
    (untabify-buffer)
    (delete-trailing-whitespace)))

(defun sbw/prog-modes-mode-hook ()
  (flyspell-prog-mode)
  (setq fill-column 78)
  (setq whitespace-style '(face tabs trailing lines-trail tab-mark))
  (setq whitespace-line-column 78)
  (setq indent-tabs-mode nil)
  (whitespace-mode)

  (add-hook 'before-save-hook 'sbw/progmodes-write-hooks nil t)
)

(add-hook 'c-mode-hook 'sbw/prog-modes-mode-hook)
(add-hook 'cperl-mode-hook 'sbw/prog-modes-mode-hook)
(add-hook 'emacs-lisp-mode-hook 'sbw/prog-modes-mode-hook)
