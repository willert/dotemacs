;;; moz-controller-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (or (file-name-directory #$) (car load-path)))

;;;### (autoloads nil "moz-controller" "moz-controller.el" (21604
;;;;;;  38751 830579 494000))
;;; Generated autoloads from moz-controller.el

(autoload 'moz-controller-mode "moz-controller" "\
Toggle moz-controller mode.
With no argument, the mode is toggled on/off.
Non-nil argument turns mode on.
Nil argument turns mode off.

Commands:
\\{moz-controller-mode-map}

Entry to this mode calls the value of `moz-controller-mode-hook'.

\(fn &optional ARG)" t nil)

(defvar moz-controller-global-mode nil "\
Non-nil if Moz-Controller-Global mode is enabled.
See the command `moz-controller-global-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `moz-controller-global-mode'.")

(custom-autoload 'moz-controller-global-mode "moz-controller" nil)

(autoload 'moz-controller-global-mode "moz-controller" "\
Toggle Moz-Controller mode in all buffers.
With prefix ARG, enable Moz-Controller-Global mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Moz-Controller mode is enabled in all buffers where
`moz-controller-on' would do it.
See `moz-controller-mode' for more information on Moz-Controller mode.

\(fn &optional ARG)" t nil)

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; moz-controller-autoloads.el ends here
