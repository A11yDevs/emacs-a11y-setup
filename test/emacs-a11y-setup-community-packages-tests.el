;;; emacs-a11y-setup-community-packages-tests.el --- ERT tests for community packages
;; -*- lexical-binding: t; -*-

;; Minimal ERT tests that validate the hello-world artifact used for
;; package installation and loading verification in specs/002-community-package-management.

(require 'ert)

(defun a11y--add-artifact-to-load-path ()
  "Add artifact a11y-hello path to `load-path' for test runs." 
  (let ((p (expand-file-name "specs/002-community-package-management/artifacts/a11y-hello" default-directory)))
    (when (file-directory-p p)
      (add-to-list 'load-path p))))

(a11y--add-artifact-to-load-path)

(ert-deftest a11y-hello-loads-and-returns-message ()
  "Test that `a11y-hello' can be loaded and `a11y-hello-say' returns expected message." 
  (should (load "a11y-hello" nil t))
  (should (featurep 'a11y-hello))
  (should (fboundp 'a11y-hello-say))
  (should (string= (a11y-hello-say) "Olá, a11y-hello está carregado!")))

(provide 'emacs-a11y-setup-community-packages-tests)

;;; emacs-a11y-setup-community-packages-tests.el ends here
