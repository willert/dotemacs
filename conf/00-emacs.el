;; ---------------------------------------------------------------------------
;; Emacs behavior
;; ---------------------------------------------------------------------------

; Warning behavior:
; http://www.gnu.org/s/emacs/manual/html_node/elisp/Warning-Options.html

(setq inhibit-splash-screen t)
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; Auto refresh buffers
(global-auto-revert-mode 1)

;; Also auto refresh dired, but be quiet about it
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

(line-number-mode t)
(column-number-mode t)
(transient-mark-mode t)
(display-time-mode t)

(show-paren-mode t)

(setq line-move-visual nil)
(setq indent-tabs-mode nil)
(setq backup-inhibited t)
(setq scroll-step 1 )
(setq remote-shell-program '/usr/bin/ssh)

;; disable auto-save and auto-backup
(setq auto-save-default nil)
(setq make-backup-files nil)

(setq require-final-newline t)
(setq next-line-add-newlines nil)

;; Makes things a little bit more consistent.
(fset 'yes-or-no-p 'y-or-n-p)

;; Filename completion ignores these.
(setq completion-ignored-extensions
      (append completion-ignored-extensions
              '(".bak" ".BAK" ".ps" ".pdf")))

;; don't let shell use any pagers
(setenv "PAGER" "cat")

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

    (if (file-exists-p fn)

        (if (and (not (file-ownership-preserved-p fn))
                 (y-or-n-p (concat "File " fn " does not belong to you.  Open it as root? ")))
            (sbw/th-find-file-sudo fn)

          (if (and (= file-owner-uid (user-uid)) (not (file-writable-p fn))
                   (y-or-n-p (concat "File " fn " is read-only. Make buffer writable? ")))
              (progn ad-do-it (toggle-read-only -1))

            ad-do-it))
      ad-do-it
    )))

(defun sbw/th-find-file-sudo (file)
  "Opens FILE with root privileges."
  (interactive "F")
  (set-buffer (find-file (concat "/sudo::" file)))
)


(add-hook 'find-file-hook 'sbw/th-rename-tramp-buffer)


(defun byte-compile-current-buffer ()
  "`byte-compile' current buffer if it's emacs-lisp-mode and compiled file exists."
  (interactive)
  (when (and (eq major-mode 'emacs-lisp-mode)
             (file-exists-p (byte-compile-dest-file buffer-file-name)))
    (byte-compile-file buffer-file-name)))

(add-hook 'after-save-hook 'byte-compile-current-buffer)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; Treat clipboard input as UTF-8 string first; compound text next, etc.
(setq-default x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

;; PATH, e.g. for compilation-mode
(setenv "PATH" (concat (getenv "PATH") ":/var/lib/gems/1.8/bin/"))

(setq warning-minimum-level :error)
(setq warning-minimum-log-level :error)

(setq max-mini-window-height 1)
(defun sbw/allow-mini-window-expansion ()
  (set (make-local-variable 'max-mini-window-height) 0.25)
)
(add-hook 'minibuffer-setup-hook 'sbw/allow-mini-window-expansion)

(setq enable-recursive-minibuffers t)
(minibuffer-depth-indicate-mode t)
