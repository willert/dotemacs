(global-set-key (kbd "C-x u")   'kill-line-to-cursor )

(global-set-key (kbd "C-x k")   'kill-this-buffer)
(global-set-key (kbd "C-x C-k") 'kill-buffer)

(global-set-key (kbd "C-x <down>")  'bury-buffer)

(global-set-key (kbd "C-l")  'goto-line)

(global-set-key (kbd "C-x C-a") 'ack-here)

(global-set-key (kbd "C-x c l") 'goto-last-change)
(global-set-key (kbd "C-x c k") 'delete-current-buffer-file)
(global-set-key (kbd "C-x c r") 'rename-current-buffer-file)

(global-set-key (kbd "C-z") 'undo)


(global-set-key (kbd "C-x x") 'repeat)

(global-set-key (kbd "<pause>") 'toggle-window-dedicated)

(global-set-key (kbd "M-j") (lambda () (interactive) (join-line -1)))

;;; register handling
(global-set-key (kbd "C-x C-p") 'copy-to-register)
(global-set-key (kbd "C-x C-y")  'insert-register)

;;; safer exit command
(setq sbw/safer-exit-map (make-sparse-keymap))
(define-key sbw/safer-exit-map (kbd "C-c") 'save-buffers-kill-terminal)
(define-key sbw/safer-exit-map (kbd "C-k") 'sbw/shutdown-emacs-server)
(global-set-key (kbd "C-x C-c") sbw/safer-exit-map)

(defun sbw/remove-conflicting-keys (mode-map)
  (define-key mode-map (kbd "M-<left>" ) nil)
  (define-key mode-map (kbd "M-<right>") nil)
  (define-key mode-map (kbd "M-<up>"   ) nil)
  (define-key mode-map (kbd "M-<down>" ) nil)
  )
;;; windmove mappings
(windmove-default-keybindings 'meta)
(transpose-window-default-keybindings)

(sbw/remove-conflicting-keys magit-mode-map)

;;; eval commands for lisp
(setq lisp-evaluation-map (make-sparse-keymap))
(define-key lisp-evaluation-map (kbd "r") 'eval-region)
(define-key lisp-evaluation-map (kbd "d") 'eval-defun)
(define-key lisp-evaluation-map (kbd "b") 'eval-buffer)
(define-key lisp-mode-map (kbd "\C-ce") lisp-evaluation-map)
(define-key emacs-lisp-mode-map (kbd "\C-ce") lisp-evaluation-map)
(define-key lisp-interaction-mode-map (kbd "\C-ce") lisp-evaluation-map)

;;; emasc config
(setq emacs-configuration-map (make-sparse-keymap))
(define-key emacs-configuration-map (kbd "b")
  '(lambda () (interactive) (find-file "~/.emacs.d/conf/99-bindings.el" )))
(define-key emacs-configuration-map (kbd "c")
  '(lambda () (interactive) (find-file "~/.emacs.d/conf/50-cperl-mode.el" )))
(define-key emacs-configuration-map (kbd "m")
  '(lambda () (interactive) (find-file "~/.emacs.d/conf/10-modules.el" )))
(define-key emacs-configuration-map (kbd "f")
  '(lambda () (interactive) (find-file "~/.emacs.d/conf/10-functions.el" )))
(global-set-key (kbd "C-c C-e") emacs-configuration-map)

;;; prove related stuff
(setq run-and-prove-map (make-sparse-keymap))
(define-key run-and-prove-map (kbd "r") 'ps/rerun-file)
(define-key run-and-prove-map (kbd "p") 'sbw/prove-project)
(define-key run-and-prove-map (kbd "P") 'sbw/prove-whole-project)
(global-set-key (kbd "C-o r") run-and-prove-map)

(global-set-key (kbd "C-c C-s") (lambda () (interactive) (call-interactively 'shell) ))
(global-set-key (kbd "C-c C-s") (lambda () (interactive) (call-interactively 'shell) ))
(defun sbw/shell-key-bindings ()
  (define-key shell-mode-map (kbd "C-c C-s") nil)
  (define-key shell-mode-map (kbd "C-c l") 'sbw/clear-shell)
  )

(add-hook 'shell-mode-hook 'sbw/shell-key-bindings)
(defun sbw/comint-key-bindings ()
  (define-key comint-mode-map (kbd "C-c C-s") nil)
  (define-key comint-mode-map (kbd "C-c l") 'sbw/clear-shell)
  )
(add-hook 'comint-mode-hook 'sbw/comint-key-bindings)


(add-hook 'eproject-first-buffer-hook 'sbw/eproject-key-bindings)

(defun sbw/eproject-key-bindings ()
  (define-key eproject-mode-map (kbd "C-c p a") 'ack)
  (define-key eproject-mode-map (kbd "C-c p b") 'eproject-ibuffer)
  (define-key eproject-mode-map (kbd "C-c p c") 'catalyst-server-start-or-show-process)
  (define-key eproject-mode-map (kbd "C-c p f") 'eproject-find-file)
  (define-key eproject-mode-map (kbd "C-c p g") 'magit-status)
  (define-key eproject-mode-map (kbd "C-c p k") 'eproject-kill-project-buffers)
  (define-key eproject-mode-map (kbd "C-c p m") 'sbw/perl-project-mist-init)
  (define-key eproject-mode-map (kbd "C-c p o") 'eproject-open-all-project-files)
  (define-key eproject-mode-map (kbd "C-c p p") 'plackup-server/start-or-show-process)
  (define-key eproject-mode-map (kbd "C-c p s") 'sbw/open-shell-in-project-root)
  (define-key eproject-mode-map (kbd "C-c p v") 'eproject-revisit-project)

  (define-key eproject-mode-map (kbd "C-c f c")
    (lambda () (interactive)
      (sbw/find-file-in-dir  (eproject-attribute :lib-base-path) "Controller")))

  (define-key eproject-mode-map (kbd "C-c f m")
    (lambda () (interactive)
      (sbw/find-file-in-dir  (eproject-attribute :lib-base-path) "Model")))

  (define-key eproject-mode-map (kbd "C-c f v")
    (lambda () (interactive)
      (sbw/find-file-in-dir  (eproject-attribute :lib-base-path) "View")))

  (define-key eproject-mode-map (kbd "C-c f r")
    (lambda () (interactive)
      (sbw/find-file-in-dir  (eproject-attribute :lib-base-path) "Schema" "Result")))

  (define-key eproject-mode-map (kbd "C-c f R")
    (lambda () (interactive)
      (sbw/find-file-in-dir  (eproject-attribute :lib-base-path) "Schema" "ResultSet")))

  (define-key eproject-mode-map (kbd "C-c f f")
    (lambda () (interactive)
      (sbw/find-file-in-dir  (eproject-attribute :lib-base-path "Form"))))

  (define-key eproject-mode-map (kbd "C-c f RET")
    (lambda () (interactive)
      (sbw/find-file-in-dir  (eproject-attribute :lib-base-path))))

  (define-key eproject-mode-map (kbd "C-c F c")
    (lambda () (interactive)
      (sbw/find-file-in-dir  (eproject-root) "root" "comps")))

  (define-key eproject-mode-map (kbd "C-c F b")
    (lambda () (interactive)
      (sbw/find-file-in-dir  (eproject-root) "root" "cms")))

  (define-key eproject-mode-map (kbd "C-c F l")
    (lambda () (interactive)
      (sbw/find-file-in-dir  (eproject-root) "share" "layout")))

  (define-key eproject-mode-map (kbd "C-c F RET")
    (lambda () (interactive)
      (sbw/find-file-in-dir  (eproject-root) "root")))
)

;;; iswitchb
(global-set-key (kbd "C-x b") 'iswitchb-buffer)


(global-set-key (kbd "C-x r t") 'string-rectangle)
(global-set-key (kbd "C-x r k") 'string-rectangle-kill)
(global-set-key (kbd "C-x r p") 'copy-rectangle-as-kill)

(define-key magit-mode-map (kbd "/") 'magit-stash)

(global-set-key (kbd "C-c i") 'ielm-for-this-buffer)

(global-set-key (kbd "C-p") 'sbw/set-region)

(global-unset-key (kbd "C-x C-z"))
(global-set-key (kbd "C-x C-z f") 'yas/visit-snippet-file)
(global-set-key (kbd "C-x C-z n") 'yas/new-snippet)
(global-set-key (kbd "C-x C-z v") 'yas/visit-snippet-file)


(defun sbw/cperl-key-bindings ()
  (define-key cperl-mode-map (kbd "C-c a") 'align)
  (define-key cperl-mode-map (kbd "C-c o") 'ps/find-source-for-module-at-point)

  (define-key cperl-mode-map (kbd "C-c h") 'sbw/perldoc-this)

  ;; make room for our emacs config prefix
  (define-key cperl-mode-map (kbd "C-c C-e") nil)

  ;; make room for our ack command
  (define-key cperl-mode-map (kbd "C-x C-a") nil)

  (define-key cperl-mode-map (kbd "C-o e c") 'flymake-start-syntax-check)
  (define-key cperl-mode-map (kbd "C-o e p") 'flymake-goto-and-show-previous-error)
  (define-key cperl-mode-map (kbd "C-o e n") 'flymake-goto-and-show-next-error)

  (define-key cperl-mode-map (kbd "C-o r c") 'ps/run-file)

  (define-key cperl-mode-map (kbd "C-o m m") 'sbw/metacpan-search)

  (define-key cperl-mode-map (kbd "C-o s p") 'cperl-pod-spell)
  (define-key cperl-mode-map (kbd "C-o s h") 'cperl-here-doc-spell))

(add-hook 'cperl-mode-hook 'sbw/cperl-key-bindings)

(defun sbw/dired-key-bindings ()
  ;; make room for our perl related config prefix
  (define-key dired-mode-map (kbd "C-o") nil)
  )
(add-hook 'dired-mode-hook 'sbw/dired-key-bindings)

(defun sbw/help-key-bindings ()
  ;; make room for our perl related config prefix
  (define-key help-mode-map (kbd "<backspace>") 'help-go-back)
  (define-key help-mode-map (kbd "M-p") 'help-go-back)
  (define-key help-mode-map (kbd "M-n") 'help-go-forward)
  )
(add-hook 'help-mode-hook 'sbw/help-key-bindings)

(defun sbw/eshell-key-bindings ()
  (define-key eshell-mode-map (kbd "<up>") nil)
  (define-key eshell-mode-map (kbd "<down>") nil)
  )
(add-hook 'eshell-mode-hook 'sbw/eshell-key-bindings)

(require 'key-chord)
(key-chord-define nxhtml-mode-map ",." "<%  %>\C-b\C-b\C-b")
(key-chord-define nxhtml-mode-map "&&" "<&  &>\C-b\C-b\C-b")
(key-chord-define nxhtml-mode-map "<>" "<%perl>  </%perl>\C-b\C-b\C-b\C-b\C-b\C-b\C-b\C-b\C-b")

(global-set-key
 (kbd "C-x F")
 (lambda () (interactive)
   (let ((default-directory (eproject-root)))
     (call-interactively 'find-file))))
