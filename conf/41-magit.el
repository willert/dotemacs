(defun sbw/magit-window-config ()
  "Used in `window-configuration-change-hook' to configure fringes for Magit."
  (set-window-fringes nil 16 8)
  (face-remap-add-relative 'fringe '(:background "#091916")))

(defun sbw/magit-mode-hook ()
  "Custom `magit-mode' behaviours."
  (add-hook 'window-configuration-change-hook
            'sbw/magit-window-config nil :local))

(add-hook 'magit-mode-hook 'sbw/magit-mode-hook)

(setq magit-refs-show-commit-count "all")
