(defun sbw/magit-window-config ()
  "Used in `window-configuration-change-hook' to configure fringes for Magit."
  (set-window-fringes nil 16 8))

(defun sbw/magit-mode-hook ()
  "Custom `magit-mode' behaviours."
  (add-hook 'window-configuration-change-hook
            'sbw/magit-window-config nil :local))

(add-hook 'magit-mode-hook 'sbw/magit-mode-hook)
