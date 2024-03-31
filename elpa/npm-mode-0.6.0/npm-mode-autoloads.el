;;; npm-mode-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "npm-mode" "npm-mode.el" (0 0 0 0))
;;; Generated autoloads from npm-mode.el

(autoload 'npm-mode "npm-mode" "\
Minor mode for working with npm projects.

This is a minor mode.  If called interactively, toggle the `Npm
mode' mode.  If the prefix argument is positive, enable the mode,
and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `npm-mode'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(put 'npm-global-mode 'globalized-minor-mode t)

(defvar npm-global-mode nil "\
Non-nil if Npm-Global mode is enabled.
See the `npm-global-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `npm-global-mode'.")

(custom-autoload 'npm-global-mode "npm-mode" nil)

(autoload 'npm-global-mode "npm-mode" "\
Toggle Npm mode in all buffers.
With prefix ARG, enable Npm-Global mode if ARG is positive; otherwise,
disable it.

If called from Lisp, toggle the mode if ARG is `toggle'.
Enable the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

Npm mode is enabled in all buffers where `npm-mode' would do it.

See `npm-mode' for more information on Npm mode.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "npm-mode" '("npm-mode-"))

;;;***

;;;### (autoloads nil nil ("npm-mode-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; npm-mode-autoloads.el ends here
