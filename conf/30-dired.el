;; allow dired to be able to delete or copy a whole dir.
;; “always” means no asking. “top” means ask once. Any other symbol means ask each and every time for a dir and subdir.
(setq dired-recursive-copies (quote always))
(setq dired-recursive-deletes (quote top))

;; use other as target if two dired-buffers are visible
(setq dired-dwim-target t)

; dired-single
(require 'dired-single)
(defun sbw/dired-init ()
  "Bunch of stuff to run for dired, either immediately or when it's
   loaded."

  ;; dired-x will be loaded by ELPA anyways, so we can force it here
  ;; and ensure we can mangle its keymap
  (require 'dired-x)
  (global-unset-key (kbd "C-x C-j"))

  ;; <add other stuff here>
  (define-key dired-mode-map [return] 'dired-single-buffer)
  (define-key dired-mode-map [mouse-1] 'dired-single-buffer-mouse)
  (define-key dired-mode-map "^"
    (function
     (lambda nil (interactive) (dired-single-buffer ".."))))
  (define-key dired-mode-map [backspace]
    (function
     (lambda nil (interactive) (dired-single-buffer ".."))))
)

;; if dired's already loaded, then the keymap will be bound
(if (boundp 'dired-mode-map)
  ;; we're good to go; just add our bindings
  (sbw/dired-init)
  ;; it's not loaded yet, so add our bindings to the load-hook
  (add-hook 'dired-load-hook 'sbw/dired-init))
