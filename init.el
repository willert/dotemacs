(defvar emacs-conf-path
  "~/.emacs.d/conf/"
  "The full path to the emacs config directory")

(defvar emacs-lib-path
  "~/.emacs.d/lib/"
  "The full path to the emacs external lib directory")

(add-to-list 'load-path emacs-lib-path)
(load (concat emacs-lib-path "load-paths.el"))

(require 'package)
(package-initialize)

(dolist (file (directory-files emacs-conf-path t "^[0-9]+.*\\.el$"))
  (load file))

(load (concat emacs-lib-path "private-conf.el"))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)
