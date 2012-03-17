(require 'edmacro)
(load "iswitchb")

(defadvice iswitchb-kill-buffer (after rescan-after-kill activate)
  "*Regenerate the list of matching buffer names after a kill.
    Necessary if using `uniquify' with `uniquify-after-kill-buffer-p'
    set to non-nil."
  (setq iswitchb-buflist iswitchb-matches)
  (iswitchb-rescan))

(defun iswitchb-rescan ()
  "*Regenerate the list of matching buffer names."
  (interactive)
  (iswitchb-make-buflist iswitchb-default)
  (setq iswitchb-rescan t))

(defun iswitchb-local-keys ()
  (mapc (lambda (k)
          (let* ((key (car k))
                 (fun (cdr k)))
            (define-key iswitchb-mode-map (edmacro-parse-keys key) fun)))
        '(("C-<tab>"    . iswitchb-prev-match)
          ("M-<tab>"    . iswitchb-prev-match)
          ("<backtab>"  . iswitchb-prevj-match))))

(add-hook 'iswitchb-define-mode-map-hook 'iswitchb-local-keys)

(defun iswitchb-exclude-nonmatching()
   "Make iswitchb work on only the currently matching names."
   (interactive)
   (setq iswitchb-buflist iswitchb-matches)
   (setq iswitchb-rescan t)
   (delete-minibuffer-contents))

(add-hook 'iswitchb-define-mode-map-hook
    '(lambda () (define-key
      iswitchb-mode-map "\C-o"
      'iswitchb-exclude-nonmatching)))

(setq iswitchb-buffer-ignore
      (quote
       ( "\\*Text\\*" "\\*Groups\\*" "\\*Regex\\*"
         "\\*fsm-debug\\*" "\\*Completions\\*" "^ \\*"
         "\\*Shell Command Output\\*"
         "\\*magit-[^d]"
         "\\*-jabber-\\*" " \\[.*-mode\\]")))

(setq iswitchb-cannot-complete-hook (quote (iswitchb-next-match)))
(setq iswitchb-case nil)
(setq iswitchb-default-method (quote samewindow))
(setq iswitchb-max-to-show 6)
(iswitchb-mode t)
