(defun sbw/mason-indent-line ()
  "Indent current line as XML."
  (let* ((savep (point))
         (indent (condition-case nil
                     (save-excursion
                       (forward-line 0)
                       (skip-chars-forward " \t")
                       (if (>= (point) savep) (setq savep nil))
                       (or (sbw/mason-compute-indent) 0))
                   (error 0))))
    (if (not (numberp indent))
        ;; If something funny is used (e.g. `noindent'), return it.
        indent
      (if (< indent 0) (setq indent 0)) ;Just in case.
      (if savep
          (save-excursion (indent-line-to indent))
        (indent-line-to indent)))))

(defun sbw/mason-compute-indent ()
  "Return the indent for the line containing point."

  (let ((perl-line
         (save-excursion
           (back-to-indentation)
           (if (looking-at "%\\|</%") t nil))))
    (if perl-line 0
      (or (ignore-errors (sbw/mason-compute-indent-from-matching-start-tag))
          (ignore-errors (sbw/mason-compute-indent-from-previous-line))))))

(defun sbw/mason-compute-indent-from-matching-start-tag ()
  "Compute the indent for a line with an end-tag using the matching start-tag.
When the line containing point ends with an end-tag and does not start
in the middle of a token, return the indent of the line containing the
matching start-tag, if there is one and it occurs at the beginning of
its line.  Otherwise return nil."
  (save-excursion
    (back-to-indentation)
    (let ((bol (point)))
      (let ((inhibit-field-text-motion t)) (end-of-line))
      (skip-chars-backward " \t")
      (and (= (nxml-token-before) (point))
           (memq xmltok-type '(end-tag partial-end-tag))
           ;; start of line must not be inside a token
           (or (= xmltok-start bol)
               (save-excursion
                 (goto-char bol)
                 (nxml-token-after)
                 (= xmltok-start bol))
               (eq xmltok-type 'data))
           (condition-case err
               (nxml-scan-element-backward
                (point)
                nil
                (- (point)
                   nxml-end-tag-indent-scan-distance))
             (nxml-scan-error nil))
           (< xmltok-start bol)
           (progn
             (goto-char xmltok-start)
             (skip-chars-backward " \t")
             (bolp))
           (current-indentation)))))

(defun sbw/mason-compute-indent-from-previous-line ()
  "Compute the indent for a line using the indentation of a previous line."
  (save-excursion
    (end-of-line)
    (let ((eol (point))
          bol prev-bol ref
          before-context after-context)
      (back-to-indentation)
      (setq bol (point))
      (catch 'indent
        ;; Move backwards until the start of a non-blank line that is
        ;; not inside a token.
        (while (progn
                 (when (= (forward-line -1) -1)
                   (throw 'indent 0))
                 (beginning-of-line)
                 (if (looking-at "%")
                     t
                   (back-to-indentation)
                   (if (looking-at "[ \t]*$")
                       t
                     (or prev-bol
                         (setq prev-bol (point)))
                     (nxml-token-after)
                     (not (or (= xmltok-start (point))
                              (eq xmltok-type 'data)))))))
        (setq ref (point))
        ;; Now scan over tokens until the end of the line to be indented.
        ;; Determine the context before and after the beginning of the
        ;; line.
        (while (< (point) eol)
          (nxml-tokenize-forward)
          (cond ((<= bol xmltok-start)
                 (setq after-context
                       (nxml-merge-indent-context-type after-context)))
                ((and (<= (point) bol)
                      (not (and (eq xmltok-type 'partial-start-tag)
                                (= (point) bol))))
                 (setq before-context
                       (nxml-merge-indent-context-type before-context)))
                ((eq xmltok-type 'data)
                 (setq before-context
                       (nxml-merge-indent-context-type before-context))
                 (setq after-context
                       (nxml-merge-indent-context-type after-context)))
                ;; If in the middle of a token that looks inline,
                ;; then indent relative to the previous non-blank line
                ((eq (nxml-merge-indent-context-type before-context)
                     'mixed)
                 (goto-char prev-bol)
                 (throw 'indent (current-column)))
                (t
                 (throw 'indent
                        (nxml-compute-indent-in-token bol))))
          (skip-chars-forward " \t\r\n"))
        (goto-char ref)
        (+ (current-column)
           (* nxml-child-indent
              (+ (if (eq before-context 'start-tag) 1 0)
                 (if (eq after-context 'end-tag) -1 0))))))))
