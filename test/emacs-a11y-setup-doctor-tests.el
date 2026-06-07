;;; emacs-a11y-setup-doctor-tests.el --- ERT doctor tests -*- lexical-binding: t; -*-

(require 'ert)
(require 'cl-lib)
(require 'emacs-a11y-setup)

(defconst emacs-a11y-setup--required-doc-artifacts
  '("docs/README.md"
    "docs/use-case-global.puml"
    "docs/use-cases.md"
    "docs/handoff-contract.md"
    "docs/migration-from-emacs-a11y.md"
    "docs/sequence/first-run-workspace.puml"
    "docs/sequence/bootstrap-handoff.puml"
    "docs/sequence/internal-doctor.puml"
    "docs/sequence/module-loading.puml"
    "docs/sequence/module-migration-inventory.puml"))

(ert-deftest emacs-a11y-setup-doctor-generates-text-report ()
  (let* ((tmp (make-temp-file "a11y-doctor-" t)))
    (emacs-a11y-setup-create-workspace :workspace-path tmp)
    (let ((result (emacs-a11y-setup-run-doctor tmp 'iniciante)))
      (should (string-match-p "timestamp:" (plist-get result :report-text)))
      (should (string-match-p "perfil ativo:" (plist-get result :report-text)))
      (should (file-exists-p (plist-get result :report-path))))))

(ert-deftest emacs-a11y-setup-doctor-writes-logs-and-reports ()
  (let* ((tmp (make-temp-file "a11y-doctor-" t)))
    (emacs-a11y-setup-create-workspace :workspace-path tmp)
    (let ((result (emacs-a11y-setup-run-doctor tmp 'iniciante)))
      (should (file-exists-p (plist-get result :report-path)))
      (should (file-exists-p (plist-get result :log-path))))))

(ert-deftest emacs-a11y-setup-doctor-permission-failure-scenario ()
  (let* ((tmp (make-temp-file "a11y-doctor-ro-" t)))
    (emacs-a11y-setup-create-workspace :workspace-path tmp)
    (cl-letf (((symbol-function 'file-writable-p)
               (lambda (path)
                 (if (string= (directory-file-name (expand-file-name path))
                              (directory-file-name (expand-file-name tmp)))
                     nil
                   t))))
      (let ((result (emacs-a11y-setup-run-doctor tmp 'iniciante)))
        (should-not (plist-get result :ok))
        (should (seq-some (lambda (f) (string-match-p "nao e gravavel" f))
                          (plist-get result :failures)))))))

(ert-deftest emacs-a11y-setup-doctor-emacspeak-tts-limitation-warning ()
  (let* ((tmp (make-temp-file "a11y-doctor-" t)))
    (setq emacs-a11y-setup-last-handoff-result
          '(:ok t :contract (:tts_backend "unknown")))
    (emacs-a11y-setup-create-workspace :workspace-path tmp)
    (let ((result (emacs-a11y-setup-run-doctor tmp 'iniciante)))
      (should (seq-some (lambda (w)
                          (or (string-match-p "Emacspeak" w)
                              (string-match-p "TTS" w)))
                        (plist-get result :warnings))))))

(ert-deftest emacs-a11y-setup-doctor-required-doc-artifacts-present ()
  (dolist (artifact emacs-a11y-setup--required-doc-artifacts)
    (should (file-exists-p artifact))))

(ert-deftest emacs-a11y-setup-doctor-plantuml-basic-syntax ()
  (dolist (artifact '("docs/use-case-global.puml"
                      "docs/sequence/first-run-workspace.puml"
                      "docs/sequence/bootstrap-handoff.puml"
                      "docs/sequence/internal-doctor.puml"
                      "docs/sequence/module-loading.puml"
                      "docs/sequence/module-migration-inventory.puml"))
    (with-temp-buffer
      (insert-file-contents artifact)
      (let ((content (buffer-string)))
        (should (string-match-p "@startuml" content))
        (should (string-match-p "@enduml" content))))))

(ert-deftest emacs-a11y-setup-doctor-use-cases-cover-p1-p2-stories ()
  (with-temp-buffer
    (insert-file-contents "docs/use-cases.md")
    (let ((content (buffer-string)))
      (should (string-match-p "US1" content))
      (should (string-match-p "US2" content))
      (should (string-match-p "US4" content))
      (should (string-match-p "US5" content)))))

(provide 'emacs-a11y-setup-doctor-tests)
