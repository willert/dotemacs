; uniquify
(require 'uniquify)
(setq uniquify-buffer-name-style (quote post-forward))
(setq uniquify-ignore-buffers-re "^\\*")

; ag mode
(require 'ag)
(setq ag-highlight-search t)
(setq ag-reuse-window 't)

(defadvice ag/dwim-at-point (around my-ag/dwim-at-point act)
  "Don't prefill search string unless region is active."
  (if (use-region-p)
      ad-do-it
    ""))

; yaml mode
(require 'yaml-mode)

(require 'goto-last-change)

; (require 'template)
; (setq template-default-directories (list (expand-file-name "~/.emacs.d/templates")))
; (setq template-auto-insert t)
; (template-initialize)

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

; load wrap-region mode
(require 'wrap-region)

; magit mode
; (require 'magit) ;; handled by ELPA
(setq magit-repo-dirs (quote ("~/Devel" "~/.emacs.d")))
(setq magit-repo-dirs-depth 1)

; yagist
(setq yagist-encrypt-risky-config t)
