;;; a11y-completion.el --- Accessible completion for A11yDevs environment
;; -*- lexical-binding: t; -*-

;; Author: A11yDevs
;; Version: 0.1
;; Package-Requires: ((emacs "28.1") (a11y-core "0.1"))
;; Keywords: accessibility, completion, a11y
;; URL: https://github.com/A11yDevs/emacs-a11y-setup/tree/main/lisp/a11y-completion

;;; Commentary:
;; Provides accessible completion configuration and enhancements for Emacs,
;; built on top of a11y-core.  Required by the a11y-emacs aggregator.

;;; Code:

(require 'a11y-core)

(defgroup a11y-completion nil
  "Accessible completion configuration."
  :group 'accessibility
  :prefix "a11y-completion-")

;;;###autoload
(defun a11y-completion-version ()
  "Return the version string for a11y-completion."
  (interactive)
  "0.1")

(provide 'a11y-completion)
;;; a11y-completion.el ends here
