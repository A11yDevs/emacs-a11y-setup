# a11y-completion

Pacote de configuração de complementação acessível para o ambiente A11yDevs.

## Instalação

```elisp
(package-vc-install
 '(a11y-completion
   :url "https://github.com/A11yDevs/emacs-a11y-setup.git"
   :branch "main"
   :lisp-dir "lisp/a11y-completion"
   :main-file "a11y-completion.el"))
```

## Uso

```elisp
(require 'a11y-completion)
```

## Dependências

- Emacs 28.1+
- `a11y-core` 0.1+
