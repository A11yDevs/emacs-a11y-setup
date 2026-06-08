;;; a11y-core.el --- Core accessibility foundations for A11yDevs environment
;; -*- lexical-binding: t; -*-

;; Author: A11yDevs
;; Version: 0.1
;; Package-Requires: ((emacs "28.1"))
;; Keywords: accessibility, a11y
;; URL: https://github.com/A11yDevs/emacs-a11y-setup/tree/main/lisp/a11y-core

;;; Commentary:
;; Provides core accessibility primitives shared by the A11yDevs package set.
;; This is a base package and is required by the a11y-emacs aggregator.

;;; Code:

(defgroup a11y-core nil
  "Core accessibility foundations."
  :group 'accessibility
  :prefix "a11y-core-")

;;;###autoload
(defun a11y-core-version ()
  "Return the version string for a11y-core."
  (interactive)
  "0.1")

(provide 'a11y-core)
;;; a11y-core.el ends here
