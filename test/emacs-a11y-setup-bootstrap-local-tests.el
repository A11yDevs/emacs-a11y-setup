;;; emacs-a11y-setup-bootstrap-local-tests.el --- ERT local bootstrap tests -*- lexical-binding: t; -*-

(require 'ert)
(require 'emacs-a11y-setup)

(ert-deftest emacs-a11y-setup-bootstrap-local-creates-layout ()
  (let* ((tmp-home (make-temp-file "a11y-bootstrap-home-" t))
         (source-path (emacs-a11y-setup--default-source-package-path))
         (result (emacs-a11y-setup-bootstrap-local
                  :home-path tmp-home
                  :source-package-path source-path
                  :run-first-run nil
                  :overwrite-env t))
         (package-path (plist-get result :package-path))
         (workspace-path (plist-get result :workspace-path))
         (env-file (plist-get result :env-file))
         (launcher-path (plist-get result :launcher-path)))
    (should (plist-get result :ok))
    (should (file-directory-p (plist-get result :home-path)))
    (should (file-exists-p package-path))
    (should (file-symlink-p package-path))
    (should (file-exists-p launcher-path))
    (should (file-exists-p env-file))
    (should (file-exists-p (expand-file-name "init.el" workspace-path)))
    (let ((content (with-temp-buffer
                     (insert-file-contents env-file)
                     (buffer-string))))
      (should (string-match-p "EMACS_A11Y_HOME" content))
      (should (string-match-p "EMACS_A11Y_SETUP_PACKAGE_DIR" content))
      (should (string-match-p "EMACS_A11Y_DEFAULT_WORKSPACE" content)))))

(provide 'emacs-a11y-setup-bootstrap-local-tests)
