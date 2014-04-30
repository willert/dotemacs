(require 'circe)

(setq circe-reduce-lurker-spam t)

(defun sbw/clear-lui-buffer ()
  (interactive)
  (let ((lui-max-buffer-size 100))
    (lui-truncate)))

(defun sbw/circe-channel-hook ()
  (setq-local paragraph-start "")
  (setq-local paragraph-separate "^\\*\\*\\*")
  (setq-local lui-max-buffer-size 50000)
  (define-key circe-channel-mode-map (kbd "C-c l") 'sbw/clear-lui-buffer)
)

(add-hook 'circe-channel-mode-hook 'sbw/circe-channel-hook)

(setq lui-flyspell-p t
      lui-flyspell-alist '(("#hamburg" "german8")
                           (".*" "american")))
(defun circe-network-connected-p (network)
  "Return non-nil if there's any Circe server-buffer whose
`circe-server-netwok' is NETWORK."
  (catch 'return
    (dolist (buffer (circe-server-buffers))
      (with-current-buffer buffer
        (if (string= network circe-server-network)
            (throw 'return t))))))

(defun circe-maybe-connect (network)
  "Connect to NETWORK, but ask user for confirmation if it's
already been connected to."
  (interactive "sNetwork: ")
  (if (or (not (circe-network-connected-p network))
          (y-or-n-p (format "Already connected to %s, reconnect?" network)))
      (circe network)))

(setq
 lui-time-stamp-position 'right-margin
 lui-fill-type nil)

(add-hook 'lui-mode-hook 'my-lui-setup)
(defun my-lui-setup ()
  (setq
   fringes-outside-margins t
   right-margin-width 5
   word-wrap t
   wrap-prefix "    "))
