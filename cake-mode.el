;;; cake-mode.el --- Major mode for Cake Build  -*- lexical-binding: t; -*-

;; Copyright (C) 2017 wk-j 

;; wk-j <somnuk.wk@gmail.com>
;; Keywords: languages

;; Version: 0.1

;; This program is free software; you can redistribute it and/or modify
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

;;

;;; Code:

(defgroup cake-mode nil
  "Cake Build major mode"
  :link '(url-link "https://github.com/wk-j/cake-mode")
  :group 'languages)

(setq cake-build-name "build.cake")
(setq cake-bootstrap-name "build.sh")
(setq cake-bootstrap-url "http://cakebuild.net/download/bootstrapper/osx")

(defun file-not-exist (file)
  (not (file-exists-p file)))

(defun init-cake-build ()
  (interactive)
  (when (file-not-exist cake-build-name)
    (shell-command (format "touch %s" cake-build-name))
    (message (format "created %s success" cake-build-name))))

(defun init-cake-bootstrap ()
  (interactive)
  (when (file-not-exist cake-bootstrap-name)
    (message (format "loading %s" cake-bootstrap-url))
    (shell-command (format "curl -Lsfo %s %s" cake-bootstrap-name cake-bootstrap-url))
    (message (format "download %s success" cake-bootstrap-url))))


(provide 'cake-mode)
;;; cake-mode.el ends here
