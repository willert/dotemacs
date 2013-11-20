(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(csv-separators (quote (";" "~")))
 '(jabber-account-list (quote (("willert@inaptitu.de" (:password . "ChangeMe")))))
 '(jabber-alert-message-hooks (quote (jabber-message-libnotify jabber-message-echo jabber-message-scroll)))
 '(jabber-alert-presence-hooks nil)
 '(jabber-chat-buffer-format "%n|%j")
 '(jabber-chat-fill-long-lines nil)
 '(jabber-connection-ssl-program (quote gnutls))
 '(jabber-invalid-certificate-servers (quote ("inaptitu.de")))
 '(safe-local-variable-values (quote ((sbw/prove-project-directories . "t/ t/acceptance/") (compass-command . "grunt") (compass-task . "default")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diff-file-header ((t (:background "dark slate gray" :weight bold))))
 '(highlight ((t (:background "midnight blue"))))
 '(jabber-chat-prompt-foreign ((t (:foreground "gold" :weight bold))))
 '(jabber-chat-prompt-local ((t (:foreground "deep sky blue" :weight bold))))
 '(jabber-rare-time-face ((t (:foreground "light green" :underline t))))
 '(magit-diff-file-header ((t (:inherit magit-diff-hunk-header :box (:line-width 2 :color "#0b2626")))))
 '(magit-diff-hunk-header ((t (:slant italic :weight bold))))
 '(magit-item-highlight ((t (:background "dark slate gray"))))
 '(whitespace-tab ((t (:foreground "#123838"))))
 '(whitespace-trailing ((t (:background "#093030")))))
