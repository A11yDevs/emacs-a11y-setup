;;; a11y-navigation.el --- Accessible navigation for A11yDevs environment
;; -*- lexical-binding: t; -*-

;; Author: A11yDevs
;; Version: 0.1
;; Package-Requires: ((emacs "28.1") (a11y-core "0.1"))
;; Keywords: accessibility, navigation, a11y
;; URL: https://github.com/A11yDevs/emacs-a11y-setup/tree/main/lisp/a11y-navigation

;;; Commentary:
;; Provides accessible navigation commands and landmarks for Emacs,
;; built on top of a11y-core.  Required by the a11y-emacs aggregator.

;;; Code:

(require 'a11y-core)

(defgroup a11y-navigation nil
  "Accessible navigation commands."
  :group 'accessibility
  :prefix "a11y-navigation-")

;;;###autoload
(defun a11y-navigation-version ()
  "Return the version string for a11y-navigation."
  (interactive)
  "0.1")

(provide 'a11y-navigation)
;;; a11y-navigation.el ends here
