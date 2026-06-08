;;; a11y-accessibility.el --- Accessibility features for A11yDevs environment
;; -*- lexical-binding: t; -*-

;; Author: A11yDevs
;; Version: 0.1
;; Package-Requires: ((emacs "28.1") (a11y-core "0.1"))
;; Keywords: accessibility, a11y
;; URL: https://github.com/A11yDevs/emacs-a11y-setup/tree/main/lisp/a11y-accessibility

;;; Commentary:
;; Provides accessibility features and screen-reader support for Emacs,
;; built on top of a11y-core.  Required by the a11y-emacs aggregator.

;;; Code:

(require 'a11y-core)

(defgroup a11y-accessibility nil
  "Accessibility features and screen-reader support."
  :group 'accessibility
  :prefix "a11y-accessibility-")

;;;###autoload
(defun a11y-accessibility-version ()
  "Return the version string for a11y-accessibility."
  (interactive)
  "0.1")

(provide 'a11y-accessibility)
;;; a11y-accessibility.el ends here
