(setq smtpmail-debug-info t) ; only to debug problems
(setq smtpmail-debug-verb t) ; only to debug problems

(setq smtpmail-stream-type 'ssl)
(setq smtpmail-default-smtp-server "smtp.gmail.com")
(setq smtpmail-smtp-server "smtp.gmail.com")
(setq smtpmail-smtp-service 465)
(setq smtpmail-local-domain nil)

(setq send-mail-function 'smtpmail-send-it)
(setq message-send-mail-function 'smtpmail-send-it)
