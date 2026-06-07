# a11y-hello (artifact)

Minimal test package for emacs-a11y-setup stored as an artifact for offline/manual
verification or CI-driven tests. Use this copy for verification or tests that do not modify `lisp/` in the repository root.

Installation example (use repository URL when promoting to `lisp/`):

```elisp
(package-vc-install
 '(a11y-hello
   :url "https://github.com/A11yDevs/emacs-a11y-setup.git"
   :branch "main"
   :lisp-dir "lisp/a11y-hello"
   :main-file "a11y-hello.el"))
```

Load test:

```elisp
(require 'a11y-hello)
(a11y-hello-say)
```
