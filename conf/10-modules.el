; uniquify
(require 'uniquify)
(setq uniquify-buffer-name-style (quote post-forward))
(setq uniquify-ignore-buffers-re "^\\*")

; ack mode
(require 'ack)
(setq
 ack-command
 (concat "ack " "--all --nogroup --no-color --with-filename "
         "--ignore-dir=blib --ignore-dir=contrib --ignore-dir=perl5 "))

; yaml mode
(require 'yaml-mode)

; yasnippet minor mode
(require 'yasnippet)
(yas/load-directory "~/.emacs.d/snippets")
(setq yas/trigger-key "C-<tab>")
(yas/initialize)
(yas/trigger-key-reload)

; magit mode
(require 'magit)

; espect mode
(require 'espect)

; catalyst-server mode
(require 'catalyst-server)

; highlight long lines
(require 'highlight-beyond-fill-column)
; (setq highlight-beyond-fill-column-face (quote flymake-errline))
(setq highlight-beyond-fill-column-in-modes (quote ("cperl-mode")))

(require 'goto-last-change)

(require 'template)
(setq template-default-directories (list (expand-file-name "~/.emacs.d/templates")))
(setq template-auto-insert t)
(template-initialize)

(require 'smooth-scrolling)
(setq smooth-scroll-margin 8)

(require 'transpose-window)

(require 'blooper)

; dired-single
(require 'dired-single)
(defun sbw/dired-init ()
  "Bunch of stuff to run for dired, either immediately or when it's
   loaded."
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

; eshell
(setq eshell-cmpl-cycle-completions nil)
