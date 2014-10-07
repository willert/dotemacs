(require 'twittering-mode)

; default: "%i %s,  %@:\n%FILL[  ]{%T // from %f%L%r%R}\n"
; fancy: "%FOLD{%RT{%FACE[bold]{RT}}%i%s %@{}\n%FOLD[ ]{%T%RT{\nretweeted by %s @%C{%Y-%m-%d %H:%M:%S}}}}\n"
(setq twittering-status-format "%FOLD{%i%s %@{}%RT{ retweeted by %s}\n\n%FOLD[ ]{%T}}\n")

(setq twittering-use-master-password t)
(setq twittering-icon-mode t)                ; Show icons
(setq twittering-timer-interval 300)         ; Update your timeline each 300 seconds (5 minutes)
(setq twittering-url-show-status nil)        ; Keeps the echo area from showing all the http processes
