(global-set-key "\C-xu" 'kill-line-to-cursor )

(global-set-key "\C-xk" 'kill-this-buffer)
(global-set-key "\C-x\C-k" 'kill-buffer)

(global-set-key (kbd "C-x <down>")  'bury-buffer)

(global-set-key "\C-l"  'goto-line)

(global-set-key "\C-x\C-a" 'ack-here)

(global-set-key (kbd "\C-xcl") 'goto-last-change)
(global-set-key (kbd "C-z") 'undo)


(global-set-key (kbd "\C-xx") 'repeat)

(global-set-key [pause] 'toggle-window-dedicated)

; register handling
(global-set-key (kbd "\C-x\C-p") 'copy-to-register)
(global-set-key (kbd "\C-x\C-y")  'insert-register)

;;; safer exit command
(setq sbw/safer-exit-map (make-sparse-keymap))
(define-key sbw/safer-exit-map "\C-c" 'save-buffers-kill-terminal)
(define-key sbw/safer-exit-map "\C-k" 'sbw/shutdown-emacs-server)
(global-set-key (kbd "\C-x\C-c") sbw/safer-exit-map)

(defun sbw/remove-conflicting-keys (mode-map)
  (define-key mode-map (kbd "M-<left>") nil)
  (define-key mode-map (kbd "M-<right>") nil)
  (define-key mode-map (kbd "M-<up>") nil)
  (define-key mode-map (kbd "M-<down>") nil)
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
  '(lambda () (interactive) (find-file "~/.emacs.d/conf/bindings.el" )))
(define-key emacs-configuration-map (kbd "c")
  '(lambda () (interactive) (find-file "~/.emacs.d/conf/cperl-mode.el" )))
(define-key emacs-configuration-map (kbd "m")
  '(lambda () (interactive) (find-file "~/.emacs.d/conf/modules.el" )))
(define-key emacs-configuration-map (kbd "f")
  '(lambda () (interactive) (find-file "~/.emacs.d/conf/functions.el" )))
(global-set-key (kbd "\C-c\C-e") emacs-configuration-map)

;;; prove related stuff
(setq run-and-prove-map (make-sparse-keymap))
(define-key run-and-prove-map (kbd "r") 'ps/rerun-file)
(define-key run-and-prove-map (kbd "p") 'sbw/prove-project)
(define-key run-and-prove-map (kbd "P") 'sbw/prove-whole-project)
(global-set-key (kbd "\C-or") run-and-prove-map)

(global-set-key (kbd "\C-c\C-s") (lambda () (interactive) (call-interactively 'shell) ))
(global-set-key (kbd "\C-c\C-s") (lambda () (interactive) (call-interactively 'shell) ))
(defun sbw/shell-key-bindings ()
  (define-key shell-mode-map (kbd "\C-c\C-s") nil)
  (define-key shell-mode-map (kbd "\C-cl") 'sbw/clear-shell)
)
(add-hook 'shell-mode-hook 'sbw/shell-key-bindings)
(defun sbw/comint-key-bindings ()
  (define-key comint-mode-map (kbd "\C-c\C-s") nil)
  (define-key comint-mode-map (kbd "\C-cl") 'sbw/clear-shell)
)
(add-hook 'comint-mode-hook 'sbw/comint-key-bindings)


;;; iswitchb
(global-set-key (kbd "\C-xb") 'iswitchb-buffer)


(global-set-key "\C-xrt" 'string-rectangle)
(global-set-key "\C-xrk" 'string-rectangle-kill)
(global-set-key "\C-xrp" 'copy-rectangle-as-kill)

(global-set-key (kbd "\C-cpc") 'catalyst-server-start-or-show-process)

(global-set-key (kbd "\C-cpg") 'magit-status)
(global-set-key (kbd "\C-cps") 'sbw/open-shell-in-project-root)

(define-key magit-mode-map (kbd "/") 'magit-stash)

(global-set-key (kbd "\C-ci") 'ielm-for-this-buffer)

(global-set-key (kbd "\C-p") 'sbw/set-region)

(global-set-key (kbd "\C-cyf") 'yas/find-snippets)
(global-set-key (kbd "\C-cyn") 'yas/new-snippet)
(global-set-key (kbd "\C-cys") 'yas/insert-snippet)
(global-set-key (kbd "\C-cyv") 'yas/visit-snippet-file)


(defun sbw/cperl-key-bindings ()
  (define-key cperl-mode-map (kbd "\C-ca") 'align)
  (define-key cperl-mode-map (kbd "\C-co") 'ps/find-source-for-module-at-point)

  (define-key cperl-mode-map (kbd "\C-ch") 'sbw/perldoc-this)

  ;; make room for our emacs config prefix
  (define-key cperl-mode-map (kbd "\C-c\C-e") nil)

  ;; make room for our ack command
  (define-key cperl-mode-map (kbd "\C-x\C-a") nil)

  (define-key cperl-mode-map (kbd "\C-oec") 'flymake-start-syntax-check)
  (define-key cperl-mode-map (kbd "\C-oep") 'flymake-goto-and-show-previous-error)
  (define-key cperl-mode-map (kbd "\C-oen") 'flymake-goto-and-show-next-error)

  (define-key cperl-mode-map (kbd "\C-orc") 'ps/run-file)

  (define-key cperl-mode-map (kbd "\C-omm") 'sbw/metacpan-search)

  (define-key cperl-mode-map (kbd "\C-osp") 'cperl-pod-spell)
  (define-key cperl-mode-map (kbd "\C-osh") 'cperl-here-doc-spell))

(add-hook 'cperl-mode-hook 'sbw/cperl-key-bindings)

(defun sbw/dired-key-bindings ()
  ;; make room for our perl related config prefix
  (define-key dired-mode-map (kbd "\C-o") nil)
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


(global-set-key (kbd "C-x p k") 'eproject-kill-project-buffers)
(global-set-key (kbd "C-x p v") 'eproject-revisit-project)
(global-set-key (kbd "C-x p b") 'eproject-ibuffer)
(global-set-key (kbd "C-x p o") 'eproject-open-all-project-files)
(global-set-key (kbd "C-x p f") 'eproject-find-file)
(global-set-key (kbd "C-x p a") 'ack)

(global-set-key (kbd "C-x F")
                (lambda () (interactive)
                  (let ((default-directory (eproject-root)))
                    (call-interactively 'find-file))))
