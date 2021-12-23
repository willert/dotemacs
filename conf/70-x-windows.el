(cond
 ((or (daemonp) window-system)

  (require 'x-win)

  (defun sbw/set-x-win-face-attributes (frame)
                  (set-face-attribute 'default nil :family "DejaVu Sans Mono" :height 175))

  (add-hook 'after-make-frame-functions 'sbw/set-x-win-face-attributes)

  (add-hook 'after-make-frame-functions
            (lambda (frame)
              (if (get-buffer "*devilspie*") nil
                (set-process-query-on-exit-flag
                 (start-process
                  "devilspie" "*devilspie*" "devilspie"
                  (expand-file-name "~/.emacs.d/devilspie.ds"))
                 nil))))


  (defun emacs-session-filename (session-id)
    "Construct a filename to save the session in based on SESSION-ID
     in  ~/.emacs.d/var"
    (let ((basename (concat "session." session-id))
          (emacs-dir user-emacs-directory))
      (make-directory (expand-file-name (concat emacs-dir "var")))
      (expand-file-name (concat emacs-dir "var/" basename))
      ))

  ))
