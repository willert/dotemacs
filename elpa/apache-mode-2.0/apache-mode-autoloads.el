;;; apache-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (or (file-name-directory #$) (car load-path)))

;;;### (autoloads nil "apache-mode" "apache-mode.el" (23695 37816
;;;;;;  292900 923000))
;;; Generated autoloads from apache-mode.el

(autoload 'apache-mode "apache-mode" "\
Major mode for editing Apache configuration files.

\(fn)" t nil)
(add-to-list 'auto-mode-alist '("\\.htaccess\\'"   . apache-mode))
(add-to-list 'auto-mode-alist '("httpd\\.conf\\'"  . apache-mode))
(add-to-list 'auto-mode-alist '("srm\\.conf\\'"    . apache-mode))
(add-to-list 'auto-mode-alist '("access\\.conf\\'" . apache-mode))
(add-to-list 'auto-mode-alist '("sites-\\(available\\|enabled\\)/" . apache-mode))

;;;***

;;;### (autoloads nil nil ("apache-mode-pkg.el") (23695 37816 300392
;;;;;;  312000))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; apache-mode-autoloads.el ends here
