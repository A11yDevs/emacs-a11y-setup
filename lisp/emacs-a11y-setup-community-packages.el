;;; emacs-a11y-setup-community-packages.el --- Minimal community package engine
;;
;;; Commentary:
;; Minimal package registry and operations used by specs Phase 1.


(require 'cl-lib)
(require 'subr-x)

(defvar eaacs--registry nil
  "Alist of installed community packages.
Each entry: (NAME . plist), where NAME is a string.")

(defun eaacs--registry-file (&optional workspace)
  "Return registry file path for WORKSPACE (defaults to `default-directory')."
  (expand-file-name ".eaacs-registry.el" (or workspace default-directory)))

(defun eaacs--load-registry (&optional workspace)
  "Load `eaacs--registry' from WORKSPACE registry file if present."
  (let ((f (eaacs--registry-file workspace)))
    (when (file-exists-p f)
      (condition-case _
          (with-temp-buffer
            (insert-file-contents f)
            (setq eaacs--registry (read (current-buffer))))
        (error (setq eaacs--registry nil))))))

(defun eaacs--save-registry (&optional workspace)
  "Save `eaacs--registry' to WORKSPACE registry file."
  (let ((f (eaacs--registry-file workspace)))
    (condition-case _
        (with-temp-file f
          (prin1 eaacs--registry (current-buffer)))
      (error nil))))

(defun eaacs--normalize-ws (workspace-path)
  "Normalize WORKSPACE-PATH to directory string or nil."
  (when (and workspace-path (stringp workspace-path)
             (> (length (string-trim workspace-path)) 0))
    (file-name-as-directory (expand-file-name workspace-path))))

(defmacro eaacs--with-workspace (workspace &rest body)
  "Execute BODY with `default-directory' bound to WORKSPACE, loading and saving registry."
  `(let ((orig default-directory)
         (ws (eaacs--normalize-ws ,workspace)))
     (unwind-protect
         (progn
           (when ws
             (setq default-directory ws))
           (eaacs--load-registry default-directory)
           ,@body)
       (eaacs--save-registry default-directory)
       (setq default-directory orig))))

(defun eaacs--name->feature (name)
  "Convert package NAME (string) to feature symbol."
  (intern (replace-regexp-in-string "-" "-" name)))

(defun eaacs-list-packages ()
  "Return list of installed package names (strings). Mark activated ones as NAME(active)."
  (mapcar (lambda (entry)
            (let* ((name (car entry))
                   (plist (cdr entry)))
              (if (plist-get plist :activated)
                  (format "%s(active)" name)
                name)))
          eaacs--registry))

(defun eaacs--make-envelope (command ok &rest props)
  "Return result envelope for COMMAND with boolean OK and PROPS.
Sanitizes `:message' to a single-line, trimmed string."  
  (let* ((raw-msg (or (plist-get props :message) ""))
         (msg (if (stringp raw-msg)
                  (replace-regexp-in-string "[\n\r]+" " " (string-trim raw-msg))
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

(defun eaacs--format-batch-result (env)
  "Format ENVELOPE for batch/script consumption.
Returns a cons cell (EXIT-CODE . FORMATTED-STRING) where FORMATTED-STRING
is a human-readable line suitable for stdout and EXIT-CODE is 0 (ok) or 1 (fail)."
  (let ((exit-code (eaacs--envelope->exit-code env))
        (cmd (or (plist-get env :command) "?"))
        (msg (or (plist-get env :message) ""))
        (pkg (plist-get env :package-id))
        (errs (plist-get env :errors))
        (warns (plist-get env :warnings))
        (next (plist-get env :next-action))
        (parts '()))
    (push (format "[%s] %s" (if (plist-get env :ok) "OK" "FAIL") cmd) parts)
    (when pkg (push (format "package=%s" pkg) parts))
    (push (format "%s" msg) parts)
    (when errs (push (format "errors=(%s)" (mapconcat #'identity errs "; ")) parts))
    (when warns (push (format "warnings=(%s)" (mapconcat #'identity warns "; ")) parts))
    (when next (push (format "next=%s" next) parts))
    (cons exit-code (mapconcat #'identity (nreverse parts) " | "))))

(defun eaacs--batch-write (env)
  "Write batch-formatted ENVELOPE to `standard-output` and return exit code.
Prints one line: the formatted message.  Returns the exit code (0 or 1)
for use with `kill-emacs' in batch scripts."
  (pcase-let ((`(,code . ,line) (eaacs--format-batch-result env)))
    (princ line)
    (terpri)
    code))

(defun eaacs-batch-execute (command workspace-path &rest args)
  "Execute COMMAND with ARGS under WORKSPACE-PATH, print normalized result, return exit code.
COMMAND is a symbol naming an `eaacs-' function (e.g. 'install, 'remove, 'list).
ARGS are command-specific arguments passed through to the COMMAND function.
WORKSPACE-PATH is the directory for registry isolation, or nil for `default-directory'.

Returns the exit code (0 success, 1 failure) for use with `kill-emacs'."
  (let* ((cmd-fn (intern-soft (format "eaacs-%s" command)))
         (env (if (fboundp cmd-fn)
                  (eaacs--with-workspace workspace-path
                    (apply cmd-fn args))
                (eaacs--make-envelope (format "%s" command) nil
                  :message (format "Unknown command: %s" command)
                  :errors (list (format "unknown-command:%s" command))
                  :next-action "Check available commands: list, install, remove, activate, deactivate, update"))))
    (eaacs--batch-write env)))

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
  "Return non-nil if SOURCE-URL belongs to A11yDevs.
Accepts URLs with or without trailing .git or trailing slash."
  (when (stringp source-url)
    (let ((norm (eaacs--normalize-source-url source-url)))
      (string-prefix-p "https://github.com/A11yDevs/" norm))))

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

;; Runtime & failure classification
(defun eaacs-check-runtime ()
  "Check runtime prerequisites. Returns envelope with diagnostic."
  (if (fboundp 'package-vc-install)
      (eaacs--make-envelope "runtime-check" t :changed nil :message "Runtime OK")
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

;; Logs
(defconst eaacs--log-dir ".eaacs-logs"
  "Subdirectory within workspace for operation logs.")

(defun eaacs--log-path (workspace command name)
  "Return absolute log file path for COMMAND on package NAME under WORKSPACE."
  (let ((dir (expand-file-name eaacs--log-dir (or workspace default-directory))))
    (unless (file-directory-p dir)
      (make-directory dir t))
    (expand-file-name (format "%s-%s-%s.log" command name (format-time-string "%Y%m%dT%H%M%S")) dir)))

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

;; Core operations
(defun eaacs-install-package (name path)
  "Install package NAME from PATH. Returns t on success, nil on failure."
  (let ((full (expand-file-name path default-directory))
        (feat (eaacs--name->feature name)))
    (condition-case err
        (progn
          (load full nil 'nomessage)
          (let* ((old (assoc name eaacs--registry))
                 (old-plist (when old (cdr old)))
                 (entry-plist (plist-put (plist-put (plist-put (or old-plist '())
                                                              :name name)
                                                   :path full)
                                         :feature feat)))
            (setq entry-plist (plist-put entry-plist :installed t))
            ;; preserve previous activation state if present
            (when (plist-get old-plist :activated)
              (setq entry-plist (plist-put entry-plist :activated t)))
            (setq eaacs--registry (assoc-delete-all name eaacs--registry))
            (push (cons name entry-plist) eaacs--registry))
          t)
      (error
       (message "eaacs: install error %s" err)
       nil))))

(defun eaacs-activate-package (name)
  "Activate/require package NAME. Returns t if feature is present."
  (let* ((entry (assoc name eaacs--registry))
         (feat (if entry (plist-get (cdr entry) :feature) (eaacs--name->feature name))))
    (condition-case nil
        (progn
          (require feat)
          ;; mark activated in registry if present, else add record
          (if entry
              (setcdr entry (plist-put (cdr entry) :activated t))
            (push (cons name (list :name name :feature feat :activated t :installed nil)) eaacs--registry))
          t)
      (error nil))))

(defun eaacs-deactivate-package (name)
  "Attempt to unload feature for package NAME. Returns t if unloaded."
  (let ((feat (eaacs--name->feature name)))
    (when (featurep feat)
      (ignore-errors (unload-feature feat t)))
    ;; update registry activation flag
    (let ((entry (assoc name eaacs--registry)))
      (when entry
        (setcdr entry (plist-put (cdr entry) :activated nil))))
    (not (featurep feat))))

(defun eaacs-remove-package (name)
  "Remove package NAME from registry. Returns t if removed."
  (eaacs-deactivate-package name)
  (let ((old eaacs--registry))
    (setq eaacs--registry (assoc-delete-all name eaacs--registry))
    (not (equal old eaacs--registry))))

(defun eaacs-update-package (name &optional path)
  "Update package NAME. Returns t on success."
  (let ((entry (assoc name eaacs--registry)))
    (when entry
      (let* ((old-plist (cdr entry))
             (p (or path (plist-get old-plist :path)))
             (feat (plist-get old-plist :feature))
             (activated (plist-get old-plist :activated)))
        (when p
          (load (expand-file-name p) nil 'nomessage)
          ;; update stored path and preserve activation state
          (setcdr entry (plist-put (plist-put old-plist :path p) :feature (or feat (eaacs--name->feature name))))
          (when activated
            (setcdr entry (plist-put (cdr entry) :activated t)))
          t)))))

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

(defun eaacs-update (name &optional path batch workspace-path source-url ref)
  "Update package NAME and return envelope.
When BATCH is non-nil, skip interactive confirmation."
  (eaacs--with-workspace workspace-path
    (let ((policy (eaacs-validate-source-policy source-url ref)))
      (if (not (plist-get policy :ok))
          (eaacs--make-envelope "update" nil :package-id name :changed nil
            :message (plist-get policy :message)
            :errors (plist-get policy :errors)
            :next-action (plist-get policy :next-action))
        (when (or batch (y-or-n-p (format "Atualizar pacote %s? " name)))
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
            env))))))

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
(defun emacs-a11y-packages-list (&optional _batch workspace-path)
  "Interactive wrapper for `eaacs-list'."
  (interactive (list nil (read-directory-name "Workspace (default .): ")))
  (let* ((ws (eaacs--normalize-ws workspace-path))
         (env (eaacs-list ws)))
    (when (called-interactively-p 'any) (message "%s" (plist-get env :message)))
    env))

(defun emacs-a11y-packages-install (name path &optional batch workspace-path)
  "Interactive wrapper for `eaacs-install'. Prompts NAME and PATH.
When called programmatically, callers may pass non-nil BATCH to skip interactive confirmations."
  (interactive (list (read-string "Package name: ")
                     (read-file-name "Path to .el: ")
                     nil
                     (read-directory-name "Workspace (default .): ")))
  (let* ((ws (eaacs--normalize-ws workspace-path))
         (env (eaacs-install name path batch ws)))
    (when (called-interactively-p 'any) (message "%s" (plist-get env :message)))
    env))

(defun emacs-a11y-packages-remove (name &optional batch workspace-path)
  "Interactive wrapper for `eaacs-remove'.
When called interactively, BATCH is nil so destructive confirmation is performed by the engine."
  (interactive (list (read-string "Package name to remove: ")
                     nil
                     (read-directory-name "Workspace (default .): ")))
  (let* ((ws (eaacs--normalize-ws workspace-path))
         (env (eaacs-remove name batch ws)))
    (when (called-interactively-p 'any) (message "%s" (plist-get env :message)))
    env))

(defun emacs-a11y-packages-activate (name &optional batch workspace-path)
  "Interactive wrapper for `eaacs-activate'."
  (interactive (list (read-string "Package name to activate: ")
                     nil
                     (read-directory-name "Workspace (default .): ")))
  (let* ((ws (eaacs--normalize-ws workspace-path))
         (env (eaacs-activate name batch ws)))
    (when (called-interactively-p 'any) (message "%s" (plist-get env :message)))
    env))

(defun emacs-a11y-packages-deactivate (name &optional batch workspace-path)
  "Interactive wrapper for `eaacs-deactivate'."
  (interactive (list (read-string "Package name to deactivate: ")
                     nil
                     (read-directory-name "Workspace (default .): ")))
  (let* ((ws (eaacs--normalize-ws workspace-path))
         (env (eaacs-deactivate name batch ws)))
    (when (called-interactively-p 'any) (message "%s" (plist-get env :message)))
    env))

(defun emacs-a11y-packages-update (name &optional path batch workspace-path)
  "Interactive wrapper for `eaacs-update'. Prompts optional PATH.
Callers may pass non-nil BATCH to run without interactive confirmations."
  (interactive (list (read-string "Package name to update: ")
                     (read-file-name "Path to .el (or RET to use stored): " nil nil t)
                     nil
                     (read-directory-name "Workspace (default .): ")))
  (let* ((ws (eaacs--normalize-ws workspace-path))
         (env (eaacs-update name (if (string= path "") nil path) batch ws)))
    (when (called-interactively-p 'any) (message "%s" (plist-get env :message)))
    env))

(defun emacs-a11y-packages-dashboard ()
  "Show community packages dashboard with summary of installed packages."
  (interactive)
  (let* ((eaacs--registry (or (condition-case nil
                                  (let ((f (eaacs--registry-file)))
                                    (when (file-exists-p f)
                                      (with-temp-buffer
                                        (insert-file-contents f)
                                        (read (current-buffer)))))
                                (error nil))
                              nil))
         (packages (eaacs-list-packages))
         (buf (get-buffer-create "*a11y-packages*")))
    (with-current-buffer buf
      (erase-buffer)
      (insert "=== A11yDevs Community Packages ===\n\n")
      (if packages
          (progn
            (insert (format "Installed: %d\n\n" (length packages)))
            (dolist (p packages)
              (insert (format "  - %s\n" p))))
        (insert "No packages installed.\n\n"))
      (insert (format "Registry: %s\n" (eaacs--registry-file)))
      (goto-char (point-min))
      (display-buffer buf)))
  nil)

(defun eaacs--list-of-strings-p (v)
  "Return non-nil if V is nil, a string, or a list of strings.
This accepts nil as an empty list, which is important because `nil' and
the empty list are the same value in Emacs Lisp."
  (or (null v)
      (stringp v)
      (and (listp v)
           (cl-every #'stringp v))))

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
    (unless (eaacs--list-of-strings-p (plist-get env :warnings))
      (push "invalid-type:warnings (must be list of strings)" errs))
    ;; errors -> list of strings
    (unless (eaacs--list-of-strings-p (plist-get env :errors))
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

(provide 'emacs-a11y-setup-community-packages)

;;; emacs-a11y-setup-community-packages.el ends here
