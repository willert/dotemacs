;;; 40-eproject.el ---

(require 'eproject)
(require 'eproject-extras)

;; eproject global bindings
(defmacro .emacs-curry (function &rest args)
  `(lambda () (interactive)
     (,function ,@args)))

(defmacro .emacs-eproject-key (key command)
  (cons 'progn
        (loop for (k . p) in (list (cons key 4) (cons (upcase key) 1))
              collect
              `(global-set-key
                (kbd ,(format "C-x p %s" k))
                (.emacs-curry ,command ,p)))))

(.emacs-eproject-key "k" eproject-kill-project-buffers)
(.emacs-eproject-key "v" eproject-revisit-project)
(.emacs-eproject-key "b" eproject-ibuffer)
(.emacs-eproject-key "o" eproject-open-all-project-files)


(define-project-type perl (generic)
  (or (look-for "Makefile.PL") (look-for "Build.PL") (look-for "dist.ini"))
  :relevant-files ("\.pm$" "\.t$" "\.pl$" "\.PL$")
  :irrelevant-files ("inc/" "blib/" "cover_db/")
;  :mxdeclare-project-p (lambda (root)
;                         (file-exists-p (concat root ".mxdeclare_project")))
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

;(defun cperl-mxdeclare-project-p ()
;  "Determine if this project should use MooseX::Declare class definitions."
;  (ignore-errors
;    (eproject-attribute :is-mxdeclare-project)))


(add-hook
 'perl-project-file-visit-hook
 (lambda ()
   (if (eproject-attribute :local-lib-exists-p)
       (set
        (make-local-variable 'compile-command)
        (format
         "cd %s; perl -Mlocal::lib=perl5 %s"
         (eproject-root) (buffer-file-name))
        ))))
