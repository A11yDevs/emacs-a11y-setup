# a11y-hello

Minimal test package for emacs-a11y-setup. Use this copy for verification
or CI-driven tests. When promoted to `lisp/` it becomes a local package in the
monorepo and can be installed via `package-vc-install` examples below.

Installation example:

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
