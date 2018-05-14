;;; 40-eproject.el ---

(require 'eproject)
(require 'eproject-extras)
(require 'findr)

(define-project-type perl (generic)
  (or (look-for "Makefile.PL") (look-for "Build.PL") (look-for "dist.ini") (look-for "cpanfile"))
  :relevant-files ("\.pm$" "\.t$" "\.pl$" "\.PL$")
  :irrelevant-files ("inc/" "blib/" "cover_db/" "perl5/" "^mpan-" "Makefile")
  :ack-skip-dirs ("inc" "blib" "cover_db" "perl5" "contrib" "mpan-dist" ".build")
  :local-lib-exists-p (lambda (root)
                        (file-exists-p (concat root "perl5/perl-5.14.2")))
  :file-name-map (lambda (root)
                   (lambda (root file)
                     (cond ((string-match "^lib/\\(.*\\)[.]pm$" file)
                            (let ((m (match-string 1 file)))
                              (while (string-match "/" m)
                                (setf m (replace-match "::" nil nil m)))
                              m))
                           (t file))))
  :lib-base-path (lambda (prj-root)
                   (message "Foo")
                   (let* ((root prj-root)
                         (lib (sbw/expand-dir-name root "lib"))
                         (env (car (findr "Env.pm" lib))))
                     (if env (file-name-directory env) lib))

                   )
  :main-file "Makefile.PL")


(defun* sbw/eproject--attribute-names (&optional (root (eproject-root)))
  "Lookup the attribute KEY for the eproject ROOT
ROOT defaults to the current buffer's project-root."
  (let ((attr-list (cdr (assoc root eproject-attributes-alist))))
    (loop for (key value)
          on attr-list by #'cddr
          collect key
          )
    )
)

(defun* sbw/eproject-get-project-env-alist (&optional (root (eproject-root)))
  (let* ((attr-list (sbw/eproject--attribute-names root)))
    (mapcar (lambda (key)
              (let* ((name (upcase
                          (replace-regexp-in-string
                           "-" "_"
                           (replace-regexp-in-string
                            "^:" "eproject-" (format "%S" key)))))
                    (avalue (eproject-attribute key root))
                    (value (if (stringp avalue) avalue (format "%S" avalue)
                               )))
                  `(,name . ,value)
              ))
            attr-list
            )))

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
  ; (require 'ack-and-a-half)
  (make-local-variable 'ack-and-a-half-arguments)
  (map 'list
       (lambda (e)
         (pushnew (format "--ignore-dir=%s" e)
                  ack-and-a-half-arguments
                  :test 'string=))
       (eproject-attribute :ack-skip-dirs)
       )

  (if (eproject-attribute :irrelevant-files)
      (progn
        (pushnew "--invert-file-match" ack-and-a-half-arguments
                 :test 'string=)
        (pushnew (format "-G '(?:%s)'"
                         (mapconcat (lambda (e) e)
                                    (eproject-attribute :irrelevant-files)
                                    "|"))
                 ack-and-a-half-arguments
                 :test 'string=)))

  (if (not (ack-and-a-half-type))
        (pushnew "--all" ack-and-a-half-arguments
                 :test 'string=)
      )

  )


(defun sbw/perl-project-setup-epod-dirs ()
  "prefill compile command for perl project files"
  (make-local-variable 'epod-local-lib-dirs)
  (if (not (boundp 'epod-local-lib-dirs)) (setq epod-local-lib-dirs nil))
  (if (eproject-attribute :local-lib-exists-p)
      (pushnew
       (format "%sperl5/" (eproject-root))
       epod-local-lib-dirs :test 'string=)
    ))

(defun sbw/perl-project-mist-init ()
  "Runs mist init for current project"
  (interactive)
  (compile (format "cd %s; mist init" (eproject-root)) t))

(defun sbw/perl-project-minilla-release ()
  "Runs minila release for current project"
  (interactive)
;;;  (compile (format "cd %s; ./mist-run minil release" (eproject-root)) t))
  (compile (format "cd %s; mist release --notest" (eproject-root)) t))

(defun sbw/perl-project-minilla-dist ()
  "Runs minila release for current project"
  (interactive)
;;; (compile (format "cd %s; ./mist-run minil dist" (eproject-root)) t))
  (compile (format "cd %s; mist run minil dist" (eproject-root)) t))

(defun sbw/perl-project-execute-local-init ()
  (message "Root: %s" (eproject-root))
  (let ((init-file
         (replace-regexp-in-string
          "//+" "/"
          (concat (eproject-root) "/.emacs.d/init.el"))))
    (if (file-exists-p init-file) (load init-file)))
  )

(defun sbw/perl-project-execute-local-init ()
  ; (message "Root: %s" (eproject-root))
  (let ((init-file
         (replace-regexp-in-string
          "//+" "/"
          (concat (eproject-root) "/.emacs.d/init.el"))))
    (if (file-exists-p init-file) (load init-file))))

(defun sbw/find-project-root ()
  (interactive)
   (let ((default-directory (eproject-root)))
     (call-interactively 'find-file)))

(defun* sbw/force-eproject-on-buffer (&optional (project-root default-directory))
  ;; eproject--setup-local-variables works on file and dired buffers
  ;; so lets pretend we are in dired mode instead of shell mode
  (let ((major-mode 'dired-mode))

    (let (bestroot besttype (set-before (mapcar #'car eproject-attributes-alist)))
      (loop for type in (eproject--all-types)
            do (let ((root (eproject--run-project-selector type project-root)))
                 (when (and project-root
                            (or (not bestroot)
                                ;; longest filename == best match (XXX:
                                ;; need to canonicalize?)
                                (> (length project-root) (length bestroot))))
                   (setq bestroot project-root)
                   (setq besttype type))))
      (progn ; the guts of (eproject-maybe-turn-on)
        (make-variable-buffer-local 'eproject-root)
        (setq eproject-root project-root)
        (eproject--init-attributes project-root besttype)
        (eproject-mode 1)

        ; (eproject--setup-local-variables)
))))

(defun sbw/open-shell-in-project-root ()
  "Open a shell in project root directory"
  (interactive)
  (let* ((project-root (eproject-root))
         (project-type (eproject-type))
         (project-name (car (last (split-string project-root "/" t))))
         (default-directory project-root)
         (shell-postfix
          (if current-prefix-arg
              (read-string "Buffer type (defaults to 'shell'): " nil
                           'sbw/project-shell-potfixes "shell")
            "shell"))
         (buffer-name (concat project-name "-" shell-postfix ))
         (buffer (switch-to-buffer buffer-name))
         )
    (if (get-buffer-process (current-buffer))
        (message "Switching to pre-existing shell")
      (with-current-buffer buffer
        (let ((process-environment process-environment)
              (histfile (concat project-root "/.bash_history_local")))
          (setenv "HISTFILE" histfile)
          (loop for (key . value) in (sbw/eproject-get-project-env-alist project-root)
                do (setenv key value))
          (setenv "EPROJECT_ROOT" project-root)

          (shell buffer)
          (make-variable-buffer-local 'comint-prompt-read-only)

          (setq comint-prompt-read-only t)
          (setq comint-process-echoes nil)

          (local-set-key (kbd "<return>") 'sbw/comint-send-input-at-eob)

          (let ((process (get-buffer-process (current-buffer))))
            (unless process
              (error "No process in %s" buffer-or-name))

            (set-process-query-on-exit-flag process nil)
            (set-process-sentinel
             process
             (lambda (this-process state)
               (if (or (string-match "exited abnormally with code.*" state)
                       (string-match "finished" state))
                   (kill-buffer (current-buffer)))
               ))
            )

          (sbw/force-eproject-on-buffer project-root)
        )))))

(defun sbw/activate-poor-mans-indent-for-mason ()
  "Open a shell in project root directory"
  (interactive)
  (if (string-equal major-mode "nxhtml-mode")
      (progn
        (make-local-variable 'indent-line-function)
        (setq indent-line-function 'sbw/mason-indent-line))))

(add-hook 'perl-project-file-visit-hook 'sbw/perl-project-compile-command)
; (add-hook 'perl-project-file-visit-hook 'sbw/perl-project-ack-arguments)
(add-hook 'perl-project-file-visit-hook 'sbw/perl-project-setup-epod-dirs)
(add-hook 'perl-project-file-visit-hook 'sbw/perl-project-execute-local-init)
(add-hook 'perl-project-file-visit-hook 'sbw/activate-poor-mans-indent-for-mason)

(add-hook 'magit-status-mode-hook 'sbw/force-eproject-on-buffer)
