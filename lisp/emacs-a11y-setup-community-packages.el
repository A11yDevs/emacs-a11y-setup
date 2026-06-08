;;; emacs-a11y-setup-community-packages.el --- Minimal community package engine
;;
;;; Commentary:
;; Minimal package registry and operations used by specs Phase 1.

(defvar eaacs--registry nil
  "Alist of installed community packages.
Each entry: (NAME . plist), where NAME is a string.")

(defun eaacs--name->feature (name)
  "Convert package NAME (string) to feature symbol.
Simple conversion: "
  (intern (replace-regexp-in-string "-" "-" name)))

(defun eaacs-list-packages ()
  "Return list of installed package names (strings)."
  (mapcar #'car eaacs--registry))

(defun eaacs-install-package (name path)
  "Install package NAME from PATH (relative or absolute).
Loads the file and registers package in registry.
Returns t on success, nil on failure."
  (let ((full (expand-file-name path default-directory))
        (feat (eaacs--name->feature name)))
    (condition-case err
        (progn
          (load full nil 'nomessage)
            (let ((entry (list :name name :path full :feature feat :installed t)))
            (setq eaacs--registry (assoc-delete-all name eaacs--registry))
            (push (cons name entry) eaacs--registry))
          t)
      (error
       (message "eaacs: install error %s" err)
       nil)))

(defun eaacs-activate-package (name)
  "Activate/require package NAME. Returns t if feature is present."
  (let* ((entry (assoc name eaacs--registry))
         (feat (if entry (plist-get (cdr entry) :feature) (eaacs--name->feature name))))
    (condition-case nil
        (progn
          (require feat)
          t)
      (error nil))))

(defun eaacs-deactivate-package (name)
  "Attempt to unload feature for package NAME. Returns t if unloaded."
  (let* ((feat (eaacs--name->feature name)))
    (when (featurep feat)
      (ignore-errors (unload-feature feat t)))
    (not (featurep feat))))

(defun eaacs-remove-package (name)
  "Remove package NAME from registry and attempt to unload its feature.
Returns t if removed." 
  (eaacs-deactivate-package name)
  (let ((old eaacs--registry))
  (setq eaacs--registry (assoc-delete-all name eaacs--registry))
    (not (equal old eaacs--registry))))

(defun eaacs-update-package (name &optional path)
  "Update package NAME. If PATH provided, load PATH otherwise reload known path.
Returns t on success." 
  (let ((entry (assoc name eaacs--registry)))
    (when entry
      (let ((p (or path (plist-get (cdr entry) :path))))
        (when p
          (load (expand-file-name p) nil 'nomessage)
          t)))))
(defun eaacs--make-envelope (command ok &rest props)
  "Return result envelope for COMMAND with boolean OK and PROPS.
Sanitizes `:message` to a single-line, trimmed string to keep outputs short
and screen-reader friendly."
  (let* ((raw-msg (or (plist-get props :message) ""))
         (msg (if (stringp raw-msg)
                  (replace-regexp-in-string
                   "[\n\r]+" " " (string-trim raw-msg))
                (format "%s" raw-msg)))
         (warnings (or (plist-get props :warnings) '()))
         (errors (or (plist-get props :errors) '()))
         (changed (plist-get props :changed)))
    (list :ok (if ok t nil)
          :command command
          :package-id (plist-get props :package-id)
          :state-before (plist-get props :state-before)
          :state-after (plist-get props :state-after)
          :changed (if (or (eq changed t) (eq changed nil)) changed (if changed t nil))
          :message (or msg "")
          :warnings warnings
          :errors errors
          :next-action (plist-get props :next-action)
          :log-path (plist-get props :log-path))))

(defun eaacs--envelope->exit-code (env)
  "Map ENVELOPE to batch exit code. 0=ok, 1=fail."
  (if (plist-get env :ok) 0 1))

;; T019: source normalization and trust policy
(defconst eaacs--default-source-url "https://github.com/A11yDevs/emacs-a11y-setup"
  "Default source URL when none is provided.")

(defconst eaacs--default-ref "main"
  "Default git ref when none is provided.")

(defun eaacs--normalize-source-url (source-url)
  "Normalize SOURCE-URL: strip trailing .git and /."
  (let* ((raw (or source-url eaacs--default-source-url))
         (trimmed (replace-regexp-in-string "/\\'" "" raw)))
    (replace-regexp-in-string "\\.git\\'" "" trimmed)))

(defun eaacs--normalize-ref (ref)
  "Normalize REF, defaulting to `eaacs--default-ref'."
  (if (and ref (> (length ref) 0)) ref eaacs--default-ref))

(defun eaacs--source-trusted-p (source-url)
  "Return non-nil if SOURCE-URL belongs to A11yDevs."
  (and (stringp source-url)
       (string-match-p
        "\\`https://github\\.com/A11yDevs/[-[:alnum:]_.]+\\'"
        source-url)))

(defun eaacs-validate-source-policy (source-url ref)
  "Validate SOURCE-URL and REF under A11yDevs trust policy."
  (let ((norm-url (eaacs--normalize-source-url source-url))
        (norm-ref (eaacs--normalize-ref ref)))
    (if (eaacs--source-trusted-p norm-url)
        (eaacs--make-envelope "source-policy" t :changed nil
          :message (format "Source trusted: %s @ %s" norm-url norm-ref))
      (eaacs--make-envelope "source-policy" nil :changed nil
        :message "Blocked source: not under A11yDevs"
        :errors (list (format "untrusted-source:%s" norm-url))
        :next-action "Use a repository under https://github.com/A11yDevs/."))))

;; T020: failure classification and runtime check
(defun eaacs-check-runtime ()
  "Check runtime prerequisites. Returns envelope with diagnostic."
  (if (fboundp 'package-vc-install)
      (eaacs--make-envelope "runtime-check" t :changed nil
        :message "Runtime OK")
    (eaacs--make-envelope "runtime-check" nil :changed nil
      :message "Missing prerequisite: package-vc-install"
      :errors '("runtime:package-vc-install-missing")
      :next-action "Upgrade Emacs to 29+ or load package-vc before using community commands.")))

(defun eaacs-classify-failure (command err-text)
  "Classify ERR-TEXT for COMMAND and return diagnostic envelope."
  (let* ((txt (downcase (format "%s" err-text)))
         (kind (cond
                ((string-match-p "network\\|timed out\\|timeout\\|dns\\|unreachable" txt) "network")
                ((string-match-p "repository\\|not found\\|404\\|git\\|remote" txt) "repository")
                ((string-match-p "conflict\\|already exists\\|state" txt) "state-conflict")
                (t "unknown"))))
    (eaacs--make-envelope command nil :changed nil
      :message (format "Operation failed (%s)." kind)
      :errors (list (format "%s:%s" command kind) (format "detail:%s" err-text))
      :next-action
      (cond
       ((string= kind "network") "Check internet connectivity and retry.")
       ((string= kind "repository") "Confirm repository URL/ref and access permissions.")
       ((string= kind "state-conflict") "Reconcile package state before retrying.")
       (t "Inspect logs and retry with verbose diagnostics.")))))

;; T021: log-path support
(defconst eaacs--log-dir ".eaacs-logs"
  "Subdirectory within workspace for operation logs.")

(defun eaacs--log-path (workspace command name)
  "Return absolute log file path for COMMAND on package NAME under WORKSPACE."
  (let ((dir (expand-file-name eaacs--log-dir (or workspace default-directory))))
    (unless (file-directory-p dir)
      (make-directory dir t))
    (expand-file-name
     (format "%s-%s-%s.log"
             command name
             (format-time-string "%Y%m%dT%H%M%S"))
     dir)))

(defun eaacs--write-log (path env)
  "Write envelope ENV summary to log file at PATH."
  (when path
    (condition-case nil
        (with-temp-file path
          (insert (format "command: %s\n" (plist-get env :command)))
          (insert (format "ok: %s\n" (plist-get env :ok)))
          (insert (format "package-id: %s\n" (plist-get env :package-id)))
          (insert (format "message: %s\n" (plist-get env :message)))
          (insert (format "errors: %s\n" (plist-get env :errors)))
          (insert (format "next-action: %s\n" (plist-get env :next-action))))
      (error nil))))

;; Public wrappers (with log-path support)
(defun eaacs-install (name path &optional batch workspace-path source-url ref)
  "Install package NAME from PATH and return envelope."
  (eaacs--with-workspace workspace-path
    (let ((policy (eaacs-validate-source-policy source-url ref)))
      (if (not (plist-get policy :ok))
          (eaacs--make-envelope "install" nil :package-id name :changed nil
            :message (plist-get policy :message)
            :errors (plist-get policy :errors)
            :next-action (plist-get policy :next-action))
        (let* ((before (eaacs-list-packages))
               (ok (eaacs-install-package name path))
               (lp (eaacs--log-path workspace-path "install" name))
               (env (eaacs--make-envelope "install" ok
                      :package-id name
                      :state-before (when before (mapconcat #'identity before ","))
                      :state-after (when ok (mapconcat #'identity (eaacs-list-packages) ","))
                      :changed ok
                      :log-path lp
                      :message (if ok (format "Installed %s" name)
                                 (format "Install failed: %s" name)))))
          (eaacs--write-log lp env)
          (unless batch (message "%s" (plist-get env :message)))
          env)))))

(defun eaacs-remove (name &optional batch workspace-path)
  "Remove package NAME and return envelope."
  (eaacs--with-workspace workspace-path
    (let ((before (eaacs-list-packages)))
      (when (or batch (y-or-n-p (format "Remover pacote %s? " name)))
        (let* ((ok (eaacs-remove-package name))
               (lp (eaacs--log-path workspace-path "remove" name))
               (env (eaacs--make-envelope "remove" ok
                      :package-id name
                      :state-before (when before (mapconcat #'identity before ","))
                      :state-after (when ok (mapconcat #'identity (eaacs-list-packages) ","))
                      :changed ok
                      :log-path lp
                      :message (if ok (format "Removed %s" name)
                                 (format "Remove failed: %s" name)))))
          (eaacs--write-log lp env)
          (unless batch (message "%s" (plist-get env :message)))
          env)))))

(defun eaacs-activate (name &optional batch workspace-path)
  "Activate package NAME and return envelope."
  (eaacs--with-workspace workspace-path
    (let* ((before (eaacs-list-packages))
           (ok (eaacs-activate-package name))
           (lp (eaacs--log-path workspace-path "activate" name))
           (env (eaacs--make-envelope "activate" ok
                  :package-id name
                  :state-before (when before (mapconcat #'identity before ","))
                  :state-after (when ok (mapconcat #'identity (eaacs-list-packages) ","))
                  :changed ok
                  :log-path lp
                  :message (if ok (format "Activated %s" name)
                             (format "Activate failed: %s" name)))))
      (eaacs--write-log lp env)
      (unless batch (message "%s" (plist-get env :message)))
      env)))

(defun eaacs-deactivate (name &optional batch workspace-path)
  "Deactivate package NAME and return envelope."
  (eaacs--with-workspace workspace-path
    (when (or batch (y-or-n-p (format "Desativar pacote %s? " name)))
      (let* ((before (eaacs-list-packages))
             (ok (eaacs-deactivate-package name))
             (lp (eaacs--log-path workspace-path "deactivate" name))
             (env (eaacs--make-envelope "deactivate" ok
                    :package-id name
                    :state-before (when before (mapconcat #'identity before ","))
                    :state-after (when ok (mapconcat #'identity (eaacs-list-packages) ","))
                    :changed ok
                    :log-path lp
                    :message (if ok (format "Deactivated %s" name)
                               (format "Deactivate failed: %s" name)))))
        (eaacs--write-log lp env)
        (unless batch (message "%s" (plist-get env :message)))
        env))))

(defun eaacs-update (name &optional path batch workspace-path source-url ref)
  "Update package NAME and return envelope."
  (eaacs--with-workspace workspace-path
    (let ((policy (eaacs-validate-source-policy source-url ref)))
      (if (not (plist-get policy :ok))
          (eaacs--make-envelope "update" nil :package-id name :changed nil
            :message (plist-get policy :message)
            :errors (plist-get policy :errors)
            :next-action (plist-get policy :next-action))
        (let* ((before (eaacs-list-packages))
               (ok (eaacs-update-package name path))
               (lp (eaacs--log-path workspace-path "update" name))
               (env (eaacs--make-envelope "update" ok
                      :package-id name
                      :state-before (when before (mapconcat #'identity before ","))
                      :state-after (when ok (mapconcat #'identity (eaacs-list-packages) ","))
                      :changed ok
                      :log-path lp
                      :message (if ok (format "Updated %s" name)
                                 (format "Update failed: %s" name)))))
          (eaacs--write-log lp env)
          (unless batch (message "%s" (plist-get env :message)))
          env)))))

(defun eaacs-list (&optional workspace-path)
  "Return envelope with known packages."
  (eaacs--with-workspace workspace-path
    (let* ((list (eaacs-list-packages))
           (s (mapconcat #'identity list ",")))
      (eaacs--make-envelope "list" t
        :state-after (when list s)
        :changed nil
        :message (if (> (length s) 0) s "none")))))

;; Public interactive wrappers (T012)
(defun emacs-a11y-setup-community-packages-list (&optional _batch workspace-path)
  "Interactive wrapper for `eaacs-list'."
  (interactive (list nil (read-directory-name "Workspace (default .): ")))
  (when (and _batch (stringp _batch))
    (setq workspace-path _batch
          _batch nil))
  (let* ((ws (eaacs--normalize-ws workspace-path))
         (env (eaacs-list ws)))
    (when (called-interactively-p 'any) (message "%s" (plist-get env :message)))
    env))

(defun emacs-a11y-setup-community-packages-install (name path &optional batch workspace-path)
  "Interactive wrapper for `eaacs-install'. Prompts NAME and PATH.
When called programmatically, callers may pass non-nil BATCH to skip interactive confirmations."
  (interactive (list (read-string "Package name: ")
                     (read-file-name "Path to .el: ")
                     nil
                     (read-directory-name "Workspace (default .): ")))
  (when (and batch (stringp batch))
  (setq workspace-path batch
        batch nil))
  (let* ((ws (eaacs--normalize-ws workspace-path))
         (env (eaacs-install name path batch ws)))
    (when (called-interactively-p 'any) (message "%s" (plist-get env :message)))
    env))

(defun emacs-a11y-setup-community-packages-remove (name &optional batch workspace-path)
  "Interactive wrapper for `eaacs-remove'.
When called interactively, BATCH is nil so destructive confirmation is performed by the engine."
  (interactive (list (read-string "Package name to remove: ")
                     nil
                     (read-directory-name "Workspace (default .): ")))
  (when (and batch (stringp batch))
  (setq workspace-path batch
        batch nil))
  (let* ((ws (eaacs--normalize-ws workspace-path))
         (env (eaacs-remove name batch ws)))
    (when (called-interactively-p 'any) (message "%s" (plist-get env :message)))
    env))

(defun emacs-a11y-setup-community-packages-activate (name &optional batch workspace-path)
  "Interactive wrapper for `eaacs-activate'."
  (interactive (list (read-string "Package name to activate: ")
                     nil
                     (read-directory-name "Workspace (default .): ")))
  (when (and batch (stringp batch))
  (setq workspace-path batch
        batch nil))
  (let* ((ws (eaacs--normalize-ws workspace-path))
         (env (eaacs-activate name batch ws)))
    (when (called-interactively-p 'any) (message "%s" (plist-get env :message)))
    env))

(defun emacs-a11y-setup-community-packages-deactivate (name &optional batch workspace-path)
  "Interactive wrapper for `eaacs-deactivate'."
  (interactive (list (read-string "Package name to deactivate: ")
                     nil
                     (read-directory-name "Workspace (default .): ")))
  (when (and batch (stringp batch))
  (setq workspace-path batch
        batch nil))
  (let* ((ws (eaacs--normalize-ws workspace-path))
         (env (eaacs-deactivate name batch ws)))
    (when (called-interactively-p 'any) (message "%s" (plist-get env :message)))
    env))

(defun emacs-a11y-setup-community-packages-update (name &optional path batch workspace-path)
  "Interactive wrapper for `eaacs-update'. Prompts optional PATH.
Callers may pass non-nil BATCH to run without interactive confirmations."
  (interactive (list (read-string "Package name to update: ")
                     (read-file-name "Path to .el (or RET to use stored): " nil nil t)
                     nil
                     (read-directory-name "Workspace (default .): ")))
  (when (and batch (stringp batch))
  (setq workspace-path batch
        batch nil))
  (let* ((ws (eaacs--normalize-ws workspace-path))
         (env (eaacs-update name (if (string= path "") nil path) batch ws)))
    (when (called-interactively-p 'any) (message "%s" (plist-get env :message)))
    env))

(require 'cl-lib)

(defun eaacs--ensure-list-of-strings (v)
  "Return a list of strings for V, or nil when V is invalid.
Accepts nil (-> '()), a string (-> list with that string), or a list of strings."
  (cond
   ((null v) '())
   ((stringp v) (list v))
   ((and (listp v) (cl-every #'stringp v)) v)
   (t nil)))

(defun eaacs-validate-envelope (env)
  "Validate ENV plist against the expected public-commands schema shape.
Return t when valid, otherwise return an error envelope (plist) describing problems."
  (let ((errs '()))
    ;; ok must be boolean (t or nil accepted as false)
    (unless (or (eq (plist-get env :ok) t) (eq (plist-get env :ok) nil))
      (push "invalid-type:ok (must be t or nil)" errs))
    ;; command must be string
    (unless (stringp (plist-get env :command))
      (push "invalid-type:command (must be string)" errs))
    ;; message must be string
    (unless (stringp (plist-get env :message))
      (push "invalid-type:message (must be string)" errs))
    ;; warnings -> list of strings
    (unless (eaacs--ensure-list-of-strings (plist-get env :warnings))
      (push "invalid-type:warnings (must be list of strings)" errs))
    ;; errors -> list of strings
    (unless (eaacs--ensure-list-of-strings (plist-get env :errors))
      (push "invalid-type:errors (must be list of strings)" errs))
    ;; changed must be boolean (t or nil)
    (unless (or (eq (plist-get env :changed) t) (eq (plist-get env :changed) nil))
      (push "invalid-type:changed (must be t or nil)" errs))
    (if errs
        (eaacs--make-envelope "validate-envelope" nil
          :changed nil
          :errors (nreverse errs)
          :message (format "Envelope validation failed (%d issues)." (length errs)))
      t)))
>>>>>>> Stashed changes

(provide 'emacs-a11y-setup-community-packages)
;;; emacs-a11y-setup-community-packages.el ends here

(defun eaacs--envelope->exit-code (env)
  "Map ENV envelope to an integer exit code for batch consumers.
0 = success (:ok true), 1 = error (:errors present), 2 = warning-only (:warnings present)."
  (cond
   ((plist-get env :ok) 0)
   ((plist-get env :errors) 1)
   ((plist-get env :warnings) 2)
   (t 1)))

(defun eaacs--normalize-batch-result (env &optional workspace)
  "Normalize ENV envelope for batch consumers.
Adds/normalizes keys :exit-code, :message (string) and :log-path when possible.
If WORKSPACE is provided, prefer its log directory."
  (let* ((env (or env (list)))
         (msg (or (plist-get env :message) ""))
         (log (or (plist-get env :log-path)
                  (when workspace (eaacs--log-path workspace))
                  (eaacs--log-path (or workspace default-directory))))
         (exit (eaacs--envelope->exit-code env))
         (msg-str (cond
                   ((stringp msg) msg)
                   ((null msg) "")
                   (t (format "%s" msg)))))
    (plist-put env :message msg-str)
    (plist-put env :log-path log)
    (plist-put env :exit-code exit)))
