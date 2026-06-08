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

<<<<<<< Updated upstream
=======
(ert-deftest eaacs-exit-code-mapping-test ()
  (should (= (eaacs--envelope->exit-code (list :ok t)) 0))
  ;;; emacs-a11y-setup-community-packages-tests.el --- ERT tests for community packages
  ;; -*- lexical-binding: t; -*-

  ;; Minimal ERT tests that validate the hello-world artifact used for
  ;; package installation and loading verification in specs/002-community-package-management.

  (require 'ert)
  (require 'cl-lib)

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

  (ert-deftest eaacs-exit-code-mapping-test ()
    (should (= (eaacs--envelope->exit-code (list :ok t)) 0))
    (should (= (eaacs--envelope->exit-code (list :ok nil)) 1)))

  (ert-deftest eaacs-workspace-path-wrappers-test ()
    (let ((eaacs--registry nil)
          (ws (expand-file-name "specs/002-community-package-management/artifacts/a11y-hello" default-directory)))
      (should (plist-get (eaacs-install "a11y-hello" "a11y-hello.el" t ws) :ok))
      (should (plist-get (eaacs-activate "a11y-hello" t ws) :ok))
      (should (string-match-p "a11y-hello" (plist-get (eaacs-list ws) :message)))
      (should (plist-get (eaacs-deactivate "a11y-hello" t ws) :ok))
      (should (plist-get (eaacs-remove "a11y-hello" t ws) :ok))))

  (ert-deftest eaacs-confirmation-gating-test ()
    (let ((eaacs--registry nil))
      (should (plist-get (eaacs-install "a11y-hello" "lisp/a11y-hello/a11y-hello.el" t) :ok))
      (cl-letf (((symbol-function 'y-or-n-p) (lambda (&rest _) nil)))
        (should (null (eaacs-remove "a11y-hello" nil))))
      (cl-letf (((symbol-function 'y-or-n-p) (lambda (&rest _) t)))
        (should (plist-get (eaacs-remove "a11y-hello" nil) :ok)))))

  ;; T019
  (ert-deftest eaacs-source-normalization-test ()
    (should (string= (eaacs--normalize-source-url "https://github.com/A11yDevs/emacs-a11y-setup.git/")
                     "https://github.com/A11yDevs/emacs-a11y-setup"))
    (should (string= (eaacs--normalize-ref nil) "main")))

  (ert-deftest eaacs-untrusted-source-blocks-install-test ()
    (let ((eaacs--registry nil))
      (let ((env (eaacs-install "a11y-hello" "lisp/a11y-hello/a11y-hello.el" t nil
                                "https://github.com/other-org/suspicious.git" "main")))
        (should-not (plist-get env :ok))
        (should (equal (plist-get env :changed) nil))
        (should (consp (plist-get env :errors)))
        (should (stringp (plist-get env :next-action))))))

  (ert-deftest eaacs-trusted-source-allows-install-test ()
    (let ((eaacs--registry nil)
          (ws (expand-file-name "specs/002-community-package-management/artifacts/a11y-hello" default-directory)))
      (let ((env (eaacs-install "a11y-hello" "a11y-hello.el" t ws
                                "https://github.com/A11yDevs/emacs-a11y-setup.git" nil)))
        (should (plist-get env :ok))
        (should (equal (plist-get env :command) "install")))))

  ;; T020
  (ert-deftest eaacs-runtime-check-test ()
    (let ((env (eaacs-check-runtime)))
      (should (equal (plist-get env :command) "runtime-check"))
      (should (stringp (plist-get env :message)))))

  (ert-deftest eaacs-classify-network-failure-test ()
    (let ((env (eaacs-classify-failure "install" "Network timeout while fetching remote")))
      (should-not (plist-get env :ok))
      (should (string-match-p "network" (plist-get env :message)))
      (should (string= (plist-get env :next-action) "Check internet connectivity and retry."))))

  (ert-deftest eaacs-classify-repository-failure-test ()
    (let ((env (eaacs-classify-failure "install" "Repository not found: 404")))
      (should-not (plist-get env :ok))
      (should (string-match-p "repository" (plist-get env :message)))
      (should (string= (plist-get env :next-action) "Confirm repository URL/ref and access permissions."))))

  (ert-deftest eaacs-classify-state-conflict-failure-test ()
    (let ((env (eaacs-classify-failure "install" "Package already exists, state conflict")))
      (should-not (plist-get env :ok))
      (should (string-match-p "state-conflict" (plist-get env :message)))))

  (ert-deftest eaacs-classify-unknown-failure-test ()
    (let ((env (eaacs-classify-failure "activate" "something weird happened")))
      (should-not (plist-get env :ok))
      (should (string-match-p "unknown" (plist-get env :message)))
      (should (stringp (plist-get env :next-action)))))

  ;; T018: cobertura para origem não confiável, falhas de rede/repositório e diagnóstico runtime
  (ert-deftest eaacs-install-classify-diagnostics-test ()
    "Verifica validação de origem, classificação de falhas e diagnóstico de runtime."
    (let ((eaacs--registry nil))
      ;; origem não confiável falha via validação de política
      (let ((policy (eaacs-validate-source-policy "https://github.com/malicious/repo.git" nil)))
        (should-not (plist-get policy :ok))
        (should (consp (plist-get policy :errors)))
        (should (stringp (plist-get policy :next-action))))

      ;; classificar falha de rede
      (let ((env-net (eaacs-classify-failure "install" "Network timeout while fetching remote")))
        (should-not (plist-get env-net :ok))
        (should (string-match-p "network" (plist-get env-net :message)))
        (should (string= (plist-get env-net :next-action) "Check internet connectivity and retry.")))

      ;; classificar falha de repositório
      (let ((env-repo (eaacs-classify-failure "install" "Repository not found: 404")))
        (should-not (plist-get env-repo :ok))
        (should (string-match-p "repository" (plist-get env-repo :message)))
        (should (string= (plist-get env-repo :next-action) "Confirm repository URL/ref and access permissions.")))

      ;; runtime diagnostic: eaacs-check-runtime retorna envelope com mensagem
      (let ((env-rt (eaacs-check-runtime)))
        (should (stringp (plist-get env-rt :message)))
        (should (stringp (plist-get env-rt :command)))))
    )

  ;; T021
  (ert-deftest eaacs-log-path-is-generated-test ()
    "T021: install deve preencher :log-path dentro do workspace."
    (let ((eaacs--registry nil)
          (ws (expand-file-name "specs/002-community-package-management/artifacts/a11y-hello" default-directory)))
      (let ((env (eaacs-install "a11y-hello" "a11y-hello.el" t ws)))
        (should (plist-get env :ok))
        (should (stringp (plist-get env :log-path)))
        (should (string-match-p "\\.eaacs-logs" (plist-get env :log-path))))))

  (ert-deftest eaacs-log-file-is-created-test ()
    "T021: log file deve existir em disco após install."
    (let ((eaacs--registry nil)
          (ws (expand-file-name "specs/002-community-package-management/artifacts/a11y-hello" default-directory)))
      (let* ((env (eaacs-install "a11y-hello" "a11y-hello.el" t ws))
             (lp (plist-get env :log-path)))
        (should (plist-get env :ok))
        (should (file-exists-p lp)))))

  (ert-deftest eaacs-log-path-inside-workspace-test ()
    "T021: log-path deve ser subdiretório do workspace fornecido."
    (let ((eaacs--registry nil)
          (ws (expand-file-name "specs/002-community-package-management/artifacts/a11y-hello" default-directory)))
      (let ((env (eaacs-install "a11y-hello" "a11y-hello.el" t ws)))
        (should (string-prefix-p (expand-file-name ws) (plist-get env :log-path))))))


  ;; T024: regressões finais
  (ert-deftest eaacs-list-empty-test ()
    "T024: lista vazia retorna envelope ok com mensagem none."
    (let ((eaacs--registry nil))
      (let ((env (eaacs-list)))
        (should (plist-get env :ok))
        (should (string-match-p "none" (plist-get env :message))))))

  (ert-deftest eaacs-install-idempotent-test ()
    "T024: instalar o mesmo pacote duas vezes mantém exactly 1 entrada."
    (let ((eaacs--registry nil)
          (ws (expand-file-name "specs/002-community-package-management/artifacts/a11y-hello" default-directory)))
      (eaacs-install "a11y-hello" "a11y-hello.el" t ws)
      (eaacs-install "a11y-hello" "a11y-hello.el" t ws)
      (should (= (length (eaacs-list-packages)) 1))))

  (ert-deftest eaacs-update-noop-when-not-installed-test ()
    "T024: update em pacote não instalado retorna envelope com ok nil."
    (let ((eaacs--registry nil))
      (let ((env (eaacs-update "no-such-package" nil t)))
        (should-not (plist-get env :ok)))))

  (ert-deftest eaacs-update-partial-reinstall-test ()
    "T024: update em pacote instalado com path alternativo recarrega."
    (let ((eaacs--registry nil)
          (ws (expand-file-name "specs/002-community-package-management/artifacts/a11y-hello" default-directory)))
      (eaacs-install "a11y-hello" "a11y-hello.el" t ws)
      (let ((env (eaacs-update "a11y-hello" nil t ws)))
        (should (plist-get env :ok))
        (should (member "a11y-hello" (eaacs-list-packages))))))

  (ert-deftest eaacs-workspace-path-wrapper-test ()
    "Verifica que wrappers gravam `.eaacs-registry.el` no workspace fornecido."
    (let* ((eaacs--registry nil)
           (pkg-path (expand-file-name "specs/002-community-package-management/artifacts/a11y-hello/a11y-hello.el" default-directory))
           (tmp1 (make-temp-file "eaacs-ws1" t))
           (tmp2 (make-temp-file "eaacs-ws2" t))
           (ws1 (file-name-as-directory (expand-file-name tmp1)))
           (ws2 (file-name-as-directory (expand-file-name tmp2)))
           (reg1 (expand-file-name ".eaacs-registry.el" ws1))
           (reg2 (expand-file-name ".eaacs-registry.el" ws2)))
      (unwind-protect
          (progn
            (should (plist-get (emacs-a11y-setup-community-packages-install "a11y-hello" pkg-path ws1) :ok))
            (should (file-exists-p reg1))
            (should (not (file-exists-p reg2)))
            ;; install same package in other workspace
            (should (plist-get (emacs-a11y-setup-community-packages-install "a11y-hello" pkg-path ws2) :ok))
            (should (file-exists-p reg2)))
        (when (file-exists-p reg1) (delete-file reg1))
        (when (file-exists-p reg2) (delete-file reg2))
        (when (file-directory-p ws1) (delete-directory ws1 t))
        (when (file-directory-p ws2) (delete-directory ws2 t)))))

  (provide 'emacs-a11y-setup-community-packages-tests)

  ;;; emacs-a11y-setup-community-packages-tests.el ends here
