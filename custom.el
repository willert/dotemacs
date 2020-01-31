(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(csv-separators (quote (";" "~")))
 '(ibuffer-default-sorting-mode (quote filename/process))
 '(ibuffer-expert t)
 '(ibuffer-use-header-line nil)
 '(ido-show-dot-for-dired t)
 '(ido-use-filename-at-point (quote guess))
 '(ido-use-url-at-point nil)
 '(package-selected-packages (quote (twittering-mode moz-controller jabber circe)))
 '(safe-local-variable-values
   (quote
    ((compass-task . "prepare-release")
     (compass-task . "css")
     (compass-command . "compass")
     (compass-task . "compile")
     (sbw/prove-project-directories . "t/ t/acceptance/")
     (compass-command . "grunt")
     (compass-task . "default"))))
 '(treemacs-position (quote left))
 '(treemacs-width 60))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diff-file-header ((t (:background "dark slate gray" :weight bold))))
 '(fringe ((t (:foreground "#dddddd"))))
 '(highlight ((t (:background "midnight blue"))))
 '(jabber-chat-prompt-foreign ((t (:foreground "gold" :weight bold))))
 '(jabber-chat-prompt-local ((t (:foreground "deep sky blue" :weight bold))))
 '(jabber-rare-time-face ((t (:foreground "light green" :underline t))))
 '(jabber-roster-user-away ((t (:foreground "dark green" :slant italic :weight normal))))
 '(jabber-roster-user-offline ((t (:foreground "gray21" :slant italic :weight light))))
 '(jabber-roster-user-online ((t (:foreground "light green" :slant normal :weight bold))))
 '(jabber-roster-user-xa ((t (:foreground "dark green" :slant italic :weight normal))))
 '(jabber-title-large ((t (:inherit variable-pitch :weight bold :height 1.0 :width ultra-expanded))))
 '(jabber-title-medium ((t (:inherit variable-pitch :weight bold :height 1.0 :width expanded))))
 '(magit-diff-file-header ((t (:inherit magit-diff-hunk-header :box (:line-width 2 :color "#0b2626")))))
 '(magit-diff-hunk-header ((t (:slant italic :weight bold))))
 '(magit-item-highlight ((t (:background "dark slate gray"))))
 '(treemacs-root-face ((t (:inherit font-lock-constant-face :weight bold))))
 '(whitespace-tab ((t (:foreground "#123838"))))
 '(whitespace-trailing ((t (:background "#093030")))))
