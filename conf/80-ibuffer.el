;; Enable default groups by default
(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-vc-set-filter-groups-by-vc-root)))

;; You probably don't want to see empty project groups
(setq ibuffer-show-empty-filter-groups nil)

;; Modify the default ibuffer-formats
(setq ibuffer-formats
      '((mark modified read-only " "
              (name 18 18 :left :elide)
              " "
              (mode 16 16 :left :elide)
              " "
              filename-and-process)))

;; With this, when you press ‘up’ or `down` to the top/bottom of IBuffer,
;; the cursor wraps around to the bottom/top, so you can continue from there.
;; With this improvement you do not need to hard code the line numbers, you
;; just need copy, compile and run. Moreover, the keys ‘up’ and ‘down’ do the
;; same thing but they skip the names of the filtered groups, and you can move
;; to the beginning or the end of a group with ‘left’ and ‘right’.

(defun ibuffer-advance-motion (direction)
  (forward-line direction)
  (beginning-of-line)
  (if (not (get-text-property (point) 'ibuffer-filter-group-name))
      t
    (ibuffer-skip-properties '(ibuffer-filter-group-name)
                             direction)
    nil))

(defun ibuffer-previous-line (&optional arg)
  "Move backwards ARG lines, wrapping around the list if necessary."
  (interactive "P")
  (or arg (setq arg 1))
  (let (err1 err2)
    (while (> arg 0)
      (cl-decf arg)
      (setq err1 (ibuffer-advance-motion -1)
            err2 (if (not (get-text-property (point) 'ibuffer-title))
                     t
                   (goto-char (point-max))
                   (beginning-of-line)
                   (ibuffer-skip-properties '(ibuffer-summary
                                              ibuffer-filter-group-name)
                                            -1)
                   nil)))
    (and err1 err2)))

(defun ibuffer-next-line (&optional arg)
  "Move forward ARG lines, wrapping around the list if necessary."
  (interactive "P")
  (or arg (setq arg 1))
  (let (err1 err2)
    (while (> arg 0)
      (cl-decf arg)
      (setq err1 (ibuffer-advance-motion 1)
            err2 (if (not (get-text-property (point) 'ibuffer-summary))
                     t
                   (goto-char (point-min))
                   (beginning-of-line)
                   (ibuffer-skip-properties '(ibuffer-summary
                                              ibuffer-filter-group-name
                                              ibuffer-title)
                                            1)
                   nil)))
    (and err1 err2)))

(defun ibuffer-next-header ()
  (interactive)
  (while (ibuffer-next-line)))

(defun ibuffer-previous-header ()
  (interactive)
  (while (ibuffer-previous-line)))

(define-key ibuffer-mode-map (kbd "<up>") 'ibuffer-previous-line)
(define-key ibuffer-mode-map (kbd "<down>") 'ibuffer-next-line)
(define-key ibuffer-mode-map (kbd "C-<up>") 'ibuffer-previous-header)
(define-key ibuffer-mode-map (kbd "C-<down>") 'ibuffer-next-header)

;; Get rid of title and summary

(defadvice ibuffer-update-title-and-summary (after remove-column-titles)
  (save-excursion
    (set-buffer "*Ibuffer*")
    (toggle-read-only 0)
    (goto-char 1)
    (search-forward "-\n" nil t)
    (delete-region 1 (point))
    (toggle-read-only)))

(ad-activate 'ibuffer-update-title-and-summary)

    (require 'ibuf-ext)

(add-to-list 'ibuffer-never-show-predicates "^\\*Messages\\*$")
(add-to-list 'ibuffer-never-show-predicates "^\\*Completions\\*$")
(add-to-list 'ibuffer-never-show-predicates "^\\*magit-process\\*$")
(add-to-list 'ibuffer-never-show-predicates "^\\*scratch\\*$")
(add-to-list 'ibuffer-never-show-predicates "^\\*compass: compile\\*$")
