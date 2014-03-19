;; Sessions
; (require 'saveplace)
; (setq-default save-place t)
; (setq save-place-file (expand-file-name "~/.emacs.d/places"))
; (setq session-save-file (expand-file-name "~/.emacs.d/session"))
;
; (require 'session nil t)
; (setq session-initialize t)
; (setq session-globals-include
;       '((kill-ring 50 t)
;         (session-file-alist 100 t)
;         (file-name-history 200 t)))
;
; (add-hook 'after-init-hook 'session-initialize)

(setq debug-on-error nil)

(desktop-save-mode 1) ; 0 for off
(setq desktop-save-mode t)
