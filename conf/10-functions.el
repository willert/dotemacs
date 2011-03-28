(defun kill-line-to-cursor ()
  "Kills the part of the line before the point"
  (interactive)
  (cond ((bolp) (delete-char -1)) (t (kill-line -0))))

(defun untabify-buffer ()
  "Untabify current buffer"
  (interactive)
  (untabify (point-min) (point-max)))

(defun sbw/run-devilspie (new-frame)
  (shell-command
   (concat
    "devilspie " (expand-file-name "~/.emacs.d/devilspie.ds") "&"
    "( sleep 1 && ps -C devilspie -o pid --no-heading | xargs echo ) &" ))
)

(defun string-rectangle-kill ()
  (interactive)
  (string-rectangle (region-beginning) (region-end) ""))

(defun copy-rectangle-as-kill () (interactive)
  (save-excursion
    (kill-rectangle (mark) (point))
    (deactivate-mark)
    (undo)))

(defun set-region ()
  (interactive)
  (cond
   (mark-active (copy-region-as-kill (region-beginning) (region-end)))
   (t (push-mark (point) nil t))
   ))

(defun sbw/prove-project (verbose)
  "Run prove on this PerlySense project"
  (interactive "P")
  (sbw/run-file-run-command
   (concat
    (if verbose "prove -Mlocal::lib=perl5 -l -v" "prove  -Mlocal::lib=perl5 -l")
    " " sbw/prove-project-directories )
  (ps/project-dir)))

(defun sbw/prove-whole-project (verbose)
  "Run prove on this PerlySense project"
  (interactive "P")
  (sbw/run-file-run-command
   (if verbose "prove  -Mlocal::lib=perl5 -lrv t/" "prove -Mlocal::lib=perl5 -lr t/" ) (ps/project-dir)))

(defun sbw/run-file-run-command (command dir-run-from)
  "Run command from dir-run-from using the compiler function"
  (with-temp-buffer
    (cd dir-run-from)
    (compile command t)
    ))

(defun sbw/default-perl-package-name ()
  "Builds the default package name for the current file"

  (setq fpath (split-string (buffer-file-name) "[/\\]+" ))

  (while (and (stringp (car fpath)) (not (string-match "lib$" (car fpath))) )
    (setq fpath (cdr fpath)))

  (setq fpath (cdr fpath))
  (setq fpack (car fpath))
  (setq fpath (cdr fpath))

  (while (car fpath)
    (setq fpack (concat fpack "::" (car fpath)))
    (setq fpath (cdr fpath)))

  (cond ( (not (stringp fpack))
    (message "Could not find lib path for %s" buffer-file-name )
    (setq fpath (car (reverse (split-string (buffer-file-name) "[/\\]+" ))))
    ))

  (if (and (stringp fpack) (string-match "\\(.*\\)\\.pm" fpack))
      (setq fpack (match-string 1 fpack)))

  (if (stringp fpack) (progn fpack)
    (error "Could not find lib path for %s" buffer-file-name ) "" )
)

(defun sbw/adjust-terminal-colors (new-frame)
  "Adjust some terminal backgrounds to ensure legibility"
  (if (window-system new-frame)
      nil
    (set-face-attribute
     'mode-line new-frame
     :inverse-video t)
    (if (eq frame-background-mode 'dark)
        (set-face-attribute
         'default new-frame
         :background "black")
      (set-face-attribute
       'default new-frame
       :background "lightgray"))
    ))

(defun sbw/prereqs-to-dist-zilla ()
  (interactive)
  (save-excursion
   (while
       (re-search-forward
        (concat
         "^\\(build_\\)?requires *['\"]\\([^'\"]*\\)['\"]"
         " *\\(=>\\|,\\)? *['\"]?\\([0-9_.]*\\)?['\"]? *[;,]")
        nil t)
     (replace-match
      (let
          ((module (match-substitute-replacement "\\2"))
           (version (match-substitute-replacement "\\4")))
        (concat module " = " (if (string= version "") "0" version)))
      t nil)
     ))
)

(defun sbw/shutdown-emacs-server () (interactive)
  (let ((last-nonmenu-event nil)
        (kill-emacs-query-functions
         (lambda () (dolist (cl server-clients)
                      (server-delete-client cl)) t)
         ))
    (save-buffers-kill-emacs)))

;; Toggle window dedication

(defun toggle-window-dedicated ()
  "Toggle whether the current active window is dedicated or not"
  (interactive)
  (message
   (if (let (window (get-buffer-window (current-buffer)))
         (set-window-dedicated-p window
                                 (not (window-dedicated-p window))))
       "Window '%s' is dedicated"
     "Window '%s' is normal")
   (current-buffer)))
