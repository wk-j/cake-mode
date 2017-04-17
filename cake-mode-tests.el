(require 'ert)
(require 'cake-mode)

(ert-deftest shoud-get-tasks ()
  (should (equal
           (get-cake-tasks)
           '("Restore" "Build" "Test"))))

(ert-deftest should-one-eq-one ()
  (should (= 1 1)))



(ert-deftest should-get-tasks()
  (should (equal (get-tasks "build.cake") '("Restore" "Build" "Test"))))

(ert-deftest should-show-tasks()
  (should (equal
           (show-cake-tasks '("A" "B" "C"))
           "A")))
