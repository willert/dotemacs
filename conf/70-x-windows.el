(cond
 ((or (daemonp) window-system)

  (require 'x-win)

  (defun sbw/set-x-win-face-attributes (frame)
    (set-face-attribute 'default nil :family "DejaVu Sans Mono" :height 159))

  (defun sbw/apply-devilspie-configuration (frame)
              (if (get-buffer "*devilspie*") nil
                (set-process-query-on-exit-flag
                 (start-process
                  "devilspie" "*devilspie*" "devilspie"
                  (expand-file-name "~/.emacs.d/devilspie.ds"))
                 nil)))

  (add-hook 'after-make-frame-functions 'sbw/set-x-win-face-attributes)
  (add-hook 'after-make-frame-functions 'sbw/apply-devilspie-configuration)

  (defun sbw/reset-frame-configuration ()
    "Set default x config for current frame"
    (interactive)
         (sbw/set-x-win-face-attributes (selected-frame))
         (sbw/apply-devilspie-configuration (selected-frame))
         )


  (defun emacs-session-filename (session-id)
    "Construct a filename to save the session in based on SESSION-ID
     in  ~/.emacs.d/var"
    (let ((basename (concat "session." session-id))
          (emacs-dir user-emacs-directory))
      (make-directory (expand-file-name (concat emacs-dir "var")))
      (expand-file-name (concat emacs-dir "var/" basename))
      ))

  ))
