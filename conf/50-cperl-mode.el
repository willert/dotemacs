(load "cperl-mode/cperl-mode")

(fset 'perl-mode 'cperl-mode)

(setq auto-mode-alist (cons '("\\.t$"      . cperl-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.pl$"     . cperl-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.pm$"     . cperl-mode) auto-mode-alist))

(setq sbw/prove-project-directories "t/")

; nicer default compile command
(defun sbw/cperl-compile-command ()
  (let ((root (catalyst-server-find-root)))
     (set (make-local-variable 'compile-command)
          (concat
           "perl"
           " -Mlocal::lib=" root "perl5"
           " -I" root "lib"
           " " buffer-file-name
           ))))

(add-hook 'cperl-mode-hook 'sbw/cperl-compile-command)

; (load "conf/perly-sense")

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

