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


;;(defgroup cake-mode nil
;;  :link '(url-link "https://github.com/wk-j/cake-mode")
;;  :group 'languages)

(require 'request)

(setq ck-build-name "build.cake")
(setq ck-bootstrap-name "build.sh")
(setq ck-bootstrap-url "http://cakebuild.net/download/bootstrapper/osx")
(setq ck-backend-url "http://localhost:9876")
(setq ck-dot-location ".")
(setq ck-params '(("currentDir") . "."))

(defun ck-get-current-dir ()
  (string-trim (shell-command-to-string "pwd")))

(defun ck-update-dot-location ()
  (interactive)
  (progn
    (request
      (concat ck-backend-url "/getDotLocation")
      :params (add-to-list 'ck-params (cons "currentDir" (ck-get-current-dir))) 
      :parser 'json-read
      :success(function*
                (lambda (&key data &allow-other-keys)
                  (progn
                    (message "Data = %s Sucess = %s"
                            (assoc-string 'data data)
                            (assoc-default 'success data))
                    (setq ck-dot-location (assoc-default 'data data))))))))

(defun ck-get-dot-location ()
  (concat ck-dot-location "/" ck-build-name))

(defun ck-file-not-exist (file)
  ;; check if file not exist
  (not (file-exists-p file)))

(defun ck-init-build ()
  ;; create build.cake in current directory
  (interactive)
  (when (ck-file-not-exist ck-build-name)
    (shell-command (format "touch %s" ck-build-name))
    (message (format "created %s success" ck-build-name))))

(defun ck-init-bootstrap ()
  ;; download bootstrap file from server
  (interactive)
  (when (ck-file-not-exist ck-bootstrap-name)
    (message (format "loading %s" ck-bootstrap-url))
    (shell-command (format "curl -Lsfo %s %s" ck-bootstrap-name ck-bootstrap-url))
    (message (format "download %s success" ck-bootstrap-url))))

(defun ck-show-tasks (tasks)
  (interactive)
  (completing-read "Target:" tasks nil t))

(defun ck-get-tasks(file)
  (mapcar (lambda (x) (nth 1 x))
          (s-match-strings-all "Task(\"\\(.*\\)\")" (f-read-text file))))

(defun ck-start-execute (name)
  (interactive)
  (progn
    (process-send-string "*shell*" (concat "cd " ck-dot-location "\n"))
    (process-send-string "*shell*" (concat "./build.sh --target " name "\n"))))

(defun ck-select-task ()
  (interactive)
  (ck-start-execute
   (ck-show-tasks
    (ck-get-tasks (ck-get-dot-location)))))

(defun ck-after-save-action()
  (progn
    (message "reload dot location")
    (when (eq major-mode 'csharp-mode)
      (ck-update-dot-location))
    (when (eq major-mode 'fsharp-mode))
      (ck-update-dot-location)))


(defun ck-open-shell()
  (interactive)
  (progn
    (split-window-right)
    (shell)))

(add-hook 'after-save-hook 'ck-after-save-action)
(spacemacs/set-leader-keys "et" 'ck-select-task)
(spacemacs/set-leader-keys "ew" 'ck-open-shell)

(provide 'cake-mode)

;;; cake-mode.el ends here

