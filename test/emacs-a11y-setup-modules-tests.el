;;; emacs-a11y-setup-modules-tests.el --- ERT module tests -*- lexical-binding: t; -*-

(require 'ert)
(require 'emacs-a11y-setup)
(require 'subr-x)

(defun emacs-a11y-setup--test-load-migration-doc ()
  (with-temp-buffer
    (insert-file-contents "docs/migration-from-emacs-a11y.md")
    (buffer-string)))

(ert-deftest emacs-a11y-setup-modules-inventory-has-13-items ()
  (let* ((content (emacs-a11y-setup--test-load-migration-doc))
         (lines (split-string content "\n" t))
         (count 0))
    (dolist (line lines)
      (when (string-match-p "^| init-" line)
        (setq count (1+ count))))
    (should (= count 13))))

(ert-deftest emacs-a11y-setup-modules-inventory-classification-valid ()
  (let* ((content (emacs-a11y-setup--test-load-migration-doc))
         (lines (split-string content "\n" t))
         (ok t))
    (dolist (line lines)
      (when (string-match "^| init-[^|]+ | [^|]+ | [^|]+ | \([^|]+\) |" line)
        (let ((decision (string-trim (match-string 1 line))))
          (unless (member decision '("migrar" "adaptar" "adiar" "descartar"))
            (setq ok nil)))))
    (should ok)))

(ert-deftest emacs-a11y-setup-modules-optional-disabled-by-default ()
  (let* ((profile (emacs-a11y-setup-apply-profile 'iniciante))
         (optional (plist-get profile :optional)))
    (should-not (member 'init-java optional))
    (should-not (member 'init-java-lsp optional))
    (should-not (member 'init-gptel optional))
    (should-not (member 'init-layout-ide optional))))

(ert-deftest emacs-a11y-setup-modules-optional-failure-not-blocking-doctor ()
  (let* ((tmp (make-temp-file "a11y-module-" t))
         (emacs-a11y-setup-modules-simulated-failures '(init-completion))
         (_ws (emacs-a11y-setup-create-workspace :workspace-path tmp))
         (profile (emacs-a11y-setup-apply-profile 'iniciante))
         (result (emacs-a11y-setup-load-modules
                  (plist-get profile :essential)
                  '(init-completion))))
    (should (plist-get result :ok))
    (should (seq-some (lambda (w) (string-match-p "opcional" w))
                      (plist-get result :warnings)))))

(provide 'emacs-a11y-setup-modules-tests)
