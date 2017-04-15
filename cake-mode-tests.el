(require 'ert)
(require 'subr-x)

;; find ~/.emacs.d -name "f.el"
;; emacs -batch -l ert -l cake-mode-tests.el -f ert-run-tests-batch-and-exit

(defun find-path (lib)
  (string-trim
   (shell-command-to-string
    (format "find ~/.emacs.d -name %s" lib))))

(load-file "cake-mode.el")
(load-file (find-path "dash.el"))
(load-file (find-path "s.el"))
(load-file (find-path "f.el"))

(defun go ()
  (print "Hello, world"))

(add-hook 'emacs-startup-hook 'go)

(ert-deftest shoud-get-tasks ()
  (should (equal
           (get-cake-tasks "tests/build.cake")
           '("Restore" "Build" "Test"))))

(ert-deftest should-one-eq-one ()
  (should (= 1 1)))


(defun find--build-cake ()
  (find-file "build.cake" "."))

(defun find--b () 
   (find-name-dired "./" "build.cake"))

(ert-deftest should-find-files ()
  (print
    (find--build-cake)))

(ert-deftest should-fdfind ()
  (shell-command-to-string "mdfind --name build.cake --onlyin ./"))

(ert-deftest should-fine-2 ()
  (print
   (find--b)))
