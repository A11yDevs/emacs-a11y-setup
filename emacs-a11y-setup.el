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
