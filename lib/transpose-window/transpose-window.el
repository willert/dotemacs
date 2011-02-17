;;; transpose-window.el --- Transpose a window with another one windmove-like
;; Copyright (C) 2011 Sebastian Willert

(defconst transpose-window-version "0.1"
  "Current version of transpose-window.el")

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

;; transpose-window.el is a small shim around windmove.el that
;; transposes buffers instead of changing windows

;;; Installation:

;; Just make sure this file is in your load-path (usually ~/.emacs.d is included)
;; and put (require 'transpose-window) in your ~/.emacs or ~/.emacs.d/init.el file.

(require 'windmove)

(defun transpose-window-do-transposition (dir arg)
  "Transpose the active buffer with the one shown in window to the
direction given as `dir'."
  (let ((next-win (windmove-find-other-window dir arg)))
    (unless next-win (error "No window in that direction"))
    (let ((this-win-bufffer (window-buffer))
          (next-win-buffer (window-buffer next-win)))
    (if (minibufferp next-win-buffer)
        (error "Can't transpose with a minibuffer"))
    (set-window-buffer (selected-window) next-win-buffer)
    (set-window-buffer next-win this-win-bufffer)
    (select-window next-win))))

;;;###autoload
(defun transpose-window-left (&optional arg)
  "Select the current window with the one to the left.
With no prefix argument, or with prefix argument equal to zero,
\"left\" is relative to the position of point in the window; otherwise
it is relative to the top edge (for positive ARG) or the bottom edge
\(for negative ARG) of the current window.
If no window is at the desired location, an error is signaled."
  (interactive "P")
  (transpose-window-do-transposition 'left arg))

;;;###autoload
(defun transpose-window-up (&optional arg)
  "Select the current window with the one above the current one.
With no prefix argument, or with prefix argument equal to zero, \"up\"
is relative to the position of point in the window; otherwise it is
relative to the left edge (for positive ARG) or the right edge (for
negative ARG) of the current window.
If no window is at the desired location, an error is signaled."
  (interactive "P")
  (transpose-window-do-transposition 'up arg))

;;;###autoload
(defun transpose-window-right (&optional arg)
  "Select the current window with the one to the right.
With no prefix argument, or with prefix argument equal to zero,
\"right\" is relative to the position of point in the window;
otherwise it is relative to the top edge (for positive ARG) or the
bottom edge (for negative ARG) of the current window.
If no window is at the desired location, an error is signaled."
  (interactive "P")
  (transpose-window-do-transposition 'right arg))

;;;###autoload
(defun transpose-window-down (&optional arg)
  "Select the current window with the one below the current one.
With no prefix argument, or with prefix argument equal to zero,
\"down\" is relative to the position of point in the window; otherwise
it is relative to the left edge (for positive ARG) or the right edge
\(for negative ARG) of the current window.
If no window is at the desired location, an error is signaled."
  (interactive "P")
  (transpose-window-do-transposition 'down arg))

;;;###autoload
(defun transpose-window-default-keybindings ()
  "Set up keybindings for `transpose-window'."
  (interactive)
  (global-set-key (kbd "M-S-<left>")  'transpose-window-left)
  (global-set-key (kbd "M-S-<right>") 'transpose-window-right)
  (global-set-key (kbd "M-S-<up>")    'transpose-window-up)
  (global-set-key (kbd "M-S-<down>")  'transpose-window-down))


(provide 'transpose-window)
