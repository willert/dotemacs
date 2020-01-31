;; uniquify
(require 'uniquify)
(setq uniquify-buffer-name-style (quote post-forward))
(setq uniquify-ignore-buffers-re "^\\*")

;; nodejs
(require 'npm-mode)
(npm-global-mode)

;; magit
(require 'magit)

;; ag mode
(require 'ag)
(setq ag-highlight-search t)
(setq ag-reuse-window 't)

(defadvice ag/dwim-at-point (around my-ag/dwim-at-point act)
  "Don't prefill search string unless region is active."
  (if (use-region-p)
      ad-do-it
    ""))

;; yaml mode
(require 'yaml-mode)

(popwin-mode 1)

(require 'goto-last-change)

(require 'transpose-window)

; (require 'blooper)

; ELPA: (require 'browse-kill-ring)

;; eshell
(setq eshell-cmpl-cycle-completions nil)

;; edit-server
; (require 'edit-server)
; (edit-server-start)

;; load wrap-region mode
; ELPA: (require 'wrap-region)

;; magit mode
; ELPA: (require 'magit)
(setq magit-repo-dirs (quote ("~/Devel" "~/.emacs.d")))
(setq magit-repo-dirs-depth 1)

(setq auto-mode-alist (cons '("\\.template$" . handlebars-mode) auto-mode-alist))
