(defun kill-line-to-cursor ()
  "Kills the part of the line before the point"
  (interactive)
  (cond ((bolp) (delete-char -1)) (t (kill-line -0))))

(defun untabify-buffer ()
  "Untabify current buffer"
  (interactive)
  (untabify (point-min) (point-max)))

(defun sbw/run-devilspie (new-frame)
;   (shell-command
;    (concat
;     "devilspie " (expand-file-name "~/.emacs.d/devilspie.ds") "&"
;     "( sleep 1 && ps -C devilspie -o pid --no-heading | xargs echo ) &" ))
)

(defun string-rectangle-kill ()
  (interactive)
  (string-rectangle (region-beginning) (region-end) ""))

(defun copy-rectangle-as-kill () (interactive)
  (save-excursion
    (kill-rectangle (mark) (point))
    (deactivate-mark)
    (undo)))

(defun sbw/prove-project (verbose)
  "Run prove on this PerlySense project"
  (interactive "P")
  (sbw/run-file-run-command
   (concat
    (if verbose "./mist-run prove -l -v" "./mist-run prove -l")
    " " sbw/prove-project-directories )
  (ps/project-dir)))

(defun sbw/prove-whole-project (verbose)
  "Run prove on this PerlySense project"
  (interactive "P")
  (sbw/run-file-run-command
   (if verbose "./mist-run prove -lrv t/" "./mist-run prove -lr t/" ) (ps/project-dir)))

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
    (message "Could not find lib path for %s" buffer-file-name)
    (setq fpack (car (reverse (split-string (buffer-file-name) "[/\\]+" ))))
    ))

  (if (and (stringp fpack) (string-match "\\(.*\\)\\.pm" fpack))
      (setq fpack (match-string 1 fpack)))

  (if (stringp fpack) (progn fpack)
    (error "Could not find lib path for %s" buffer-file-name ) "" )
)

(defun sbw/adjust-terminal-colors (&optional new-frame)
  "Adjust some terminal backgrounds to ensure legibility"
  (let
      ((frame (or new-frame (window-frame nil))))
    (if (window-system frame)
        nil
      (set-face-attribute
       'mode-line frame
       :inverse-video t)
      (if (eq frame-background-mode 'dark)
            (set-face-attribute
             'default frame
             :background "black")
        (set-face-attribute
         'default frame
         :background "lightgray")
      )
    )))

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

(defun sbw/region-or-thing (thing)
  "Return a vector containing the region and its bounds if there is one
or the thing at the point and its bounds if there is no region"
  (if (use-region-p)
      (vector (buffer-substring-no-properties (region-beginning) (region-end))
              (region-beginning) (region-end))
    (let* ((bounds (bounds-of-thing-at-point thing))
           (beg (car bounds))
           (end (cdr bounds)))
      (vector (buffer-substring-no-properties beg end) beg end))))

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome")

(defun sbw/metacpan-search ()
  "Try to open module page on MetaCPAN"
  (interactive)
  (let* (
         (phrase (elt (sbw/region-or-thing 'symbol) 0))
         (enc (replace-regexp-in-string ":" "%3A"
                        (replace-regexp-in-string " " "+" phrase)))
         )
    (browse-url (format "https://metacpan.org/module/%s?q=%s" enc enc))))

(require 'xeu_elisp_util)

(defun sbw/copy-to-register-x ()
  "Copy current line or text selection to register 1.
See also: `paste-from-register-1', `copy-to-register'."
  (interactive)
  (let* (
         (bds (get-selection-or-unit 'line ))
         (inputStr (elt bds 0) )
         (p1 (elt bds 1) )
         (p2 (elt bds 2) )
         )
    (copy-to-register ?1 p1 p2)
    (message "copied to register 1: 「%s」." inputStr)
))

(defun sbw/paste-from-register-x ()
  "Paste text from register 1.
See also: `copy-to-register-1', `insert-register'."
  (interactive)
  (insert-register ?1))


(defun sbw/clear-shell ()
  (interactive)
  (let ((comint-buffer-maximum-size 0))
    (comint-truncate-buffer)))

(defun rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

(defun delete-current-buffer-file ()
  "Removes file connected to current buffer and kills buffer."
  (interactive)
  (let ((filename (buffer-file-name))
        (buffer (current-buffer))
        (name (buffer-name)))
    (if (not (and filename (file-exists-p filename)))
        (ido-kill-buffer)
      (when (yes-or-no-p "Are you sure you want to remove this file? ")
        (delete-file filename)
        (kill-buffer buffer)
        (message "File '%s' successfully removed" filename)))))

(defun upward-find-file (filename &optional startdir)
  "Move up directories until we find a certain filename. If we
  manage to find it, return the containing directory. Else if we
  get to the toplevel directory and still can't find it, return
  nil. Start at startdir or . if startdir not given"

  (let ((dirname (expand-file-name
      (if startdir startdir ".")))
  (found nil) ; found is set as a flag to leave loop if we find it
  (top nil))  ; top is set when we get
        ; to / so that we only check it once

    ; While we've neither been at the top last time nor have we found
    ; the file.
    (while (not (or found top))
      ; If we're at / set top flag.
      (if (string= (expand-file-name dirname) "/")
    (setq top t))

      ; Check for the file
      (if (file-exists-p (expand-file-name filename dirname))
    (setq found t)
  ; If not, move up a directory
  (setq dirname (expand-file-name ".." dirname))))
    ; return statement
    (if found dirname nil)))


(defcustom compass-command "compass"
  "Command used to compile SCSS files, should be sass or the
  complete path to your sass runnable example:
  \"~/.gem/ruby/1.8/bin/sass\""
  :group 'scss)

(defcustom compass-task "compile"
  "Command used to compile SCSS files, should be sass or the
  complete path to your sass runnable example:
  \"~/.gem/ruby/1.8/bin/sass\""
  :group 'scss)

(defcustom compass-options '()
  "Command line Options for sass executable, for example:
'(\"--cache-location\" \"'/tmp/.sass-cache'\")"
  :group 'scss)

(defun compass-compile()
  "Compiles the current buffer with 'compass compile [PATH]'"
  (interactive)
  (let* ((compass-root-dir (or (upward-find-file "config.rb") default-directory))
         (default-directory compass-root-dir))
    (save-window-excursion
      (async-shell-command
       (concat
        "cd " compass-root-dir "; "
        compass-command " " compass-task " "
        (mapconcat 'identity compass-options " ")
        " ")
       "*compass: compile*")
      )))

(defadvice scss-compile (around compile-scss-with-compass)
  "compile Compass project"
  (let* ((compass-root-dir (upward-find-file "config.rb"))
         (default-directory compass-root-dir))
    (if compass-root-dir
        (compass-compile)
      ad-do-it
      )
    )
  )
(ad-activate 'scss-compile)


(defun sbw/expand-dir-name (root &rest dirs)
  "Joins a series of directories together"

   (if (not dirs)
       (concat root "/")
     (apply 'sbw/expand-dir-name
            (expand-file-name (car dirs) root)
            (cdr dirs))))

(defun sbw/find-file-in-dir (&rest dirs) ()
  (let ((default-directory
          (apply 'sbw/expand-dir-name (eproject-root) dirs )))
    (call-interactively 'find-file))
)

(defun sbw/comint-send-input-at-eob ()
  "Send input to shell if cursor is after the prompt,
else advance a line"
  (interactive)
  (if (comint-after-pmark-p)
      (call-interactively 'comint-send-input)
    (call-interactively 'next-line)))

(defun sbw/open-shell-in-dir ()
  (interactive)
  (let ((shell-name (format "*shell: %s*" default-directory)))
    (shell shell-name))
  (make-variable-buffer-local 'comint-prompt-read-only)

  (setq comint-prompt-read-only t)
  (setq comint-process-echoes nil)

  (local-set-key (kbd "<return>") 'sbw/comint-send-input-at-eob)

  (let ((process (get-buffer-process (current-buffer))))
    (unless process
      (error "No process in %s" buffer-or-name))

    (set-process-query-on-exit-flag process nil)
    (set-process-sentinel
     process
     (lambda (this-process state)
       (if (or (string-match "exited abnormally with code.*" state)
               (string-match "finished" state))
           (kill-buffer (current-buffer)))
       ))
    ))

(defun sbw/kill-this-buffer ()
  "Kill the current buffer."
  (interactive)
  (kill-buffer (current-buffer)))
