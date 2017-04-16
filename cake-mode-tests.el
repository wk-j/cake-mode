(require 'ert)
(require 'subr-x)
(require 'json)
(require 'url)

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
(load-file (find-path "request.el"))

(defun go ()
  (print "Hello, world"))

(add-hook 'emacs-startup-hook 'go)

(defun find--b () 
  (find-name-dired "./" "build.cake"))

(ert-deftest should-get-google ()
  (request
   "https://google.com"
   :success (function*
             (lambda (&key data &allow-other-keys)
               (progn
                 (print "Hello, world"))))))


(defun query-httpbin (handler)
  (request
   "http://httpbin.org/get"
   :params '(("key" . "value") ("key2" . "value2"))
   :parser 'json-read
   :success (function* handler)))
   ;;:success (function*
   ;;          (lambda (&key data &allow-other-keys)
   ;;            (message "I sent: %S" (assoc-default 'args data))))))

(defun http-handler ()
  (lambda (&key data &allow-other-keys)
    (message "I send: %s" (assoc-default 'args data))))

(ert-deftest should-httpbin ()
  (query-httpbin http-handler))

(ert-deftest should-run-execute-multiple-statment ()
  (progn
    (print "World")
    (print "Hello"))
  )

(ert-deftest should-get-dot-location-from-backend ()
  (request
   "http://localhost:8080/getDotLocation"
   :params '(("currentDir" . "./"))
   :parser 'json-read
   :success (function*
              (lambda (&key data &allow-other-keys)
                (progn
                  (print "Hello, world!")
                  (message"%s" data))))))

(ert-deftest shoud-get-tasks ()
  (should (equal
           (get-cake-tasks "tests/build.cake")
           '("Restore" "Build" "Test"))))

(ert-deftest should-one-eq-one ()
  (should (= 1 1)))

(defun find--build-cake ()
  (find-file "build.cake" "."))

(ert-deftest should-fdfind ()
  (shell-command-to-string "mdfind --name build.cake --onlyin ./"))
