;;; emacs-a11y-setup-community-packages-more-tests.el --- Additional ERT tests

(require 'ert)
(require 'emacs-a11y-setup-community-packages)

(ert-deftest eaacs-list-initially-empty-test ()
  (let ((eaacs--registry nil))
    (should (equal (eaacs-list-packages) nil))))

(ert-deftest eaacs-install-failure-test ()
  (let ((eaacs--registry nil))
    (should-not (equal (eaacs-install-package "no-such" "nonexistent/path.el") t))))

(ert-deftest eaacs-idempotent-install-test ()
  (let ((eaacs--registry nil))
    (should (eaacs-install-package "a11y-hello" "lisp/a11y-hello/a11y-hello.el"))
    (should (eaacs-install-package "a11y-hello" "lisp/a11y-hello/a11y-hello.el"))
    (should (= (length (eaacs-list-packages)) 1))))

(ert-deftest eaacs-activate-noninstalled-test ()
  (let ((eaacs--registry nil))
    (should-not (eaacs-activate-package "no-such-package"))))

(ert-deftest eaacs-update-noninstalled-test ()
  (let ((eaacs--registry nil))
    (should-not (eaacs-update-package "no-such"))))
