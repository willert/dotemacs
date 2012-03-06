;;; 40-eproject.el ---

(require 'eproject)
(require 'eproject-extras)

(global-set-key (kbd "C-x p k") 'eproject-kill-project-buffers)
(global-set-key (kbd "C-x p v") 'eproject-revisit-project)
(global-set-key (kbd "C-x p b") 'eproject-ibuffer)
(global-set-key (kbd "C-x p o") 'eproject-open-all-project-files)
(global-set-key (kbd "C-x p f") 'eproject-find-file)

(define-project-type perl (generic)
  (or (look-for "Makefile.PL") (look-for "Build.PL") (look-for "dist.ini"))
  :relevant-files ("\.pm$" "\.t$" "\.pl$" "\.PL$")
  :irrelevant-files ("inc/" "blib/" "cover_db/" "perl5/" "mpan-dist/")
  :ack-skip-dirs ("inc" "blib" "cover_db" "perl5" "contrib" "mpan-dist")
  :local-lib-exists-p (lambda (root)
                         (file-exists-p (concat root "perl5")))
  :file-name-map (lambda (root)
                   (lambda (root file)
                     (cond ((string-match "^lib/56f01f791d23e7cb93f5fbf5fd626cc3881712f[.]pm$" file)
                            (let ((m (match-string 1 file)))
                              (while (string-match "/" m)
                                (setf m (replace-match "::" nil nil m)))
                              m))
                           (t file))))
  :main-file "Makefile.PL")

(defun sbw/perl-project-compile-command ()
  "prefill compile command for perl project files"
  (if (eproject-attribute :local-lib-exists-p)
      (set
       (make-local-variable 'compile-command)
       (format
        "cd %s; perl -Mlocal::lib=perl5 %s"
        (eproject-root) (buffer-file-name)))))

(defun sbw/perl-project-ack-arguments ()
  "ack-and-a-half arguments for perl project files"
  (require 'ack-and-a-half)
  (make-local-variable 'ack-and-a-half-arguments)
  (map 'list
       (lambda (e)
         (pushnew (format "--ignore-dir=%s" e)
                  ack-and-a-half-arguments
                  :test 'string=))
       (eproject-attribute :ack-skip-dirs)
       ))


(defun sbw/perl-project-setup-epod-dirs ()
  "prefill compile command for perl project files"
  (make-local-variable 'epod-local-lib-dirs)
  (if (not (boundp 'epod-local-lib-dirs)) (setq epod-local-lib-dirs nil))
  (if (eproject-attribute :local-lib-exists-p)
      (pushnew
       (format "%sperl5/" (eproject-root))
       epod-local-lib-dirs :test 'string=)
))

(add-hook 'perl-project-file-visit-hook 'sbw/perl-project-compile-command)
(add-hook 'perl-project-file-visit-hook 'sbw/perl-project-ack-arguments)
(add-hook 'perl-project-file-visit-hook 'sbw/perl-project-setup-epod-dirs)
