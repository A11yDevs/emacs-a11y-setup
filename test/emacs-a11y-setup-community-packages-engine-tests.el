;;; emacs-a11y-setup-community-packages-engine-tests.el --- ERT tests for engine

(require 'ert)
(require 'emacs-a11y-setup-community-packages)

(ert-deftest eaacs-install-and-list-test ()
  (let ((eaacs--registry nil))
    (should (eaacs-install-package "a11y-hello" "lisp/a11y-hello/a11y-hello.el"))
    (should (member "a11y-hello" (eaacs-list-packages)))
    (should (fboundp 'a11y-hello-say))))

(ert-deftest eaacs-activate-deactivate-remove-test ()
  (let ((eaacs--registry nil))
    (should (eaacs-install-package "a11y-hello" "lisp/a11y-hello/a11y-hello.el"))
    (should (eaacs-activate-package "a11y-hello"))
    (should (featurep 'a11y-hello))
    (should (eaacs-deactivate-package "a11y-hello"))
    ;; unload-feature returns t when unloaded; featurep should be nil
    (should-not (featurep 'a11y-hello))
    (should (eaacs-remove-package "a11y-hello"))
    (should-not (member "a11y-hello" (eaacs-list-packages)))))

(ert-deftest eaacs-update-test ()
  (let ((eaacs--registry nil))
    (should (eaacs-install-package "a11y-hello" "lisp/a11y-hello/a11y-hello.el"))
    (should (eaacs-update-package "a11y-hello"))
    (should (member "a11y-hello" (eaacs-list-packages)))))
