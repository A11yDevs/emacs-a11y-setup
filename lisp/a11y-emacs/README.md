# a11y-emacs

Pacote agregador que instala o ambiente Emacs acessível principal da comunidade A11yDevs em uma única etapa.

## O que este pacote inclui

Ao instalar `a11y-emacs`, os seguintes pacotes base são carregados automaticamente:

| Pacote              | Função                                  |
|---------------------|-----------------------------------------|
| `a11y-core`         | Primitivas de acessibilidade (base)     |
| `a11y-accessibility`| Suporte a leitor de tela                |
| `a11y-navigation`   | Comandos de navegação acessível         |
| `a11y-completion`   | Configuração de complementação acessível|

## Instalação via `package-vc-install`

```elisp
(package-vc-install
 '(a11y-emacs
   :url "https://github.com/A11yDevs/emacs-a11y-setup.git"
   :branch "main"
   :lisp-dir "lisp/a11y-emacs"
   :main-file "a11y-emacs.el"))
```

## Carregamento

```elisp
(require 'a11y-emacs)
```

## Verificação de módulos carregados

```elisp
(a11y-emacs-loaded-packages)
;; => (a11y-core a11y-accessibility a11y-navigation a11y-completion)
```

## Instalação de opcionais

Após instalar o agregador, cada pacote opcional pode ser instalado independentemente:

```elisp
(package-vc-install
 '(a11y-java
   :url "https://github.com/A11yDevs/emacs-a11y-setup.git"
   :branch "main"
   :lisp-dir "lisp/a11y-java"
   :main-file "a11y-java.el"))
```

## Dependências

- Emacs 28.1+
- `a11y-core` 0.1+
- `a11y-accessibility` 0.1+
- `a11y-navigation` 0.1+
- `a11y-completion` 0.1+
