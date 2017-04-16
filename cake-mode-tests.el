(require 'ert)
(require 'subr-x)
(require 'json)
(require 'url)
(require 'cl)

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

;; tests

(defun wk-get-data (key data)
  (assoc-default key data))

(defun wk-query-httpbin (handler)
  (request
   "http://httpbin.org/get"
   :params '(("key" . "value") ("key2" . "value2"))
   :parser 'json-read

   ;;:success (function* 'handler)
   ;;:success 'handler
   :success(function*
             (lambda (&key data &allow-other-keys)
             (message "-- I send: %s" (wk-get-data 'args data)) ))
   
   ;; :success (function*
   ;;           (lambda (&key data &allow-other-keys)
   ;;             (progn
   ;;               (message "I sent: %S" (assoc-default 'args data))
   ;;               (callfun handler "Data"))))))
   ))

(cl-defun wk-query-handler (&key data &allow-other-keys)
  (progn
    (message " -- I sent: %S" (assoc-default 'args data))))

(cl-defun wk-keyword-func (&key
                           (b 20)
                           (a 10))
  (progn
    (message "%d %d" a b)))

(defun wk-show-message (info)
  (message info))

;; interactive

(defun run-keyword-func()
  (interactive)
  (wk-keyword-func
   :b 200
   :a 100))

(defun run-show-message ()
  (interactive)
  (wk-show-message "Hello"))

(defun run-http-handler ()
  (interactive)
  (wk-query-httpbin 'wk-query-handler))


;; ert functions

(ert-deftest should-get-google ()
  (request
   "https://google.com"
   :success (function*
             (lambda (&key data &allow-other-keys)
               (progn
                 (print "Hello, world"))))))

(ert-deftest should-httpbin ()
  (query-httpbin 'http-handler))

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
           (ck-get-tasks "tests/build.cake")
           '("Restore" "Build" "Test"))))


(ert-deftest should-get-current-tasks()
  (should (equal
           (ck-get-tasks "./build.cake")
           '("Run-Test"))))

(ert-deftest should-one-eq-one ()
  (should (= 1 1)))

(ert-deftest should-fdfind ()
  (shell-command-to-string "mdfind --name build.cake --onlyin ./"))
