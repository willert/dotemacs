(require 'auto-complete)

(defun ielm-auto-complete ()
  "Enables `auto-complete' support in \\[ielm]."
  (setq ac-sources '(ac-source-functions
                     ac-source-variables
                     ac-source-features
                     ac-source-symbols
                     ac-source-words-in-same-mode-buffers))
  (add-to-list 'ac-modes 'inferior-emacs-lisp-mode)
  (auto-complete-mode 1))

(add-hook 'ielm-mode-hook 'ielm-auto-complete)

(defun ielm-kill-buffer-on-exit ()
  "Kills buffer once \\[ielm] process exits."
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
       ))))

(add-hook 'ielm-mode-hook 'ielm-kill-buffer-on-exit)

(defun ielm-for-this-buffer () (interactive) ""
  (let ((working-buffer (current-buffer)))
    (ielm-change-working-buffer working-buffer)
    (ielm)))
