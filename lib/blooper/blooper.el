;;; blooper.el --- Blogging on http://blogs.perl.org via XML-RPC APIs
;; Copyright (C) 2011 Sebastian Willert

;; Inspired by weblogger.el
;; Copyright (C) 2002-2009 Mark A. Hershberger.

;; Original Author: Sebastian Willert <willert@gmail.com>
;; Created: 2011 Jan 11
;; Keywords: weblog blog cms perl movable type
;; URL: none
;; Version: 0.1
;; Last Modified: <2011-01-16 sbw>
;; Package-Requires: ((xml-rpc "1.6.8"))

(defconst blooper-version "0.1"
  "Current version of blooper.el")

;; This file is NOT (yet) part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; blooper.el is inspired by weblogger.el and optimize to work with
;; the MovableType installation at http://blogs.perl.org

;;; Installation:

;; Just make sure this file, xml-rpc.el and pod-mode.el are in your
;; load-path (usually ~/.emacs.d is included) and put
;; (require 'blooper) in your ~/.emacs or ~/.emacs.d/init.el file.

;; You can set up your server information using
;;
;;    M-x customize-group RET blooper RET
;;
;;; Keymaps:
;;
;; I use the following commands in my .emacs file:
;;
;; (load-file "blooper.el")
;; (global-set-key "\C-cbs" 'blooper-start-entry)
;;
;; C-c C-c     -- save as draft (i.e. scheduled to be published 2099-12-31)
;;
;; C-u C-c C-c -- publish entry
;;
;;
;; Notes:
;; ----
;;
;; TBD

(require 'pod-mode)
(require 'assoc)
(require 'xml-rpc)
(require 'skeleton)

(defgroup blooper nil
  "Post POD formatted entries to http://blog.perl.org/"
  :group 'emacs)

(defcustom blooper-server-username nil
  "Your http://blog.perl.org/ server username."
  :group 'blooper
  :type 'string)

(defcustom blooper-server-password ""
  "Your MoveableType Web Services password. You can find it on your profile
page and it is *DIFFERENT* from your user password."
  :group 'blooper
  :type 'string)

(defcustom blooper-chunk-style "border: 0.25ex dashed rgb(0, 94, 145);
color: rgb(187, 187, 187); background-color: rgb(0, 42, 62);
margin: 1em 0pt; padding: 0.1ex 1ex;overflow: auto;"
  "CSS style that will be applied to chunks rendered by blooper."
  :group 'blooper
  :type 'string)

(defcustom blooper-chunk-postamble "<div style=\"text-align: right;
font-size: x-small; color: #aaa; height:1em; line-height: 1em;
margin: -2.5ex 1ex 1em;\">
  Rendered by <em>emacs</em>, <em>blooper.el</em> and <em>htmlize.el</em>
</div>"
  "HTML that will appended after chunks rendered by blooper."
  :group 'blooper
  :type 'string)

(defcustom blooper-posting-skel '( "# TITLE: " _ "\n"
"# TAGS: " _ "\n"
"\n"
"=head1 DESCRIPTION" "\n"
"\n"
_ "\n"
"\n"
"=head1 BODY" "\n"
"\n"
_ "\n"
"\n")
  "Content of the new posting buffer"
  :group 'blooper
  :type 'sexp)

(setq blooper-server-url "http://blogs.perl.org/mt/mt-xmlrpc.cgi")
(setq blooper-draft-date "2099-12-31T00:00:00+0000")
(setq blooper-weblog-id nil)

(defun blooper/dump (object &optional clear)
  (require 'cl)
  (with-current-buffer (get-buffer-create "* Blooper Debug *")
    (if clear (delete-region (point-min) (point-max))
      (goto-char (point-max)))
    (cl-prettyprint object))
)

(defun blooper/chomp (str)
  "Chomp leading and tailing whitespace from STR."
  (let ((s (if (symbolp str)(symbol-name str) str))
        (str-pos 0))
    (string-match "^[ \f\t\n]*" s)
    (if (= (match-beginning 0) str-pos)
        (setq s (replace-match "" t nil s)))
    (while (string-match "[^ \f\t\n]+" s str-pos)
      (setq str-pos (match-end 0)))
    (substring s 0 str-pos)))

(defun blooper/get-section (name sections)
  (if (not (assoc name sections))
      nil
    (blooper/chomp
     (buffer-substring-no-properties
      (nth 1 (assoc name sections))
      (nth 2 (assoc name sections))
      ))
    ))

(defun blooper/htmlize-region (mode beg end)
  (require 'htmlize)
  (let ((htmlize-output-type "inline-css")
        (div-style blooper-chunk-style)
        (postamble blooper-chunk-postamble)
        (mode-fun (intern-soft mode))
        (chunk (buffer-substring-no-properties beg end)))

    (if (not mode-fun)
        (error "Invalid mode: '%s'" mode))

    (save-excursion

      (with-current-buffer (get-buffer-create "* Blooper htmlize *")
        (delete-region (point-min) (point-max))
        (insert chunk)
        (funcall mode-fun)
        (font-lock-mode t)

        (with-current-buffer (htmlize-buffer)
          (while
              (re-search-forward "\\(.*\n\\)* *<body style=\"[^\"]*\"" nil t)
            (replace-match (concat "<div style=\"" div-style "\"") t nil))
          (while
              (re-search-forward "</body>\\(.*\n\\)* *" nil t)
            (replace-match (concat "</div>" postamble) t nil))
          (concat
           "=begin html\n\n"
           (buffer-substring-no-properties (point-min) (point-max))
           "\n\n=end html\n\n")
          ))
      ))
  )



(defun blooper/filter-pod ()
  (save-excursion
    (goto-char (point-min))

    ; auto-description
    (if (not (save-excursion
               (re-search-forward "^=head1 DESCRIPTION *" nil t)))
        (save-excursion
          (let ((found-non-empty-line nil))
            (while (and (not found-non-empty-line) (re-search-forward
                 "^[^#]" nil t))
              (goto-char (match-beginning 0))
                (if (looking-at "^[ \\f\\t]*$")
                    (beginning-of-line 2)
                  (goto-char (match-beginning 0))
                  (insert "=head1 DESCRIPTION\n\n")
                  (setq found-non-empty-line 1))
              ))))

    ; expand shortcuts
    (save-excursion
      (while (re-search-forward
              "^# \\([A-Z]+\\): *\\(.*?\\) *$"
              nil t)
        (replace-match
         (format "\n=head1 %s\n\n%s\n\n"
                 (upcase (match-string 1)) (match-string 2)) nil t)
        ))

    (save-excursion
      (while (looking-at "^[ \\f\\t\n]*$")
        (beginning-of-line 2)
        (delete-region (point-min) (point)))
      )

    (save-excursion
      (while (re-search-forward
              "\n[ \\f\\t]*\n[ \\f\\t]*\n+"
              nil t)
        (replace-match "\n\n" nil t)))

    (save-excursion
      (while (re-search-forward
              "^=begin  *\\([a-z-]+\\)\\([ \\f\\t]*\n\\)*"
              nil t)
        (message "Rendering %s" (match-string 1))
        (if (not (string= (match-string 1) "html"))
            (let* ((reg-start (match-beginning 0))
                   (chunk-start (match-end 0))
                   (delimiter (match-string 1))
                   (mode (concat delimiter "-mode")))
              (if (not (re-search-forward
                        (concat "^\\([ \\f\\t]*\n\\)*=end  *" delimiter)
                        nil t))
                  (error "Unbalanced '=begin %s'" delimiter)
                (let* ((reg-end (match-end 0))
                       (chunk-end (match-beginning 0))
                       (chunk (buffer-substring-no-properties
                               chunk-start chunk-end))
                       (rendered-chunk (blooper/htmlize-region
                                        mode chunk-start chunk-end)))
                  (delete-region reg-start reg-end)
                  (goto-char reg-start)
                  (insert rendered-chunk)
                  ))))))

))

(defun blooper/pod-to-html (pod)
  (with-current-buffer (get-buffer-create "* Blooper POD *")
    (delete-region (point-min) (point-max))
    (insert "=pod\n\n" pod)
    (shell-command-on-region (point-min) (point-max)
                             "perl -MPod::Simple::HTML -e '
use Pod::Simple::HTML;

my $p = Pod::Simple::HTML->new();
$p->html_header_before_title( q// );
$p->html_header_after_title ( q// );
$p->html_footer             ( q// );

$p->output_fh( *STDOUT );
$p->parse_string_document( *STDIN );
'" nil t)

    (buffer-substring-no-properties (point-min) (point-max))
      )
)

(defun blooper/parse-pod ()
  (interactive)
  (let ((sections (list)))

    (save-excursion
      (goto-char (point-min))

      (while (re-search-forward
              "^=head1  *\\([A-Za-z0-9 ]+?\\) *$"
              nil t)

        (let* ((sec-cnt (length sections))
               (last-sec (- sec-cnt 1))
               (eos (- (match-beginning 0) 1)))
          (if (> sec-cnt 0)
              (nconc (nth last-sec sections) (list eos))))

        (let ((heading (buffer-substring-no-properties
                        (match-beginning 1) (match-end 1))))
          (setq sections (append sections
                                 (list (list heading (match-end 0))))))))

    (let* ((sec-cnt (length sections))
           (last-sec (- sec-cnt 1)))
      (if (> sec-cnt 0)
          (nconc (nth last-sec sections) (list (point-max)))))

    (delq
     nil
     (list
      (if (assoc "TITLE" sections)
          (cons "title" (blooper/get-section "TITLE" sections)))
      (if (assoc "KEYWORDS" sections)
          (cons "mt_keywords" (blooper/get-section "KEYWORDS" sections)))
      (if (assoc "TAGS" sections)
          (cons "mt_tags" (blooper/get-section "TAGS" sections)))
      (if (assoc "EXCERPT" sections)
          (cons "mt_excerpt" (blooper/get-section "EXCERPT" sections)))
      (if (assoc "DESCRIPTION" sections)
          (cons "description" (blooper/pod-to-html
                               (blooper/get-section "DESCRIPTION" sections))))
      (if (assoc "BODY" sections)
          (cons "mt_text_more" (blooper/pod-to-html
                                (blooper/get-section "BODY" sections))))
      (if (assoc "PUBLISH" sections)
          (cons "dateCreated" (blooper/get-section "PUBLISH" sections)))
      ))))

(defun blooper/get-weblog-id ()
  (if blooper-weblog-id blooper-weblog-id
    (setq blooper-weblog-id
          (cdr (assoc "blogid"
                      (car (xml-rpc-method-call
                            blooper-server-url
                            'blogger.getUsersBlogs nil
                            blooper-server-username blooper-server-password)))
               ))
    ))


(defun blooper/get-current-utc-time ()
  (let ((old-tc (nth 1 (current-time-zone))))
    (set-time-zone-rule t)
    (prog1
    (format-time-string "%Y-%m-%dT%T%z")
    (set-time-zone-rule old-tc)
    ))
)

(defun blooper/escape-html-entities (source)
  (let ((encoded source) (pos 0))
    (while (string-match "[&<>-]" encoded pos)
      (if (string= "&" (match-string 0 encoded))
          (setq encoded (replace-match "&amp;" t t encoded)))
      (if (string= "<" (match-string 0 encoded))
          (setq encoded (replace-match "&lt;" t t encoded)))
      (if (string= ">" (match-string 0 encoded))
          (setq encoded (replace-match "&gt;" t t encoded)))
      (if (string= "-" (match-string 0 encoded))
          (setq encoded (replace-match "&ndash;" t t encoded)))
      (setq pos (match-end 0)))
  encoded))

(defun blooper/unescape-html-entities (encoded)
  (let ((unencoded encoded) (pos 0))
    (while (string-match "&\\([a-z]+\\);" unencoded pos)
      (if (string= "amp" (match-string 1 unencoded))
          (setq unencoded (replace-match "&" t t unencoded)))
      (if (string= "lt"  (match-string 1 unencoded))
          (setq unencoded (replace-match "<" t t unencoded)))
      (if (string= "gt"  (match-string 1 unencoded))
          (setq unencoded (replace-match ">" t t unencoded)))
      (if (string= "ndash"  (match-string 1 unencoded))
          (setq unencoded (replace-match "-" t t unencoded)))
      (setq pos (+ (match-beginning 0) 1)))
  unencoded))


(defun blooper-submit-pod (publishp)
  "Post a new entry. Returns the new entry id"
  (interactive "P")

  (let ((posting (buffer-substring-no-properties
                  (point-min) (point-max)))
        (post-id nil)
        (post-title nil))

    (with-current-buffer (get-buffer-create "* Blooper Entry *")
      (delete-region (point-min) (point-max))
      (insert posting)

      (goto-char (point-min))
      (while (re-search-forward "^# POST-ID: *\\([0-9]+\\) *\n" nil t)
        (if post-id
            (message "Post-ID already set, ignoring extra")
          (setq post-id (string-to-number (match-string 1)))
          (message "Resubmitting entry %d" post-id))
        (replace-match "" t nil))

      (blooper/filter-pod)

      (let ((entry (blooper/parse-pod)))

        (if (not (assoc "dateCreated" entry))
            (push (cons "dateCreated"
                        (if publishp (blooper/get-current-utc-time)
                          blooper-draft-date)
                  ) entry))

        (if (not (assoc "mt_text_more" entry))
            (push (cons "mt_text_more" "") entry))
        (aput 'entry "mt_text_more"
              (concat
               (aget entry "mt_text_more")
               "\n\n<!-- blooper pod source\n"
               (blooper/escape-html-entities posting)
               "\n-->"
               ))

        (setq post-title (aget entry "title"))

        (blooper/dump entry t)

        (if post-id
            (xml-rpc-method-call
             blooper-server-url 'metaWeblog.editPost
             post-id
             blooper-server-username blooper-server-password
             entry nil)
          (setq post-id
                (string-to-number
                 (xml-rpc-method-call
                  blooper-server-url 'metaWeblog.newPost
                  (blooper/get-weblog-id)
                  blooper-server-username blooper-server-password
                  entry nil)))
          )))

    (goto-char (point-min))
    (if (re-search-forward "^# POST-ID: *\\([0-9]+\\) *$" nil t)
        (replace-match (number-to-string post-id) 1 1 nil 1)
      (goto-char (point-min))
      (insert (format "# POST-ID: %d\n" post-id)))

    (if (not (buffer-file-name))
        (rename-buffer (format "*Blooper: %s (%d)*" post-title post-id)))

))

(defun blooper-start-entry ()
  (interactive)
  (let* ((posting-buffer-name "*Blooper: new entry*")
         (posting-buffer (get-buffer posting-buffer-name)))
    (if posting-buffer
        1
      (setq posting-buffer (get-buffer-create posting-buffer-name))
      (with-current-buffer posting-buffer
        (skeleton-insert (append (list nil) blooper-posting-skel))
        (blooper-mode)))
    (switch-to-buffer posting-buffer)
  )
)

(define-derived-mode blooper-mode
  pod-mode "Blooper"
  "Major mode for blogging on http://blogs.perl.org/.
   \\{blooper-mode-map}"
)

(define-key blooper-mode-map
  (kbd "C-c C-c") 'blooper-submit-pod)

(provide 'blooper)
