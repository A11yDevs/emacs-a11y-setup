;;; emacs-a11y-setup-profiles-tests.el --- ERT profile tests -*- lexical-binding: t; -*-

(require 'ert)
(require 'emacs-a11y-setup)

(ert-deftest emacs-a11y-setup-profile-default-conservative ()
  (let ((profile (emacs-a11y-setup-apply-profile 'iniciante)))
    (should (eq (plist-get profile :profile) 'iniciante))
    (should (member 'init-core (plist-get profile :essential)))
    (should (member 'init-accessibility (plist-get profile :essential)))))

(ert-deftest emacs-a11y-setup-profile-credential-modules-disabled ()
  (let ((profile (emacs-a11y-setup-apply-profile 'iniciante)))
    (should (member 'init-gptel (plist-get profile :disabled-credentials)))
    (should-not (member 'init-gptel (plist-get profile :optional)))))

(provide 'emacs-a11y-setup-profiles-tests)
