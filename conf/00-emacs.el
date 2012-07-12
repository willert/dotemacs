;; ---------------------------------------------------------------------------
;; Emacs behavior
;; ---------------------------------------------------------------------------

; Warning behavior:
; http://www.gnu.org/s/emacs/manual/html_node/elisp/Warning-Options.html

(setq inhibit-splash-screen t)
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

(line-number-mode t)
(column-number-mode t)
(transient-mark-mode t)
(display-time-mode t)

(show-paren-mode t)

(setq indent-tabs-mode nil)
(setq backup-inhibited t)
(setq scroll-step 1 )
(setq remote-shell-program '/usr/bin/ssh)

(setq require-final-newline t)
(setq next-line-add-newlines nil)

;; Makes things a little bit more consistent.
(fset 'yes-or-no-p 'y-or-n-p)

;; Filename completion ignores these.
(setq completion-ignored-extensions
      (append completion-ignored-extensions
              '(".bak" ".BAK" ".ps" ".pdf")))

(put 'set-goal-column  'disabled nil)
(put 'eval-expression  'disabled nil)
(put 'downcase-region  'disabled nil)
(put 'upcase-region    'disabled nil)
(put 'narrow-to-region 'disabled nil)

(setq trim-versions-without-asking t)
(setq delete-old-versions t)

(setq visible-bell nil)
(setq ring-bell-function (defun no-bell()()) )

(setq default-tab-width 2)
(setq mouse-yank-at-point t)

(setq windmove-wrap-around nil)

(setq enable-recursive-minibuffers nil)

(add-hook 'isearch-mode-end-hook 'my-goto-match-beginning)
(defun my-goto-match-beginning ()
  (when (and isearch-forward (not isearch-mode-end-hook-quit))
    (goto-char isearch-other-end)))

(defadvice isearch-exit (after my-goto-match-beginning activate)
  "Go to beginning of match."
  (when isearch-forward (goto-char isearch-other-end)))

(setq eval-expression-debug-on-error nil)

(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

(winner-mode)

;; as suggested by http://www.method-combination.net/blog/archives/2011/03/11/speeding-up-emacs-saves.html
(setq vc-handled-backends nil)

;; If the *scratch* buffer is killed, recreate it automatically
;; FROM: Morten Welind
(save-excursion
  (set-buffer (get-buffer-create "*scratch*"))
  (lisp-interaction-mode)
  (make-local-variable 'kill-buffer-query-functions)
  (add-hook 'kill-buffer-query-functions 'kill-scratch-buffer))

(defun kill-scratch-buffer ()
  ;; The next line is just in case someone calls this manually
  (set-buffer (get-buffer-create "*scratch*"))
  ;; Kill the current (*scratch*) buffer
  (remove-hook 'kill-buffer-query-functions 'kill-scratch-buffer)
  (kill-buffer (current-buffer))
  ;; Make a brand new *scratch* buffer
  (set-buffer (get-buffer-create "*scratch*"))
  (lisp-interaction-mode)
  (make-local-variable 'kill-buffer-query-functions)
  (add-hook 'kill-buffer-query-functions 'kill-scratch-buffer)
  ;; Since we killed it, don't let caller do that.
  nil)


(defun sbw/th-rename-tramp-buffer ()
  (when (file-remote-p (buffer-file-name))
    (rename-buffer
     (format "%s:%s"
             (file-remote-p (buffer-file-name) 'method)
             (buffer-name)))
))

(defadvice find-file (around th-find-file activate)
  "Open FILENAME using tramp's sudo method if it can't be recreated as current user."

  (let* ((fn (ad-get-arg 0))
         (file-owner-uid (nth 2 (file-attributes fn))))

    (if (and (not (file-ownership-preserved-p fn))
             (y-or-n-p (concat "File " fn " does not belong to you.  Open it as root? ")))
        (sbw/th-find-file-sudo fn)

      (if (and (= file-owner-uid (user-uid)) (not (file-writable-p fn))
               (y-or-n-p (concat "File " fn " is read-only. Make buffer writable? ")))
          (progn ad-do-it (toggle-read-only -1))

        ad-do-it))
    ))

(defun sbw/th-find-file-sudo (file)
  "Opens FILE with root privileges."
  (interactive "F")
  (set-buffer (find-file (concat "/sudo::" file)))
)


(add-hook 'find-file-hook 'sbw/th-rename-tramp-buffer)
