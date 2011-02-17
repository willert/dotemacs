;;; load-paths.el ---

;; Copyright 2011 Sebastian Willert
;;
;; Author: Sebastian Willert <willert@gmail.com>
;; Version: $Id: load-paths.el,v 0.0 2011/02/17 14:05:27 willert Exp $
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
;;  just some lib paths

;; Put this file into your load-path and the following into your ~/.emacs:
;;   (load "load-paths")

;;; Code:


(add-to-list 'load-path "~/.emacs.d/lib/yaml-mode")
(add-to-list 'load-path "~/.emacs.d/lib/yasnippet")
(add-to-list 'load-path "~/.emacs.d/lib/magit")
(add-to-list 'load-path "~/.emacs.d/lib/espect")
(add-to-list 'load-path "~/.emacs.d/lib/catalyst-server")






;;; load-paths.el ends here
