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

; magit mode
(require 'magit)
(setq magit-repo-dirs (quote ("~/Devel" "~/.emacs.d")))
(setq magit-repo-dirs-depth 1)
