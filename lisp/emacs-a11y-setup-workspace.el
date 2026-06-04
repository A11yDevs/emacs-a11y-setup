;;; emacs-a11y-setup-workspace.el --- Workspace management -*- lexical-binding: t; -*-

;; Copyright (C) 2026 A11yDevs

;;; Commentary:
;; Cria, valida e repara workspace isolado para o pacote emacs-a11y-setup.

;;; Code:

(require 'cl-lib)
(require 'subr-x)

(defgroup emacs-a11y-setup nil
  "Configuracao do emacs-a11y-setup."
  :group 'applications)

(defcustom emacs-a11y-setup-workspace-path nil
  "Caminho do workspace isolado.
Se nil, usa um padrao por plataforma."
  :type '(choice (const :tag "Padrao por plataforma" nil)
                 (directory :tag "Caminho"))
  :group 'emacs-a11y-setup)

(defconst emacs-a11y-setup--workspace-required-dirs
  '("config" "profiles" "logs" "reports" "backups")
  "Diretorios obrigatorios do workspace.")

(defconst emacs-a11y-setup--workspace-required-files
  '("init.el" "early-init.el" "custom.el")
  "Arquivos obrigatorios do workspace.")

(defun emacs-a11y-setup--platform-default-workspace-path ()
  "Retorna o caminho padrao do workspace por plataforma."
  (let ((home (or (getenv "HOME") "~")))
    (cond
     ((eq system-type 'windows-nt)
      (expand-file-name "AppData/Roaming/emacs-a11y-setup" home))
     ((eq system-type 'darwin)
      (expand-file-name ".emacs-a11y-setup" home))
     ((eq system-type 'gnu/linux)
      (expand-file-name ".emacs-a11y-setup" home))
     (t
      (expand-file-name ".emacs-a11y-setup" home)))))

(defun emacs-a11y-setup-resolve-workspace-path (&optional explicit-path)
  "Resolve caminho do workspace usando EXPLICIT-PATH, customizacao ou padrao."
  (expand-file-name (or explicit-path
                        emacs-a11y-setup-workspace-path
                        (emacs-a11y-setup--platform-default-workspace-path))))

(defun emacs-a11y-setup--dangerous-personal-path-p (path)
  "Retorna nao-nil quando PATH aponta para config pessoal proibida."
  (let* ((expanded (directory-file-name (expand-file-name path)))
         (emacs-d (directory-file-name (expand-file-name "~/.emacs.d")))
         (config-emacs (directory-file-name (expand-file-name "~/.config/emacs"))))
    (or (string= expanded emacs-d)
        (string= expanded config-emacs))))

(defun emacs-a11y-setup--ensure-directory (path)
  "Garante que PATH exista como diretorio."
  (unless (file-directory-p path)
    (make-directory path t))
  path)

(defun emacs-a11y-setup--write-file-if-missing (file-path content)
  "Escreve CONTENT em FILE-PATH apenas se o arquivo nao existir."
  (unless (file-exists-p file-path)
    (with-temp-file file-path
      (insert content))))

(defun emacs-a11y-setup--workspace-init-template ()
  "Template de init.el do workspace."
  (mapconcat
   #'identity
   '(";;; init.el --- Workspace init for emacs-a11y-setup -*- lexical-binding: t; -*-"
     ""
     ";; Arquivo gerado automaticamente por emacs-a11y-setup."
     ";; Nao carrega init pessoal em ~/.emacs.d ou ~/.config/emacs."
     ""
     "(require 'emacs-a11y-setup)"
     "(setq custom-file (expand-file-name \"custom.el\" user-emacs-directory))"
     "(load custom-file t)"
     "(when (fboundp 'emacs-a11y-setup--initialize-from-workspace)"
     "  (emacs-a11y-setup--initialize-from-workspace))"
     "")
   "\n"))

(defun emacs-a11y-setup--workspace-early-init-template ()
  "Template de early-init.el do workspace."
  (mapconcat
   #'identity
   '(";;; early-init.el --- Workspace early init for emacs-a11y-setup -*- lexical-binding: t; -*-"
     ""
     ";; Arquivo minimo para inicializacao previsivel."
     "(setq package-enable-at-startup nil)"
     "")
   "\n"))

(defun emacs-a11y-setup--workspace-custom-template ()
  "Template de custom.el do workspace."
  (mapconcat
   #'identity
   '(";;; custom.el --- Workspace custom file for emacs-a11y-setup -*- lexical-binding: t; -*-"
     ""
     "(provide 'workspace-custom)"
     "")
   "\n"))

(defun emacs-a11y-setup-create-workspace-structure (&optional explicit-path)
  "Cria estrutura minima idempotente de workspace e retorna seu caminho."
  (let* ((workspace (emacs-a11y-setup-resolve-workspace-path explicit-path))
         (dirs (mapcar (lambda (dir) (expand-file-name dir workspace))
                       emacs-a11y-setup--workspace-required-dirs))
         (init-file (expand-file-name "init.el" workspace))
         (early-init-file (expand-file-name "early-init.el" workspace))
         (custom-file (expand-file-name "custom.el" workspace)))
    (when (emacs-a11y-setup--dangerous-personal-path-p workspace)
      (error "Caminho de workspace invalido: nao use ~/.emacs.d ou ~/.config/emacs"))
    (emacs-a11y-setup--ensure-directory workspace)
    (dolist (dir dirs)
      (emacs-a11y-setup--ensure-directory dir))
    (emacs-a11y-setup--write-file-if-missing init-file
                                              (emacs-a11y-setup--workspace-init-template))
    (emacs-a11y-setup--write-file-if-missing early-init-file
                                              (emacs-a11y-setup--workspace-early-init-template))
    (emacs-a11y-setup--write-file-if-missing custom-file
                                              (emacs-a11y-setup--workspace-custom-template))
    workspace))

(defun emacs-a11y-setup--workspace-path-writable-p (path)
  "Retorna nao-nil se PATH for gravavel."
  (condition-case nil
      (and (file-directory-p path)
           (file-writable-p path))
    (error nil)))

(defun emacs-a11y-setup-workspace-status (&optional explicit-path)
  "Retorna status detalhado do workspace em plist."
  (let* ((workspace (emacs-a11y-setup-resolve-workspace-path explicit-path))
         (missing-dirs nil)
         (missing-files nil))
    (dolist (dir emacs-a11y-setup--workspace-required-dirs)
      (let ((dir-path (expand-file-name dir workspace)))
        (unless (file-directory-p dir-path)
          (push dir-path missing-dirs))))
    (dolist (file emacs-a11y-setup--workspace-required-files)
      (let ((file-path (expand-file-name file workspace)))
        (unless (file-exists-p file-path)
          (push file-path missing-files))))
    (list :workspace workspace
          :exists (file-directory-p workspace)
          :writable (emacs-a11y-setup--workspace-path-writable-p workspace)
          :missing-dirs (nreverse missing-dirs)
          :missing-files (nreverse missing-files)
          :valid (and (file-directory-p workspace)
                      (emacs-a11y-setup--workspace-path-writable-p workspace)
                      (null missing-dirs)
                      (null missing-files)))))

(defun emacs-a11y-setup-validate-and-repair-workspace (&optional explicit-path)
  "Valida e repara o workspace de forma segura."
  (let* ((workspace (emacs-a11y-setup-create-workspace-structure explicit-path))
         (status (emacs-a11y-setup-workspace-status workspace)))
    (if (plist-get status :valid)
        status
      (error "Workspace invalido mesmo apos reparo: %S" status))))

(provide 'emacs-a11y-setup-workspace)

;;; emacs-a11y-setup-workspace.el ends here
