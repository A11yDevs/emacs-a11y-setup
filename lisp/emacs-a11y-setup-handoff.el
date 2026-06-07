;;; emacs-a11y-setup-handoff.el --- Handoff contract processing -*- lexical-binding: t; -*-

;;; Code:

(require 'cl-lib)
(require 'json)
(require 'subr-x)

(defconst emacs-a11y-setup-handoff-supported-major 1
  "Versao major suportada para contract_version.")

(defconst emacs-a11y-setup-handoff-required-fields
  '(contract_version platform bootstrap_mode workspace_path)
  "Campos obrigatorios do contrato de handoff.")

(defconst emacs-a11y-setup-handoff-optional-fields
  '(emacs_path emacspeak_path tts_backend external_diagnostics_status
               external_diagnostics_report next_action)
  "Campos opcionais aceitos no handoff.")

(defvar emacs-a11y-setup-last-handoff-result nil
  "Ultimo resultado de processamento do handoff.")

(defun emacs-a11y-setup--alist-or-plist-to-alist (data)
  "Converte DATA para alist com chaves simbolicas."
  (cond
   ((hash-table-p data)
    (let (result)
      (maphash (lambda (k v)
                 (push (cons (if (symbolp k) k (intern (format "%s" k))) v) result))
               data)
      result))
   ((and (listp data) (keywordp (car data)))
    (let (result)
      (while data
        (let ((k (pop data))
              (v (pop data)))
          (push (cons (intern (substring (symbol-name k) 1)) v) result)))
      result))
   ((listp data)
    (mapcar (lambda (kv)
              (cons (if (symbolp (car kv)) (car kv)
                      (intern (format "%s" (car kv))))
                    (cdr kv)))
            data))
   (t
    nil)))

(defun emacs-a11y-setup-handoff-parse (input)
  "Parseia INPUT em alist simbolica.
INPUT pode ser JSON string, caminho de arquivo JSON, alist, plist ou hash-table."
  (cond
   ((hash-table-p input)
    (emacs-a11y-setup--alist-or-plist-to-alist input))
   ((and (stringp input) (file-exists-p input))
    (with-temp-buffer
      (insert-file-contents input)
      (json-parse-string (buffer-string) :object-type 'alist :array-type 'list)))
   ((stringp input)
    (json-parse-string input :object-type 'alist :array-type 'list))
   ((listp input)
    (emacs-a11y-setup--alist-or-plist-to-alist input))
   (t
    (error "Formato de handoff nao suportado"))))

(defun emacs-a11y-setup-handoff--lookup (contract key)
  "Busca KEY em CONTRACT considerando simbolo e string."
  (or (alist-get key contract)
      (alist-get (symbol-name key) contract nil nil #'string=)))

(defun emacs-a11y-setup-handoff--validate-version (version)
  "Valida VERSION e retorna nil quando valida, ou mensagem de erro."
  (cond
   ((not (stringp version))
    "Campo contract_version deve ser string")
   ((not (string-match-p "^1\\.[0-9]+$" version))
    "Campo contract_version deve seguir formato 1.x")
   (t nil)))

(defun emacs-a11y-setup-handoff--workspace-valid-p (workspace-path)
  "Retorna nao-nil quando WORKSPACE-PATH for valido e gravavel/criavel."
  (and (stringp workspace-path)
       (not (string-empty-p workspace-path))
       (let* ((expanded (expand-file-name workspace-path))
              (parent (file-name-directory (directory-file-name expanded))))
         (and parent
              (or (file-directory-p expanded)
                  (file-directory-p parent))
              (or (file-writable-p expanded)
                  (file-writable-p parent))))))

(defun emacs-a11y-setup-handoff-normalize (contract)
  "Normaliza CONTRACT para plist com defaults seguros."
  (let* ((version (emacs-a11y-setup-handoff--lookup contract 'contract_version))
         (platform (emacs-a11y-setup-handoff--lookup contract 'platform))
         (bootstrap-mode (emacs-a11y-setup-handoff--lookup contract 'bootstrap_mode))
         (workspace-path (emacs-a11y-setup-handoff--lookup contract 'workspace_path))
         (warnings nil)
         (result (list
                  :contract_version version
                  :platform (or platform "unknown")
                  :bootstrap_mode (or bootstrap-mode "unknown")
                  :workspace_path workspace-path
                  :emacs_path (emacs-a11y-setup-handoff--lookup contract 'emacs_path)
                  :emacspeak_path (emacs-a11y-setup-handoff--lookup contract 'emacspeak_path)
                  :tts_backend (or (emacs-a11y-setup-handoff--lookup contract 'tts_backend)
                                   "unknown")
                  :external_diagnostics_status (or (emacs-a11y-setup-handoff--lookup contract 'external_diagnostics_status)
                                                   "unknown")
                  :external_diagnostics_report (or (emacs-a11y-setup-handoff--lookup contract 'external_diagnostics_report)
                                                   "")
                  :next_action (or (emacs-a11y-setup-handoff--lookup contract 'next_action)
                                   "Executar emacs-a11y-setup-doctor"))))
    (dolist (field emacs-a11y-setup-handoff-optional-fields)
      (unless (emacs-a11y-setup-handoff--lookup contract field)
        (push (format "Campo opcional ausente: %s" field) warnings)))
    (plist-put result :warnings (nreverse warnings))
    result))

(defun emacs-a11y-setup-handoff-validate (normalized)
  "Valida contrato NORMALIZED (plist) e retorna lista de erros."
  (let ((errors nil))
    (dolist (field emacs-a11y-setup-handoff-required-fields)
      (when (or (null (plist-get normalized (intern (format ":%s" field))))
                (and (stringp (plist-get normalized (intern (format ":%s" field))))
                     (string-empty-p (plist-get normalized (intern (format ":%s" field))))))
        (push (format "Campo obrigatorio ausente: %s" field) errors)))
    (let ((version-error (emacs-a11y-setup-handoff--validate-version
                          (plist-get normalized :contract_version))))
      (when version-error
        (push version-error errors)))
    (unless (emacs-a11y-setup-handoff--workspace-valid-p
             (plist-get normalized :workspace_path))
      (push "workspace_path ausente, invalido ou nao gravavel" errors))
    (nreverse errors)))

(defun emacs-a11y-setup-process-handoff (input)
  "Processa INPUT e retorna plist com status, avisos e erros."
  (condition-case err
      (let* ((contract (emacs-a11y-setup-handoff-parse input))
             (normalized (emacs-a11y-setup-handoff-normalize contract))
             (errors (emacs-a11y-setup-handoff-validate normalized))
             (result (list :ok (null errors)
                           :contract normalized
                           :warnings (plist-get normalized :warnings)
                           :errors errors)))
        (setq emacs-a11y-setup-last-handoff-result result)
        result)
    (error
     (let ((result (list :ok nil
                         :contract nil
                         :warnings nil
                         :errors (list (format "Erro ao processar handoff: %s" (error-message-string err))))))
       (setq emacs-a11y-setup-last-handoff-result result)
       result))))

(provide 'emacs-a11y-setup-handoff)

;;; emacs-a11y-setup-handoff.el ends here
