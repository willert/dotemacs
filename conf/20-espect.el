; "prog-mode" stuff (fromerly done via espect)

(defun sbw/progmodes-write-hooks ()
  "Hooks which run on file write for programming modes"
  (prog1 nil
    (set-buffer-file-coding-system 'utf-8-unix)
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

(defun sbw/nxhtml-mode-hook ()
  (setq fill-column 112)
  (setq whitespace-style '(face tabs trailing lines-trail tab-mark))
  (setq whitespace-line-column 112)
  (setq indent-tabs-mode nil)
  (whitespace-mode)

  (add-hook 'before-save-hook 'sbw/progmodes-write-hooks nil t)
)

(defun sbw/save-verbatim () (interactive)
  (setq require-final-newline nil)
  (setq buffer-file-coding-system nil)
  (remove-hook 'before-save-hook 'sbw/progmodes-write-hooks t)
)

(defun sbw/grunt-file-write-hooks ()
  "Hooks which run on file write for programming modes"
  (prog1 nil
    (if (upward-find-file "Gruntfile.js")
        (let ((compass-command "grunt")
              (compass-task "default"))
          (compass-compile)))))

(defun sbw/grunt-hook ()
  (add-hook 'before-save-hook 'sbw/grunt-file-write-hooks nil t)
)


(add-hook 'c-mode-hook 'sbw/prog-modes-mode-hook)
(add-hook 'cperl-mode-hook 'sbw/prog-modes-mode-hook)
(add-hook 'emacs-lisp-mode-hook 'sbw/prog-modes-mode-hook)
(add-hook 'js-mode-hook 'sbw/prog-modes-mode-hook)
(add-hook 'js-mode-hook 'sbw/grunt-hook)
(add-hook 'scss-mode-hook 'sbw/prog-modes-mode-hook)
(add-hook 'scss-mode-hook 'sbw/grunt-hook)

(add-hook 'nxhtml-mode-hook 'sbw/nxhtml-mode-hook)
