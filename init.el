
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(defvar emacs-conf-path
  "~/.emacs.d/conf/"
  "The full path to the emacs config directory")

(defvar emacs-lib-path
  "~/.emacs.d/lib/"
  "The full path to the emacs external lib directory")

(add-to-list 'load-path emacs-lib-path)
(load (concat emacs-lib-path "load-paths.el"))

(dolist (file (directory-files emacs-conf-path t "^[0-9]+.*\\.el$"))
  (load file))

(load (concat emacs-lib-path "private-conf.el"))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)
