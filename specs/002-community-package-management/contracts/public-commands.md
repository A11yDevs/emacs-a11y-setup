# Public Contract: Community Lisp Package Distribution via package-vc-install

## Scope

Este contrato define as convencoes tecnicas para organizar e validar pacotes Emacs Lisp instalaveis diretamente do monorepo `A11yDevs/emacs-a11y-setup` via `package-vc-install`.

Nao define implementacao de codigo nesta etapa; define apenas padroes verificaveis para a fase de implementacao.

## Repository and Layout Contract

- Estrategia atual: monorepo `https://github.com/A11yDevs/emacs-a11y-setup`.
- Fonte principal dos pacotes: `lisp/`.
- Cada subdiretorio em `lisp/` representa um pacote instalavel independentemente.
- Cada pacote deve ter arquivo principal `.el` com mesmo nome do pacote.
 - Estrutura legada (ex.: `packages/emacs-a11y-config/usr/share/a11y-emacs/lisp`) pode permanecer como destino de distribuicao para consumidores legados, mas **não** é a fonte primária; `lisp/` é a fonte canônica.

## Package Set Contract

Pacotes base:
- `a11y-core`
- `a11y-accessibility`
- `a11y-navigation`
- `a11y-completion`

Pacote agregador:
- `a11y-emacs` (carrega/depende dos pacotes base)

Pacotes opcionais:
- `a11y-java`
- `a11y-java-lsp`
- `a11y-gptel`
- `a11y-shell`
- `a11y-dired`
- `a11y-layout`
- `a11y-layout-ide`

## Metadata Contract (per package)

Cada arquivo principal de pacote deve conter:
- linha inicial com descricao curta
- `lexical-binding`
- `Author`
- `Version`
- `Package-Requires`
- `Keywords`
- `URL`
- secao `;;; Commentary:`
- secao `;;; Code:`
- `(provide 'nome-do-pacote)`
- linha final `;;; nome-do-pacote.el ends here`

Quando aplicavel:
- comandos publicos marcados com `;;;###autoload`
- opcoes configuraveis com `defgroup` e `defcustom`

## Documentation Contract (per package)

Cada pacote deve ter `README.md` minimo contendo:
- descricao
- dependencias
- exemplo de instalacao via `package-vc-install`
- exemplo de carregamento com `(require 'nome-do-pacote)`
- exemplo basico de configuracao

## Installation Contract Examples

Pacote individual:

```elisp
(package-vc-install
 '(a11y-java
   :url "https://github.com/A11yDevs/emacs-a11y-setup.git"
   :branch "main"
   :lisp-dir "lisp/a11y-java"
   :main-file "a11y-java.el"))
```

Pacote opcional:

```elisp
(package-vc-install
 '(a11y-gptel
   :url "https://github.com/A11yDevs/emacs-a11y-setup.git"
   :branch "main"
   :lisp-dir "lisp/a11y-gptel"
   :main-file "a11y-gptel.el"))
```

Pacote agregador:

```elisp
(package-vc-install
 '(a11y-emacs
   :url "https://github.com/A11yDevs/emacs-a11y-setup.git"
   :branch "main"
   :lisp-dir "lisp/a11y-emacs"
   :main-file "a11y-emacs.el"))
```

Require esperado:

```elisp
(require 'a11y-java)
```

Use-package esperado:

```elisp
(use-package a11y-java
  :vc (:url "https://github.com/A11yDevs/emacs-a11y-setup.git"
       :branch "main"
       :lisp-dir "lisp/a11y-java"
       :main-file "a11y-java.el"))
```

## Guardrails

- Nao converter automaticamente todos os `init-*.el` em pacotes.
- Separar responsabilidades antes de empacotar (biblioteca, comandos, configuracao, integracoes e inicializacao).
- Modulo de configuracao do sistema de pacotes do Emacs nao e pacote comum.
- Pacotes opcionais devem ser instalaveis isoladamente.
- Dependencias circulares invalidam conformidade.

## Validation Checklist

- instalacao de pacote individual via `package-vc-install`
- instalacao de pacote opcional via `package-vc-install`
- instalacao do agregador `a11y-emacs`
- carregamento por `require`
- autoload de comandos publicos (quando aplicavel)
- grupos/opcoes de customizacao (quando aplicavel)
- isolamento de opcionais
- base obrigatoria carregada no agregador
- ausencia de dependencia circular
- `Package-Requires` completo
 - compatibilidade com consumidores documentados (se aplicavel)
 - README minimo funcional por pacote
