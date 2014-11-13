(jabber-activity-mode t) ; also autoloads jabber

; disable notifications
(setq jabber-alert-message-hooks (quote (jabber-message-scroll)))

(setq
 jabber-alert-message-hooks (quote (jabber-message-libnotify jabber-message-echo jabber-message-scroll))
 jabber-alert-presence-hooks nil
 jabber-chat-buffer-format "*Chat with %n*"
 jabber-chat-fill-long-lines nil
 jabber-connection-ssl-program (quote gnutls)
 jabber-invalid-certificate-servers (quote ("inaptitu.de"))
 jabber-chat-foreign-prompt-format "[%t] %n "
 jabber-chat-local-prompt-format "[%t] "
 jabber-roster-line-format "  %-25n %u %-8s"
 jabber-history-enabled t
 jabber-use-global-history nil
 jabber-backlog-number 40
 jabber-backlog-days 30
 jabber-chat-buffer-show-avatar nil
 jabber-vcard-avatars-retrieve nil
 jabber-roster-show-title t
 jabber-roster-show-bindings nil
 jabber-roster-show-title nil
 jabber-show-offline-contacts nil
 jabber-show-resources nil
)

(set-face-attribute 'jabber-chat-prompt-foreign t :foreground "gold" :weight 'bold)
(set-face-attribute 'jabber-chat-prompt-local   t :foreground "deep sky blue" :weight 'bold)
(set-face-attribute 'jabber-rare-time-face      t :foreground "light green" :underline t)

;; Message alert hooks
(define-jabber-alert echo "Show a message in the echo area"
  (lambda (msg)
    (unless (minibuffer-prompt)
      (message "%s" msg))))

(define-key jabber-chat-mode-map [C-return] 'newline)

(defadvice jabber-chat-buffer-send (around advice-jabber-chat-buffer-send activate)
  (interactive)
  (let ((inhibit-read-only t))
    (if (interactive-p)
        (progn
          (call-interactively (ad-get-orig-definition 'jabber-chat-buffer-send)))
      ad-do-it)
    ))


(defun sbw/jabber-chat-with (user account) (interactive)
       (let* ((jid account)
              (entry (assoc jid jabber-account-list))
              (alist (cdr entry))
              (jc (or (jabber-find-connection jid)
                      (jabber-connect (jabber-jid-user jid)
                                      (jabber-jid-server jid)
                                      (jabber-jid-resource jid)))
                  ))
         (jabber-chat-with jc user)))
