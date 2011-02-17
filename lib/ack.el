;;; ack.el --- run Ack as inferior of Emacs, parse match messages

;; Copyright (C) 1985, 1986, 1987, 1993, 1994, 1995, 1996, 1997, 1998, 1999,
;;   2001, 2002, 2003, 2004, 2005, 2006, 2007  Free Software Foundation, Inc.

;; Author: Roland McGrath <roland@gnu.org>
;; Maintainer: FSF
;; Keywords: tools, processes

;; This file is part of GNU Emacs.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; This package provides the ack facilities documented in the Emacs
;; user's manual.

;;; Code:

(require 'compile)


(defgroup ack nil
  "Run ack as inferior of Emacs, parse error messages."
  :group 'tools
  :group 'processes)


;;;###autoload
(defcustom ack-window-height nil
  "*Number of lines in a ack window.  If nil, use `compilation-window-height'."
  :type '(choice (const :tag "Default" nil)
		 integer)
  :version "22.1"
  :group 'ack)

(defcustom ack-scroll-output nil
  "*Non-nil to scroll the *ack* buffer window as output appears.

Setting it causes the ack commands to put point at the end of their
output window so that the end of the output is always visible rather
than the begining."
  :type 'boolean
  :version "22.1"
  :group 'ack)

;;;###autoload
(defcustom ack-command nil
  "The default ack command for \\[ack].
If the ack program used supports an option to always include file names
in its output (such as the `-H' option to GNU ack), it's a good idea to
include it when specifying `ack-command'.

The default value of this variable is set up by `ack-compute-defaults';
call that function before using this variable in your program."
  :type '(choice string
		 (const :tag "Not Set" nil))
  :group 'ack)

(defcustom ack-files-aliases '(
	("el" .	"*.el")
	("ch" .	"*.[ch]")
	("c" .	"*.c")
	("h" .	"*.h")
	("asm" . "*.[sS]")
	("m" .	"[Mm]akefile*")
	("l" . "[Cc]hange[Ll]og*")
	("tex" . "*.tex")
	("texi" . "*.texi")
	)
  "*Alist of aliases for the FILES argument to `lack' and `rack'."
  :type 'alist
  :group 'ack)

(defcustom ack-error-screen-columns nil
  "*If non-nil, column numbers in ack hits are screen columns.
See `compilation-error-screen-columns'"
  :type '(choice (const :tag "Default" nil)
		 integer)
  :version "22.1"
  :group 'ack)

;;;###autoload
(defcustom ack-setup-hook nil
  "List of hook functions run by `ack-process-setup' (see `run-hooks')."
  :type 'hook
  :group 'ack)

(defvar ack-mode-map
  (let ((map (cons 'keymap compilation-minor-mode-map)))
    (define-key map " " 'scroll-up)
    (define-key map "\^?" 'scroll-down)
    (define-key map "\C-c\C-f" 'next-error-follow-minor-mode)

    (define-key map "\r" 'compile-goto-error)  ;; ?
    (define-key map "n" 'next-error-no-select)
    (define-key map "p" 'previous-error-no-select)
    (define-key map "{" 'compilation-previous-file)
    (define-key map "}" 'compilation-next-file)
    (define-key map "\t" 'compilation-next-error)
    (define-key map [backtab] 'compilation-previous-error)

    ;; Set up the menu-bar
    (define-key map [menu-bar ack]
      (cons "Ack" (make-sparse-keymap "Ack")))

    (define-key map [menu-bar ack compilation-kill-compilation]
      '("Kill Ack" . kill-compilation))
    (define-key map [menu-bar ack compilation-separator2]
      '("----" . nil))
    (define-key map [menu-bar ack compilation-compile]
      '("Compile..." . compile))
    (define-key map [menu-bar ack compilation-ack]
      '("Another ack..." . ack))
    (define-key map [menu-bar ack compilation-recompile]
      '("Repeat ack" . recompile))
    (define-key map [menu-bar ack compilation-separator2]
      '("----" . nil))
    (define-key map [menu-bar ack compilation-first-error]
      '("First Match" . first-error))
    (define-key map [menu-bar ack compilation-previous-error]
      '("Previous Match" . previous-error))
    (define-key map [menu-bar ack compilation-next-error]
      '("Next Match" . next-error))
    map)
  "Keymap for ack buffers.
`compilation-minor-mode-map' is a cdr of this.")

(defalias 'kill-ack 'kill-compilation)

;;;; TODO --- refine this!!

;;; (defcustom ack-use-compilation-buffer t
;;;   "When non-nil, ack specific commands update `compilation-last-buffer'.
;;; This means that standard compile commands like \\[next-error] and \\[compile-goto-error]
;;; can be used to navigate between ack matches (the default).
;;; Otherwise, the ack specific commands like \\[ack-next-match] must
;;; be used to navigate between ack matches."
;;;   :type 'boolean
;;;   :group 'ack)

;; override compilation-last-buffer
(defvar ack-last-buffer nil
  "The most recent ack buffer.
A ack buffer becomes most recent when you select Ack mode in it.
Notice that using \\[next-error] or \\[compile-goto-error] modifies
`complation-last-buffer' rather than `ack-last-buffer'.")

;;;###autoload
(defvar ack-regexp-alist
  '(
    ("^\\(.+?\\)\\(:[ \t]*\\)\\([0-9]+\\)\\2" 1 3)
    ;; Rule to match column numbers is commented out since no known ack
    ;; produces them
    ;; ("^\\(.+?\\)\\(:[ \t]*\\)\\([0-9]+\\)\\2\\(?:\\([0-9]+\\)\\(?:-\\([0-9]+\\)\\)?\\2\\)?"
    ;;  1 3 (4 . 5))
    ("^\033\\[1;32m\\(\\(.+?\\)\033\\[[0-9;]*m\\:\\([0-9]+\\):\\).*?\\(\033\\[30;43m\\)\\(.*?\\)\\(\033\\[[0-9;]*m\\)" 2 3
     ;; Calculate column positions (beg . end) of first ack match on a line
     ((lambda ()
	(setq compilation-error-screen-columns nil)
        (- (match-beginning 4) (match-end 1)))
      .
      (lambda () (- (match-end 5) (match-end 1)
		    (- (match-end 4) (match-beginning 4)))))
     nil 1)
    ("^Binary file \\(.+\\) matches$" 1 nil nil 0 1))
  "Regexp used to match ack hits.  See `compilation-error-regexp-alist'.")

(defvar ack-error "ack hit"
  "Message to print when no matches are found.")

;; Reverse the colors because ack hits are not errors (though we jump there
;; with `next-error'), and unreadable files can't be gone to.
(defvar ack-hit-face	compilation-info-face
  "Face name to use for ack hits.")

(defvar ack-error-face	'compilation-error
  "Face name to use for ack error messages.")

(defvar ack-match-face	'match
  "Face name to use for ack matches.")

(defvar ack-context-face 'shadow
  "Face name to use for ack context lines.")

(defvar ack-mode-font-lock-keywords
   '(;; Command output lines.
     ("^\\([A-Za-z_0-9/\.+-]+\\)[ \t]*:" 1 font-lock-function-name-face)
     (": \\(.+\\): \\(?:Permission denied\\|No such \\(?:file or directory\\|device or address\\)\\)$"
      1 ack-error-face)
     ;; remove match from ack-regexp-alist before fontifying
     ("^Ack[/a-zA-z]* started.*"
      (0 '(face nil message nil help-echo nil mouse-face nil) t))
     ("^Ack[/a-zA-z]* finished \\(?:(\\(matches found\\))\\|with \\(no matches found\\)\\).*"
      (0 '(face nil message nil help-echo nil mouse-face nil) t)
      (1 compilation-info-face nil t)
      (2 compilation-warning-face nil t))
     ("^Ack[/a-zA-z]* \\(exited abnormally\\|interrupt\\|killed\\|terminated\\)\\(?:.*with code \\([0-9]+\\)\\)?.*"
      (0 '(face nil message nil help-echo nil mouse-face nil) t)
      (1 ack-error-face)
      (2 ack-error-face nil t))
     ("^.+?-[0-9]+-.*\n" (0 ack-context-face))
     ;; Highlight ack matches and delete markers
     ("\\(\033\\[30;43m\\)\\(.*?\\)\\(\033\\[[0-9]*m\\)"
      ;; Refontification does not work after the markers have been
      ;; deleted.  So we use the font-lock-face property here as Font
      ;; Lock does not clear that.
      (2 (list 'face nil 'font-lock-face ack-match-face))
      ((lambda (bound))
       (progn
	 ;; Delete markers with `replace-match' because it updates
	 ;; the match-data, whereas `delete-region' would render it obsolete.
	 (replace-match "" t t nil 3)
	 (replace-match "" t t nil 1))))
     ("\\(\033\\[[0-9;]*[mK]\\)"
      ;; Delete all remaining escape sequences
      ((lambda (bound))
       (replace-match "" t t nil 1))))
   "Additional things to highlight in ack output.
This gets tacked on the end of the generated expressions.")

;;;###autoload
(defvar ack-program "ack"
  "The default ack program for `ack-command' and `ack-find-command'.
This variable's value takes effect when `ack-compute-defaults' is called.")

;; History of ack commands.
;;;###autoload
(defvar ack-history nil)
;;;###autoload
(defvar ack-find-history nil)

(defvar ack-host-defaults-alist nil
  "Default values depending on target host.
`ack-compute-defaults' returns default values for every local or
remote host `ack' runs.  These values can differ from host to
host.  Once computed, the default values are kept here in order
to avoid computing them again.")

;;;###autoload
(defun ack-process-setup ()
  "Setup compilation variables and buffer for `ack'.
Set up `compilation-exit-message-function' and run `ack-setup-hook'."
  (ack-compute-defaults) ;; was dependend or highlight-matches ?!?
  (set (make-local-variable 'compilation-exit-message-function)
       (lambda (status code msg)
	 (if (eq status 'exit)
	     (cond ((zerop code)
		    '("finished (matches found)\n" . "matched"))
		   ((= code 1)
		    '("finished with no matches found\n" . "no match"))
		   (t
		    (cons msg code)))
	   (cons msg code))))
  (run-hooks 'ack-setup-hook))

(defun ack-probe (command args &optional func result)
  (equal (condition-case nil
	     (apply (or func 'process-file) command args)
	   (error nil))
	 (or result 0)))

;;;###autoload
(defun ack-compute-defaults ()
  ;; Keep default values.
  (unless ack-host-defaults-alist
    (add-to-list
     'ack-host-defaults-alist
     (cons nil
	   `((ack-command ,ack-command)))))
  (let* ((host-id
	  (intern (or (file-remote-p default-directory 'host) "localhost")))
	 (host-defaults (assq host-id ack-host-defaults-alist))
	 (defaults (assq nil ack-host-defaults-alist)))
    ;; There are different defaults on different hosts.  They must be
    ;; computed for every host once.
    (setq ack-command
	  (or (cadr (assq 'ack-command host-defaults))
	      (cadr (assq 'ack-command defaults)))
    )

    (let ((ack-options (concat "--all" " --nogroup" " -H")))

	(unless ack-command
	  (setq ack-command (format "%s %s " ack-program ack-options)))

    ;; Save defaults for this host.
    (setq ack-host-defaults-alist
	  (delete (assq host-id ack-host-defaults-alist)
		  ack-host-defaults-alist))
    (add-to-list
     'ack-host-defaults-alist
     (cons host-id
	   `((ack-command ,ack-command))))))
)

(defun ack-tag-default ()
  (or (and transient-mark-mode mark-active
	   (/= (point) (mark))
	   (buffer-substring-no-properties (point) (mark)))
      (funcall (or find-tag-default-function
		   (get major-mode 'find-tag-default-function)
		   'find-tag-default))
      ""))

(defun ack-default-command ()
  "Compute the default ack command for C-u M-x ack to offer."
  (let ((tag-default (shell-quote-argument (ack-tag-default)))
	;; This a regexp to match single shell arguments.
	;; Could someone please add comments explaining it?
	(sh-arg-re "\\(\\(?:\"\\(?:[^\"]\\|\\\\\"\\)+\"\\|'[^']+'\\|[^\"' \t\n]\\)+\\)")
	(ack-default (or (car ack-history) ack-command)))
    ;; In the default command, find the arg that specifies the pattern.
    (when (or (string-match
	       (concat "[^ ]+\\s +\\(?:-[^ ]+\\s +\\)*"
		       sh-arg-re "\\(\\s +\\(\\S +\\)\\)?")
	       ack-default)
	      ;; If the string is not yet complete.
	      (string-match "\\(\\)\\'" ack-default))
      ;; Maybe we will replace the pattern with the default tag.
      ;; But first, maybe replace the file name pattern.
      (condition-case nil
	  (unless (or (not (stringp buffer-file-name))
		      (when (match-beginning 2)
			(save-match-data
			  (string-match
			   (wildcard-to-regexp
			    (file-name-nondirectory
			     (match-string 3 ack-default)))
			   (file-name-nondirectory buffer-file-name)))))
	    (setq ack-default (concat (substring ack-default
						  0 (match-beginning 2))
				       " *."
				       (file-name-extension buffer-file-name))))
	;; In case wildcard-to-regexp gets an error
	;; from invalid data.
	(error nil))
      ;; Now replace the pattern with the default tag.
      (replace-match tag-default t t ack-default 1))))


;;;###autoload
(define-compilation-mode ack-mode "Ack"
  "Sets `ack-last-buffer' and `compilation-window-height'."
  (setq ack-last-buffer (current-buffer))
  (set (make-local-variable 'compilation-error-face)
       ack-hit-face)
  (set (make-local-variable 'compilation-error-regexp-alist)
       ack-regexp-alist)
  (set (make-local-variable 'compilation-process-setup-function)
       'ack-process-setup)
  (set (make-local-variable 'compilation-disable-input) t))


;;;###autoload
(defun ack (command-args)
  "Run ack, with user-specified args, and collect output in a buffer.
While ack runs asynchronously, you can use \\[next-error] (M-x next-error),
or \\<ack-mode-map>\\[compile-goto-error] in the ack \
output buffer, to go to the lines
where ack found matches.

For doing a recursive `ack', see the `rack' command.  For running
`ack' in a specific directory, see `lack'.

This command uses a special history list for its COMMAND-ARGS, so you can
easily repeat a ack command.

A prefix argument says to default the argument based upon the current
tag the cursor is over, substituting it into the last ack command
in the ack command history (or into `ack-command'
if that history list is empty)."
  (interactive
   (progn
     (ack-compute-defaults)
     (let ((default (ack-default-command)))
       (list (read-from-minibuffer "Run ack (like this): "
				   (if current-prefix-arg
				       default ack-command)
				   nil nil 'ack-history
				   (if current-prefix-arg nil default))))))

  ;; Setting process-setup-function makes exit-message-function work
  ;; even when async processes aren't supported.
  (compilation-start command-args 'ack-mode))


;; User-friendly interactive API.

(defconst ack-expand-keywords
  '(("<C>" . (and cf (isearch-no-upper-case-p regexp t) "-i"))
    ("<D>" . dir)
    ("<F>" . files)
    ("<N>" . null-device)
    ("<X>" . excl)
    ("<R>" . (shell-quote-argument (or regexp ""))))
  "List of substitutions performed by `ack-expand-template'.
If car of an element matches, the cdr is evalled in to get the
substitution string.  Note dynamic scoping of variables.")

(defun ack-expand-template (template &optional regexp files dir excl)
  "Patch ack COMMAND string replacing <C>, <D>, <F>, <R>, and <X>."
  (let ((command template)
	(cf case-fold-search)
	(case-fold-search nil))
    (dolist (kw ack-expand-keywords command)
      (if (string-match (car kw) command)
	  (setq command
		(replace-match
		 (or (if (symbolp (cdr kw))
			 (symbol-value (cdr kw))
		       (save-match-data (eval (cdr kw))))
		     "")
		 t t command))))))

(defun ack-read-regexp ()
  "Read regexp arg for interactive ack."
  (let ((default (ack-tag-default)))
    (read-string
     (concat "Search for"
	     (if (and default (> (length default) 0))
		 (format " (default \"%s\"): " default) ": "))
     nil 'ack-regexp-history default)))

(defun ack-read-files (regexp)
  "Read files arg for interactive ack."
  (let* ((bn (or (buffer-file-name) (buffer-name)))
	 (fn (and bn
		  (stringp bn)
		  (file-name-nondirectory bn)))
	 (default
	   (or (and fn
		    (let ((aliases ack-files-aliases)
			  alias)
		      (while aliases
			(setq alias (car aliases)
			      aliases (cdr aliases))
			(if (string-match (wildcard-to-regexp (cdr alias)) fn)
			    (setq aliases nil)
			  (setq alias nil)))
		      (cdr alias)))
	       (and fn
		    (let ((ext (file-name-extension fn)))
		      (and ext (concat "*." ext))))
	       (car ack-files-history)
	       (car (car ack-files-aliases))))
	 (files (read-string
		 (concat "Search for \"" regexp
			 "\" in files"
			 (if default (concat " (default " default ")"))
			 ": ")
		 nil 'ack-files-history default)))
    (and files
	 (or (cdr (assoc files ack-files-aliases))
	     files))))

(provide 'ack)

;; arch-tag: 5a5b9169-a79d-4f38-9c38-f69615f39c4d
;;; ack.el ends here
