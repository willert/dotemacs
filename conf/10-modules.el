; uniquify
(require 'uniquify)
(setq uniquify-buffer-name-style (quote post-forward))
(setq uniquify-ignore-buffers-re "^\\*")

; ack mode
;(require 'ack)
;(setq
; ack-command
; (concat "ack " "--all --nogroup --no-color --with-filename "
;         "--ignore-dir=blib --ignore-dir=contrib --ignore-dir=perl5 "))

; yaml mode
(require 'yaml-mode)

; yasnippet minor mode
(require 'yasnippet)
(setq yas-snippet-dirs  '("~/.emacs.d/snippets"))
(yas-global-mode 1)
(define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key yas-minor-mode-map (kbd "C-<tab>") 'yas-expand)


; defer loading of snippets until all else is set up
(add-hook 'after-init-hook
          (lambda () (yas/load-directory "~/.emacs.d/snippets")))


(require 'magit)
(require 'espect)
(require 'eproject)

; catalyst-server mode
(require 'catalyst-server)

; highlight long lines
(require 'highlight-beyond-fill-column)
; (setq highlight-beyond-fill-column-face (quote flymake-errline))
(setq highlight-beyond-fill-column-in-modes (quote ("cperl-mode")))

(require 'goto-last-change)

(require 'template)
(setq template-default-directories (list (expand-file-name "~/.emacs.d/templates")))
(setq template-auto-insert t)
(template-initialize)

(require 'smooth-scrolling)
(setq smooth-scroll-margin 8)

(require 'transpose-window)

(require 'blooper)

(require 'browse-kill-ring)

; eshell
(setq eshell-cmpl-cycle-completions nil)

; edit-server
(require 'edit-server)
(edit-server-start)

; eimp for image mode
(autoload 'eimp-mode "eimp" "Emacs Image Manipulation Package." t)
(add-hook 'image-mode-hook 'eimp-mode)

; load wrap-region mode
(require 'wrap-region)
