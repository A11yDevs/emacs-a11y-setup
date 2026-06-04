;;; emacs-a11y-setup-profiles.el --- Profile definitions -*- lexical-binding: t; -*-

;;; Code:

(require 'cl-lib)
(require 'subr-x)

(defconst emacs-a11y-setup-profiles
  '((iniciante
     :description "Perfil conservador para primeiro uso"
     :essential (init-core init-accessibility init-navigation init-dired init-shell)
     :optional (init-completion)
     :credential-modules (init-gptel init-java-lsp))
    (emacspeak-basico
     :description "Perfil focado em acessibilidade com Emacspeak"
     :essential (init-core init-accessibility init-navigation)
     :optional (init-shell)
     :credential-modules (init-gptel))
    (java
     :description "Perfil para Java"
     :essential (init-core init-accessibility init-navigation init-java)
     :optional (init-java-lsp init-shell)
     :credential-modules (init-gptel))
    (latex
     :description "Perfil para LaTeX"
     :essential (init-core init-accessibility init-navigation init-completion)
     :optional (init-shell)
     :credential-modules (init-gptel))
    (termux
     :description "Perfil para Android/Termux"
     :essential (init-core init-accessibility init-navigation init-shell)
     :optional (init-dired)
     :credential-modules (init-gptel))
    (windows-nativo
     :description "Perfil para Windows nativo"
     :essential (init-core init-accessibility init-navigation init-dired)
     :optional (init-shell)
     :credential-modules (init-gptel))
    (oficina-curso
     :description "Perfil para oficinas e cursos"
     :essential (init-core init-accessibility init-navigation init-dired init-completion)
     :optional (init-shell)
     :credential-modules (init-gptel init-java-lsp))
    (avancado
     :description "Perfil avancado com mais modulos opcionais"
     :essential (init-core init-accessibility init-navigation init-dired init-shell init-completion)
     :optional (init-java init-java-lsp init-layout init-layout-ide init-activities)
     :credential-modules (init-gptel)))
  "Mapa de perfis disponiveis.")

(defcustom emacs-a11y-setup-default-profile 'iniciante
  "Perfil padrao conservador para primeiro uso."
  :type 'symbol
  :group 'emacs-a11y-setup)

(defun emacs-a11y-setup-profile-exists-p (profile)
  "Retorna nao-nil quando PROFILE existe."
  (assoc profile emacs-a11y-setup-profiles))

(defun emacs-a11y-setup-get-profile (profile)
  "Retorna plist do PROFILE ou nil."
  (cdr (assoc profile emacs-a11y-setup-profiles)))

(defun emacs-a11y-setup-get-default-profile ()
  "Retorna o simbolo do perfil padrao."
  emacs-a11y-setup-default-profile)

(defun emacs-a11y-setup-profile-essential-modules (profile)
  "Retorna lista de modulos essenciais de PROFILE."
  (plist-get (emacs-a11y-setup-get-profile profile) :essential))

(defun emacs-a11y-setup-profile-optional-modules (profile)
  "Retorna lista de modulos opcionais de PROFILE."
  (plist-get (emacs-a11y-setup-get-profile profile) :optional))

(defun emacs-a11y-setup-profile-credential-modules (profile)
  "Retorna lista de modulos com credenciais de PROFILE."
  (plist-get (emacs-a11y-setup-get-profile profile) :credential-modules))

(defun emacs-a11y-setup-apply-profile (&optional profile)
  "Aplica PROFILE e retorna plist com modulos ativos.
Modulos que exigem credenciais permanecem desabilitados por padrao."
  (let* ((target (or profile (emacs-a11y-setup-get-default-profile)))
         (plist (emacs-a11y-setup-get-profile target)))
    (unless plist
      (error "Perfil inexistente: %s" target))
    (let* ((essentials (copy-sequence (plist-get plist :essential)))
           (optional (copy-sequence (plist-get plist :optional)))
           (credential (copy-sequence (plist-get plist :credential-modules)))
           (optional-without-credentials
            (cl-set-difference optional credential)))
      (list :profile target
            :essential essentials
            :optional optional-without-credentials
            :disabled-credentials credential))))

(provide 'emacs-a11y-setup-profiles)

;;; emacs-a11y-setup-profiles.el ends here
