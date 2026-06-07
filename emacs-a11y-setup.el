;;; emacs-a11y-setup.el --- Accessible workspace setup package -*- lexical-binding: t; -*-

;; Version: 0.1.0
;; Package-Requires: ((emacs "28.1"))

;;; Commentary:
;; Entrada publica do pacote emacs-a11y-setup.

;;; Code:

(require 'cl-lib)
(require 'subr-x)
(require 'emacs-a11y-setup-workspace)
(require 'emacs-a11y-setup-handoff)
(require 'emacs-a11y-setup-profiles)
(require 'emacs-a11y-setup-modules)
(require 'emacs-a11y-setup-doctor)

(defvar emacs-a11y-setup-version "0.1.0"
  "Versao do pacote emacs-a11y-setup.")

(defvar emacs-a11y-setup-active-workspace nil
  "Ultimo workspace ativo usado pelo setup.")

(defun emacs-a11y-setup--default-source-package-path ()
  "Retorna caminho raiz do pacote atual para bootstrap local."
  (let ((library-path (or (symbol-file 'emacs-a11y-setup-bootstrap-local 'defun)
                          load-file-name
                          (locate-library "emacs-a11y-setup"))))
    (unless library-path
      (error "Nao foi possivel resolver caminho do pacote emacs-a11y-setup"))
    (file-name-directory (expand-file-name library-path))))

(defun emacs-a11y-setup--delete-path-recursive (path)
  "Remove PATH com seguranca para arquivo, diretorio ou symlink."
  (when (file-symlink-p path)
    (delete-file path))
  (when (file-exists-p path)
    (if (file-directory-p path)
        (delete-directory path t)
      (delete-file path))))

(defun emacs-a11y-setup--write-env-file (env-file home-path package-path workspace-path)
  "Escreve ENV-FILE com defaults de bootstrap local."
  (with-temp-file env-file
    (insert (format "EMACS_A11Y_HOME=\"%s\"\n" home-path))
    (insert (format "EMACS_A11Y_SETUP_PACKAGE_DIR=\"%s\"\n" package-path))
    (insert (format "EMACS_A11Y_DEFAULT_WORKSPACE=\"%s\"\n" workspace-path))
    (insert "EMACS_BIN=\"emacs\"\n")))

(defun emacs-a11y-setup-bootstrap-local (&rest args)
  "Bootstrap local para desenvolvimento com defaults e overrides.
ARGS aceita plist com:
- :home-path (default: raiz resolvida por `emacs-a11y-setup-resolve-home-path`)
- :source-package-path (default: pacote atualmente carregado)
- :package-path (default: <home>/package/emacs-a11y-setup)
- :workspace-path (default: <home>/workspace)
- :env-file (default: <home>/.env)
- :launcher-path (default: <home>/bin/emacs-a11y)
- :use-symlink (default: t; quando nil, copia pacote)
- :overwrite-package (default: t)
- :overwrite-env (default: nil)
- :run-first-run (default: t)
- :profile (opcional para first-run)."
  (interactive)
  (let* ((home-path (emacs-a11y-setup-resolve-home-path (plist-get args :home-path)))
         (source-package-path (expand-file-name
                               (or (plist-get args :source-package-path)
                                   (emacs-a11y-setup--default-source-package-path))))
         (package-path (expand-file-name
                        (or (plist-get args :package-path)
                            (expand-file-name "package/emacs-a11y-setup" home-path))))
         (workspace-path (expand-file-name
                          (or (plist-get args :workspace-path)
                              (expand-file-name "workspace" home-path))))
         (env-file (expand-file-name
                    (or (plist-get args :env-file)
                        (expand-file-name ".env" home-path))))
         (launcher-path (expand-file-name
                         (or (plist-get args :launcher-path)
                             (expand-file-name "bin/emacs-a11y" home-path))))
         (launcher-source (expand-file-name "bin/emacs-a11y" source-package-path))
         (use-symlink (if (plist-member args :use-symlink)
                          (plist-get args :use-symlink)
                        t))
         (overwrite-package (if (plist-member args :overwrite-package)
                                (plist-get args :overwrite-package)
                              t))
         (overwrite-env (plist-get args :overwrite-env))
         (run-first-run (if (plist-member args :run-first-run)
                            (plist-get args :run-first-run)
                          t))
         (profile (plist-get args :profile))
         workspace-result)
    (unless (file-directory-p source-package-path)
      (error "Caminho de pacote fonte invalido: %s" source-package-path))
    (unless (file-exists-p launcher-source)
      (error "Launcher de desenvolvimento nao encontrado em: %s" launcher-source))

    (make-directory home-path t)
    (make-directory (file-name-directory package-path) t)
    (make-directory (file-name-directory launcher-path) t)

    (let ((source-true (file-truename source-package-path))
          (target-true (and (file-exists-p package-path)
                            (file-truename package-path))))
      (unless (and target-true (string= source-true target-true))
        (when (file-exists-p package-path)
          (unless overwrite-package
            (error "Destino de pacote ja existe: %s" package-path))
          (emacs-a11y-setup--delete-path-recursive package-path))
        (if use-symlink
            (make-symbolic-link source-package-path package-path)
          (copy-directory source-package-path package-path t t t))))

    (copy-file launcher-source launcher-path t)
    (set-file-modes launcher-path #o755)

    (when (or overwrite-env (not (file-exists-p env-file)))
      (emacs-a11y-setup--write-env-file env-file home-path package-path workspace-path))

    (setq workspace-result
          (if run-first-run
              (emacs-a11y-setup-first-run :workspace-path workspace-path :profile profile)
            (emacs-a11y-setup-create-workspace :workspace-path workspace-path)))

    (list :ok t
          :home-path home-path
          :source-package-path source-package-path
          :package-path package-path
          :workspace-path workspace-path
          :env-file env-file
          :launcher-path launcher-path
          :workspace-result workspace-result)))

(defun emacs-a11y-setup--initialize-from-workspace ()
  "Inicializacao usada pelo init.el gerado no workspace."
  (ignore-errors
    (let* ((profile-data (emacs-a11y-setup-apply-profile (emacs-a11y-setup-get-default-profile)))
           (result (emacs-a11y-setup-load-modules
                    (plist-get profile-data :essential)
                    (plist-get profile-data :optional))))
      (unless (plist-get result :ok)
        (message "[emacs-a11y-setup] Falhas em modulos essenciais: %S"
                 (plist-get result :failures))))))

(defun emacs-a11y-setup-create-workspace (&rest args)
  "Cria workspace isolado.
ARGS aceita plist com :workspace-path."
  (interactive)
  (let* ((workspace-path (plist-get args :workspace-path))
         (workspace (emacs-a11y-setup-create-workspace-structure workspace-path))
         (status (emacs-a11y-setup-validate-and-repair-workspace workspace)))
    (setq emacs-a11y-setup-active-workspace workspace)
    (when (called-interactively-p 'interactive)
      (message "Workspace preparado em: %s" workspace))
    status))

(defun emacs-a11y-setup-first-run (&rest args)
  "Executa fluxo de primeiro uso.
ARGS aceita plist com :workspace-path e :profile."
  (interactive)
  (let* ((workspace-path (plist-get args :workspace-path))
         (profile (or (plist-get args :profile)
                      (emacs-a11y-setup-get-default-profile)))
         (_status (emacs-a11y-setup-create-workspace :workspace-path workspace-path))
         (profile-data (emacs-a11y-setup-apply-profile profile))
         (modules-result (emacs-a11y-setup-load-modules
                          (plist-get profile-data :essential)
                          (plist-get profile-data :optional)))
         (doctor (emacs-a11y-setup-run-doctor workspace-path profile)))
    (list :workspace (plist-get doctor :workspace)
          :profile profile
          :modules modules-result
          :doctor doctor)))

(defun emacs-a11y-setup-bootstrap (handoff-input)
  "Processa HANDOFF-INPUT e integra bootstrap externo ao setup interno."
  (interactive "sJSON de handoff ou caminho de arquivo: ")
  (let* ((handoff-result (emacs-a11y-setup-process-handoff handoff-input)))
    (if (plist-get handoff-result :ok)
        (let* ((workspace (plist-get (plist-get handoff-result :contract) :workspace_path))
               (_status (emacs-a11y-setup-create-workspace :workspace-path workspace))
               (doctor-result (emacs-a11y-setup-run-doctor workspace)))
          (list :ok t
                :handoff handoff-result
                :doctor doctor-result))
      (let ((errors (plist-get handoff-result :errors)))
        (list :ok nil
              :errors errors
              :message (mapconcat #'identity errors " | "))))))

(defun emacs-a11y-setup-doctor (&optional workspace-path profile)
  "Executa doctor interativo."
  (interactive)
  (let ((result (emacs-a11y-setup-run-doctor workspace-path profile)))
    (when (called-interactively-p 'interactive)
      (message "%s" (plist-get result :report-text)))
    result))

(defun emacs-a11y-setup-doctor-batch (&optional workspace-path profile)
  "Executa doctor em batch e retorna codigo apropriado.
0 para sucesso, 1 para falha."
  (let* ((result (emacs-a11y-setup-run-doctor workspace-path profile))
         (ok (plist-get result :ok)))
    (princ (plist-get result :report-text))
    (princ "\n")
    (when noninteractive
      (kill-emacs (if ok 0 1)))
    (if ok 0 1)))

(defun emacs-a11y-setup-open-dashboard ()
  "Abre dashboard textual acessivel com ultimo relatorio."
  (interactive)
  (let ((buffer (get-buffer-create "*Emacs A11y Setup Dashboard*")))
    (with-current-buffer buffer
      (read-only-mode -1)
      (erase-buffer)
      (insert (emacs-a11y-setup-dashboard-text))
      (goto-char (point-min))
      (view-mode 1))
    (pop-to-buffer buffer)
    buffer))

(provide 'emacs-a11y-setup)

;;; emacs-a11y-setup.el ends here
