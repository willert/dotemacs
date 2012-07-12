;;; private-conf.el ---

;; Copyright 2011 Sebastian Willert
;;
;; Author: Sebastian Willert <willert@gmail.com>
;; Version: $Id: private-conf.el,v 0.0 2011/02/17 14:40:10 willert Exp $
;; Keywords:
;; X-URL: not distributed yet

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:
;; Loads or recreates a private config section that can easily
;; excluded from version control

;; Put this file into your load-path and the following into your ~/.emacs:
;;   (require 'private-conf)

;;; Code:

(provide 'private-conf)
(eval-when-compile
  (require 'cl))

; pull in local config if available
(load (concat emacs-conf-path "private.el") t)

; auto-create an empty file if not
(let
    ((config-file  (concat emacs-conf-path "private.el")))
  (if (file-exists-p config-file)
      nil
    (save-excursion
      (find-file-literally config-file)
      (insert
       ";; local config changes can go here\n"
       ";; changes to this file won't interfere with the dotemacs repository")
      (save-buffer)
      (message "Created default local config in %s" (buffer-file-name))
      (kill-buffer nil))))

;;; private-conf.el ends here
