(cond
 ((or (daemonp) window-system)
  (set-face-attribute
   'default nil
   :family "DejaVu Sans Mono" :height 99
   :slant 'normal :weight 'normal :width 'normal)

  (sbw/color-theme-switch-to-nighttimes)
  (add-hook 'after-make-frame-functions 'sbw/adjust-terminal-colors t)
  (add-hook 'after-make-frame-functions 'sbw/color-theme-nighttimes)

  (add-hook 'after-make-frame-functions 'sbw/run-devilspie t)

  (require 'x-win)

  (defun emacs-session-filename (session-id)
    "Construct a filename to save the session in based on SESSION-ID
     in  ~/.emacs.d/var"
  (let ((basename (concat "session." session-id))
        (emacs-dir user-emacs-directory))
    (make-directory (expand-file-name (concat emacs-dir "var")))
    (expand-file-name (concat emacs-dir "var/" basename))
    ))

))
