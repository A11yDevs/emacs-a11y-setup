;;; a11y-hello.el --- Minimal test package for emacs-a11y setup
;; -*- lexical-binding: t; -*-

;; Author: A11yDevs
;; Version: 0.1
;; Package-Requires: ((emacs "28.1"))
;; Keywords: accessibility, test
;; URL: https://github.com/A11yDevs/emacs-a11y-setup/tree/main/lisp/a11y-hello

;;; Commentary:
;; Minimal package to serve as a hello-world target for package-vc-install
;; and automated/manual installation tests. Stored as an artifact for
;; verification and CI-driven tests.

;;; Code:

(defgroup a11y-hello nil
  "Hello-world test package for emacs-a11y setup."
  :group 'convenience)

(defcustom a11y-hello-message "Olá, a11y-hello está carregado!"
  "Message emitted by `a11y-hello-say'."
  :type 'string
  :group 'a11y-hello)

;;;###autoload
(defun a11y-hello-say ()
  "Display `a11y-hello-message` in echo area and return it." 
  (interactive)
  (message "%s" a11y-hello-message)
  a11y-hello-message)

(provide 'a11y-hello)
;;; a11y-hello.el ends here
