;;; tests for emacs-a11y-setup community packages
;; Run with: emacs -Q --batch -l ert -L . -l test/emacs-a11y-setup-community-packages-tests.el -f ert-run-tests-batch

(require 'ert)

(add-to-list 'load-path (expand-file-name "lisp" (file-name-directory (or load-file-name default-directory))))

;; Load package file directly to ensure it's available in CI without installation step
(when (file-exists-p (expand-file-name "lisp/a11y-hello/a11y-hello.el"))
  (load-file (expand-file-name "lisp/a11y-hello/a11y-hello.el")))

(ert-deftest a11y-hello-loaded ()
  (should (featurep 'a11y-hello)))

(ert-deftest a11y-hello-say-returns-message ()
  (should (string= (a11y-hello-say) a11y-hello-message)))
