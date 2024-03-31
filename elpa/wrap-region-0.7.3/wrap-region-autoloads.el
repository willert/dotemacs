;;; wrap-region-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "wrap-region" "wrap-region.el" (0 0 0 0))
;;; Generated autoloads from wrap-region.el

(autoload 'wrap-region-mode "wrap-region" "\
Wrap region with stuff.

This is a minor mode.  If called interactively, toggle the
`wrap-Region mode' mode.  If the prefix argument is positive,
enable the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `wrap-region-mode'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(autoload 'turn-on-wrap-region-mode "wrap-region" "\
Turn on `wrap-region-mode'." t nil)

(autoload 'turn-off-wrap-region-mode "wrap-region" "\
Turn off `wrap-region-mode'." t nil)

(put 'wrap-region-global-mode 'globalized-minor-mode t)

(defvar wrap-region-global-mode nil "\
Non-nil if Wrap-Region-Global mode is enabled.
See the `wrap-region-global-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `wrap-region-global-mode'.")

(custom-autoload 'wrap-region-global-mode "wrap-region" nil)

(autoload 'wrap-region-global-mode "wrap-region" "\
Toggle Wrap-Region mode in all buffers.
With prefix ARG, enable Wrap-Region-Global mode if ARG is positive;
otherwise, disable it.

If called from Lisp, toggle the mode if ARG is `toggle'.
Enable the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

Wrap-Region mode is enabled in all buffers where
`turn-on-wrap-region-mode' would do it.

See `wrap-region-mode' for more information on Wrap-Region mode.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "wrap-region" '("wrap-region-"))

;;;***

;;;### (autoloads nil nil ("wrap-region-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; wrap-region-autoloads.el ends here
