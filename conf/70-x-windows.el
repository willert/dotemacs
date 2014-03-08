(cond
 ((or (daemonp) window-system)
  (set-face-attribute
   'default nil
   :family "DejaVu Sans Mono" :height 99
   :slant 'normal :weight 'normal :width 'normal)

  (sbw/color-theme-switch-to-nighttimes)
  (add-hook 'after-make-frame-functions 'sbw/adjust-terminal-colors t)
  (add-hook 'after-make-frame-functions 'sbw/color-theme-nighttimes)

  (add-hook 'after-make-frame-functions 'sbw/run-devilspie t)))
