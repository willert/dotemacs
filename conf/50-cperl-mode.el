(require 'cperl-mode)
(fset 'perl-mode 'cperl-mode)

(setq auto-mode-alist (cons '("\\.t$"      . cperl-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.pl$"     . cperl-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.pm$"     . cperl-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.mp$"     . cperl-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.psgi$"   . cperl-mode) auto-mode-alist))

(setq auto-mode-alist (cons '("cpanfile$"   . cperl-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("mistfile$"   . cperl-mode) auto-mode-alist))

(setq auto-mode-alist (cons '("\\.yml$"    . yaml-mode) auto-mode-alist))

(setq sbw/prove-project-directories "t/")

(setq
 cperl-font-lock t
 cperl-electric-parens nil
 cperl-electric-linefeed t
 cperl-electric-keywords nil
 cperl-info-on-command-no-prompt nil
 cperl-indent-level 2
 cperl-close-paren-offset -2
 cperl-continued-statement-offset 2
 cperl-indent-parens-as-block t
 cperl-tab-always-indent t
 cperl-indent-subs-specially nil)

(set-face-attribute
 'cperl-array-face nil
 :background nil)


; plackup server mode
(require 'plackup-server)

; epod
(add-to-list 'load-path "~/Devel/ePod/lisp")
(require 'epod)
