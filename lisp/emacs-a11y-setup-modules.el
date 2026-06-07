;;; emacs-a11y-setup-modules.el --- Module registry and resilient loading -*- lexical-binding: t; -*-

;;; Code:

(require 'cl-lib)
(require 'seq)
(require 'subr-x)

(defconst emacs-a11y-setup-module-registry-essential
  '((init-core :domain core)
    (init-accessibility :domain accessibility)
    (init-navigation :domain navigation)
    (init-dired :domain dired)
    (init-shell :domain shell)
    (init-completion :domain completion))
  "Registro de modulos essenciais por dominio.")

(defconst emacs-a11y-setup-module-registry-optional
  '((init-java :domain java)
    (init-java-lsp :domain java)
    (init-gptel :domain ai :requires-credentials t)
    (init-layout :domain ui)
    (init-layout-ide :domain ui)
    (init-activities :domain productivity)
    (init-latex :domain latex))
  "Registro de modulos opcionais.")

(defvar emacs-a11y-setup-modules-virtual
  '(init-core init-accessibility init-navigation init-dired init-shell
              init-completion init-java init-java-lsp init-gptel init-layout
              init-layout-ide init-activities init-latex)
  "Modulos virtuais considerados carregaveis para o esqueleto inicial.")

(defvar emacs-a11y-setup-modules-simulated-failures nil
  "Lista de modulos que devem falhar em testes/simulacoes.")

(defun emacs-a11y-setup-module-known-p (module)
  "Retorna nao-nil quando MODULE existe em algum registro."
  (or (assoc module emacs-a11y-setup-module-registry-essential)
      (assoc module emacs-a11y-setup-module-registry-optional)))

(defun emacs-a11y-setup-module-requires-credentials-p (module)
  "Retorna nao-nil quando MODULE exige credenciais."
  (let ((entry (assoc module emacs-a11y-setup-module-registry-optional)))
    (and entry (plist-get (cdr entry) :requires-credentials))))

(defun emacs-a11y-setup--simulate-module-load (module)
  "Simula carregamento de MODULE com politica resiliente."
  (cond
   ((memq module emacs-a11y-setup-modules-simulated-failures)
    (list :module module :status 'failed :message "Falha simulada"))
   ((memq module emacs-a11y-setup-modules-virtual)
    (list :module module :status 'loaded :message "Modulo virtual carregado"))
   ((featurep module)
    (list :module module :status 'loaded :message "Feature ja carregada"))
   (t
    (condition-case err
        (progn
          (require module)
          (list :module module :status 'loaded :message "Modulo carregado"))
      (error
       (list :module module :status 'failed :message (error-message-string err)))))))

(defun emacs-a11y-setup-load-modules (essential optional)
  "Carrega ESSENTIAL e OPTIONAL com politica resiliente.
Falha em modulo essencial vira erro. Falha em opcional vira aviso."
  (let ((essential-loaded nil)
        (optional-loaded nil)
        (warnings nil)
        (failures nil))
    (dolist (module essential)
      (let ((result (emacs-a11y-setup--simulate-module-load module)))
        (if (eq (plist-get result :status) 'loaded)
            (push result essential-loaded)
          (push (format "Modulo essencial falhou: %s (%s)"
                        module (plist-get result :message))
                failures))))
    (dolist (module optional)
      (if (emacs-a11y-setup-module-requires-credentials-p module)
          (push (format "Modulo opcional desabilitado por credencial: %s" module) warnings)
        (let ((result (emacs-a11y-setup--simulate-module-load module)))
          (if (eq (plist-get result :status) 'loaded)
              (push result optional-loaded)
            (push (format "Modulo opcional com falha: %s (%s)"
                          module (plist-get result :message))
                  warnings)))))
    (list :ok (null failures)
          :essential-loaded (nreverse essential-loaded)
          :optional-loaded (nreverse optional-loaded)
          :warnings (nreverse warnings)
          :failures (nreverse failures))))

(provide 'emacs-a11y-setup-modules)

;;; emacs-a11y-setup-modules.el ends here
