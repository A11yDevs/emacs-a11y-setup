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
)

(provide 'emacs-a11y-setup-community-packages)
;;; emacs-a11y-setup-community-packages.el ends here
