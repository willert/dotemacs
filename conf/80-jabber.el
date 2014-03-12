(jabber-activity-mode t) ; also autoloads jabber

(setq jabber-alert-message-hooks (quote (jabber-message-libnotify jabber-message-echo jabber-message-scroll)))
(setq jabber-alert-presence-hooks nil)
(setq jabber-chat-buffer-format "%n|%j")
(setq jabber-chat-fill-long-lines nil)
(setq jabber-connection-ssl-program (quote gnutls))
(setq jabber-invalid-certificate-servers (quote ("inaptitu.de")))
(setq jabber-connection-ssl-program (quote gnutls))

(set-face-attribute 'jabber-chat-prompt-foreign t :foreground "gold" :weight 'bold)
(set-face-attribute 'jabber-chat-prompt-local   t :foreground "deep sky blue" :weight 'bold)
(set-face-attribute 'jabber-rare-time-face      t :foreground "light green" :underline t)
