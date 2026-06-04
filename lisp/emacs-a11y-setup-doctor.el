;;; emacs-a11y-setup-doctor.el --- Internal doctor and reporting -*- lexical-binding: t; -*-

;;; Code:

(require 'cl-lib)
(require 'subr-x)
(require 'seq)
(require 'emacs-a11y-setup-workspace)
(require 'emacs-a11y-setup-profiles)
(require 'emacs-a11y-setup-modules)
(require 'emacs-a11y-setup-handoff)

(defvar emacs-a11y-setup-last-doctor-result nil
  "Ultimo resultado do doctor.")

(defconst emacs-a11y-setup-known-tts-backends
  '("espeak" "speech-dispatcher" "sapi5" "festival" "unknown")
  "Backends de TTS reconhecidos.")

(defun emacs-a11y-setup--sanitize-line (line)
  "Sanitiza LINE removendo segredos obvios."
  (let ((sanitized line))
    (setq sanitized
          (replace-regexp-in-string
           "\\(token\\|secret\\|api[_-]?key\\|password\\)\\s-*[:=]\\s-*[^[:space:]]+"
           "\\1=<redacted>"
           sanitized t t))
    sanitized))

(defun emacs-a11y-setup--sanitize-lines (lines)
  "Aplica sanitizacao em LINES."
  (mapcar #'emacs-a11y-setup--sanitize-line lines))

(defun emacs-a11y-setup--detect-emacspeak ()
  "Retorna plist com status de deteccao do Emacspeak."
  (let ((binary (executable-find "emacspeak"))
        (library (locate-library "emacspeak")))
    (if (or binary library)
        (list :status "ok"
              :message "Emacspeak localizado"
              :path (or binary library))
      (list :status "warning"
            :message "Emacspeak nao localizado; recurso de fala pode estar limitado"
            :path nil))))

(defun emacs-a11y-setup--tts-status-from-handoff ()
  "Extrai status de TTS do ultimo handoff."
  (let* ((handoff emacs-a11y-setup-last-handoff-result)
         (contract (and handoff (plist-get handoff :contract)))
         (backend (or (and contract (plist-get contract :tts_backend)) "unknown")))
    (if (member backend emacs-a11y-setup-known-tts-backends)
        (list :status "ok" :message (format "Backend TTS reconhecido: %s" backend))
      (list :status "warning" :message (format "Backend TTS ausente ou desconhecido: %s" backend)))))

(defun emacs-a11y-setup--build-next-steps (failures warnings)
  "Gera lista de proximos passos a partir de FAILURES e WARNINGS."
  (let (steps)
    (when failures
      (push "Corrigir falhas criticas no workspace e nos modulos essenciais." steps))
    (when warnings
      (push "Revisar avisos de modulos opcionais e dependencias de fala." steps))
    (unless (or failures warnings)
      (push "Ambiente saudavel. Prossiga para uso normal do setup." steps))
    (nreverse steps)))

(defun emacs-a11y-setup--render-report (data)
  "Renderiza DATA de diagnostico em texto acessivel."
  (let* ((timestamp (plist-get data :timestamp))
         (workspace (plist-get data :workspace))
         (profile (plist-get data :profile))
         (setup-version (or (plist-get data :setup-version) "0.1.0"))
         (handoff-summary (or (plist-get data :handoff-summary) "nao informado"))
         (essentials (plist-get data :essential-modules))
         (optional (plist-get data :optional-modules))
         (failures (plist-get data :failures))
         (warnings (plist-get data :warnings))
         (next-steps (plist-get data :next-steps))
         (log-path (plist-get data :log-path))
         (report-path (plist-get data :report-path))
         (lines (append
                 (list "Relatorio de diagnostico interno - emacs-a11y-setup"
                       (format "timestamp: %s" timestamp)
                       (format "versao: %s" setup-version)
                       (format "workspace: %s" workspace)
                       (format "perfil ativo: %s" profile)
                       (format "handoff: %s" handoff-summary)
                       ""
                       "Modulos essenciais carregados:")
                 (if essentials
                     (mapcar (lambda (entry)
                               (format "- %s" (plist-get entry :module)))
                             essentials)
                   (list "- nenhum"))
                 (list ""
                       "Modulos opcionais carregados:")
                 (if optional
                     (mapcar (lambda (entry)
                               (format "- %s" (plist-get entry :module)))
                             optional)
                   (list "- nenhum"))
                 (list ""
                       "Falhas:")
                 (if failures (mapcar (lambda (x) (format "- %s" x)) failures)
                   (list "- nenhuma"))
                 (list ""
                       "Avisos:")
                 (if warnings (mapcar (lambda (x) (format "- %s" x)) warnings)
                   (list "- nenhum"))
                 (list ""
                       "Proximos passos:")
                 (mapcar (lambda (x) (format "- %s" x)) next-steps)
                 (list ""
                       (format "log: %s" log-path)
                       (format "relatorio: %s" report-path)))))
    (mapconcat #'identity (emacs-a11y-setup--sanitize-lines lines) "\n")))

(defun emacs-a11y-setup-run-doctor (&optional explicit-path profile)
  "Executa diagnostico interno no workspace EXPLICIT-PATH com PROFILE."
  (let* ((workspace (emacs-a11y-setup-resolve-workspace-path explicit-path))
         (status (emacs-a11y-setup-workspace-status workspace))
         (profile-id (or profile (emacs-a11y-setup-get-default-profile)))
         (profile-data (emacs-a11y-setup-apply-profile profile-id))
         (module-status (emacs-a11y-setup-load-modules
                         (plist-get profile-data :essential)
                         (plist-get profile-data :optional)))
         (failures (copy-sequence (plist-get module-status :failures)))
         (warnings (copy-sequence (plist-get module-status :warnings)))
         (emacspeak (emacs-a11y-setup--detect-emacspeak))
         (tts (emacs-a11y-setup--tts-status-from-handoff))
         (logs-dir (expand-file-name "logs" workspace))
         (reports-dir (expand-file-name "reports" workspace))
         (timestamp (format-time-string "%Y-%m-%dT%H:%M:%S%z"))
         (stamp-file (format-time-string "%Y%m%d-%H%M%S"))
         (log-path (expand-file-name (format "doctor-%s.log" stamp-file) logs-dir))
         (report-path (expand-file-name (format "doctor-%s.txt" stamp-file) reports-dir))
         report-text)
    (unless (plist-get status :exists)
      (push "Workspace nao existe" failures))
    (unless (plist-get status :writable)
      (push "Workspace nao e gravavel" failures))
    (unless (null (plist-get status :missing-files))
      (push (format "Arquivos obrigatorios ausentes: %S" (plist-get status :missing-files)) failures))
    (unless (null (plist-get status :missing-dirs))
      (push (format "Diretorios obrigatorios ausentes: %S" (plist-get status :missing-dirs)) failures))
    (unless (emacs-a11y-setup-profile-exists-p profile-id)
      (push (format "Perfil padrao inexistente: %s" profile-id) failures))
    (when (string= (plist-get emacspeak :status) "warning")
      (push (plist-get emacspeak :message) warnings))
    (when (string= (plist-get tts :status) "warning")
      (push (plist-get tts :message) warnings))
    (unless (file-directory-p logs-dir)
      (make-directory logs-dir t))
    (unless (file-directory-p reports-dir)
      (make-directory reports-dir t))
    (let* ((next-steps (emacs-a11y-setup--build-next-steps failures warnings))
           (data (list :timestamp timestamp
                       :setup-version "0.1.0"
                       :workspace workspace
                       :profile profile-id
                       :handoff-summary (if emacs-a11y-setup-last-handoff-result
                                            (if (plist-get emacs-a11y-setup-last-handoff-result :ok)
                                                "ok"
                                              "erro")
                                          "nao informado")
                       :essential-modules (plist-get module-status :essential-loaded)
                       :optional-modules (plist-get module-status :optional-loaded)
                       :failures (nreverse failures)
                       :warnings (nreverse warnings)
                       :next-steps next-steps
                       :log-path log-path
                       :report-path report-path)))
      (setq report-text (emacs-a11y-setup--render-report data))
      (with-temp-file report-path
        (insert report-text)
        (insert "\n"))
      (with-temp-file log-path
        (insert report-text)
        (insert "\n"))
      (setq emacs-a11y-setup-last-doctor-result
            (append data (list :report-text report-text :ok (null failures))))))
  emacs-a11y-setup-last-doctor-result)

(defun emacs-a11y-setup-dashboard-text ()
  "Retorna texto para dashboard acessivel."
  (if (and emacs-a11y-setup-last-doctor-result
           (plist-get emacs-a11y-setup-last-doctor-result :report-text))
      (plist-get emacs-a11y-setup-last-doctor-result :report-text)
    "Nenhum relatorio disponivel. Execute emacs-a11y-setup-doctor primeiro."))

(provide 'emacs-a11y-setup-doctor)

;;; emacs-a11y-setup-doctor.el ends here
