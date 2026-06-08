;;; a11y-emacs.el --- Aggregator package for the A11yDevs accessible Emacs environment
;; -*- lexical-binding: t; -*-

;; Author: A11yDevs
;; Version: 0.1
;; Package-Requires: ((emacs "28.1")
;;                    (a11y-core "0.1")
;;                    (a11y-accessibility "0.1")
;;                    (a11y-navigation "0.1")
;;                    (a11y-completion "0.1"))
;; Keywords: accessibility, a11y
;; URL: https://github.com/A11yDevs/emacs-a11y-setup/tree/main/lisp/a11y-emacs

;;; Commentary:
;; Aggregator package that installs the main A11yDevs accessible Emacs
;; environment in a single step.  Installing this package pulls in the
;; four base packages:
;;
;;   - a11y-core        — core accessibility primitives
;;   - a11y-accessibility — screen-reader support
;;   - a11y-navigation  — accessible navigation commands
;;   - a11y-completion  — accessible completion configuration
;;
;; Install via package-vc-install:
;;
;;   (package-vc-install
;;    '(a11y-emacs
;;      :url "https://github.com/A11yDevs/emacs-a11y-setup.git"
;;      :branch "main"
;;      :lisp-dir "lisp/a11y-emacs"
;;      :main-file "a11y-emacs.el"))
;;
;; Then load with:
;;
;;   (require 'a11y-emacs)

;;; Code:

(require 'a11y-core)
(require 'a11y-accessibility)
(require 'a11y-navigation)
(require 'a11y-completion)

(defgroup a11y-emacs nil
  "Aggregated accessible Emacs environment from A11yDevs."
  :group 'accessibility
  :prefix "a11y-emacs-")

;;;###autoload
(defun a11y-emacs-version ()
  "Return the version string for a11y-emacs."
  (interactive)
  (message "a11y-emacs 0.1")
  "0.1")

;;;###autoload
(defun a11y-emacs-loaded-packages ()
  "Return a list of base packages confirmed loaded by a11y-emacs."
  (interactive)
  (let ((pkgs '(a11y-core a11y-accessibility a11y-navigation a11y-completion)))
    (if (called-interactively-p 'any)
        (message "a11y-emacs loaded: %s"
                 (mapconcat #'symbol-name pkgs ", "))
      pkgs)))

(provide 'a11y-emacs)
;;; a11y-emacs.el ends here
