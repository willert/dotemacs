(cond
 ((or (daemonp) window-system)

  (require 'x-win)

  (defun emacs-session-filename (session-id)
    "Construct a filename to save the session in based on SESSION-ID
     in  ~/.emacs.d/var"
  (let ((basename (concat "session." session-id))
        (emacs-dir user-emacs-directory))
    (make-directory (expand-file-name (concat emacs-dir "var")))
    (expand-file-name (concat emacs-dir "var/" basename))
    ))
  (add-hook 'after-make-frame-functions
            (lambda (frame)
              (set-face-attribute 'default nil :family "DejaVu Sans Mono" :height 99)))

  (add-hook 'after-make-frame-functions
            (lambda (frame)
              (if (get-buffer "*devilspie*") nil
                (set-process-query-on-exit-flag
                 (start-process
                  "devilspie" "*devilspie*" "devilspie"
                  (expand-file-name "~/.emacs.d/devilspie.ds"))
                 nil)
                )))
))
