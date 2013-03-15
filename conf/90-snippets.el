
; yasnippet minor mode
(require 'yasnippet)
(setq yas-snippet-dirs  '("~/.emacs.d/snippets"))
(yas-global-mode 1)
(define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key yas-minor-mode-map (kbd "C-<tab>") 'yas-expand)

; defer loading of snippets until all else is set up
(add-hook 'after-init-hook
          (lambda ()
 (yas/load-directory "~/.emacs.d/snippets")
(defun yas-new-snippet (&optional no-template)
  "Pops a new buffer for writing a snippet.

Expands a snippet-writing snippet, unless the optional prefix arg
NO-TEMPLATE is non-nil."
  (interactive "P")
  (let ((guessed-directories (yas--guess-snippet-directories))
        (guessed-name (word-at-point)))

    (switch-to-buffer "*new snippet*")
    (erase-buffer)
    (kill-all-local-variables)
    (snippet-mode)
    (yas-minor-mode 1)
    (set (make-local-variable 'yas--guessed-modes) (mapcar #'(lambda (d)
                                                              (yas--table-mode (car d)))
                                                          guessed-directories))
    (unless no-template (yas-expand-snippet "\
# -*- mode: snippet -*-
# name: ${1:`guessed-name`} ($2)
# key: ${1:$(replace-regexp-in-string \"\\\\\\\\(\\\\\\\\w+\\\\\\\\).*\" \"\\\\\\\\1\" yas-text)}
# --
$0"))))

))
