# install-aggregator.md — Validação do Pacote Agregador `a11y-emacs`

**Feature**: 002-community-package-management  
**User Story**: US2 — Instalar ambiente agregado ou componentes opcionais  
**Requisito**: FR-003

## Objetivo

Validar que o pacote agregador `a11y-emacs` pode ser instalado via `package-vc-install`,
que todos os módulos base são carregados automaticamente após a instalação,
e que a instalação posterior de um opcional ocorre de forma isolada.

---

## Pré-requisitos

- Emacs 28.1+ com suporte a `package-vc-install`
- Acesso ao repositório `https://github.com/A11yDevs/emacs-a11y-setup`
- Diretório temporário para `package-user-dir` (isolar ambiente de teste)

---

## Cenário 1 — Instalação do agregador e verificação de módulos base

**Given** um ambiente Emacs limpo sem os pacotes A11yDevs instalados  
**When** `package-vc-install` é executado para `a11y-emacs`  
**Then** os quatro pacotes base ficam disponíveis via `featurep`

### Passos

```elisp
;; 1. Preparar ambiente isolado
(setq package-user-dir (make-temp-file "a11y-test-pkgs" t))

;; 2. Instalar o agregador
(package-vc-install
 '(a11y-emacs
   :url "https://github.com/A11yDevs/emacs-a11y-setup.git"
   :branch "main"
   :lisp-dir "lisp/a11y-emacs"
   :main-file "a11y-emacs.el"))

;; 3. Carregar o agregador
(require 'a11y-emacs)

;; 4. Verificar módulos base carregados
(dolist (pkg '(a11y-core a11y-accessibility a11y-navigation a11y-completion))
  (unless (featurep pkg)
    (error "Módulo base não carregado: %s" pkg)))

;; 5. Verificar via função auxiliar
(a11y-emacs-loaded-packages)
;; Resultado esperado: (a11y-core a11y-accessibility a11y-navigation a11y-completion)
```

### Critério de sucesso

- `(featurep 'a11y-emacs)` → `t`
- `(featurep 'a11y-core)` → `t`
- `(featurep 'a11y-accessibility)` → `t`
- `(featurep 'a11y-navigation)` → `t`
- `(featurep 'a11y-completion)` → `t`
- `(a11y-emacs-loaded-packages)` → `(a11y-core a11y-accessibility a11y-navigation a11y-completion)`
- Nenhum erro de carregamento

---

## Cenário 2 — Instalação local para testes (sem acesso remoto)

Para validar em ambiente sem acesso ao GitHub, use o layout local do monorepo:

```bash
# A partir da raiz do repositório
emacs -Q --batch \
  -L lisp/a11y-core \
  -L lisp/a11y-accessibility \
  -L lisp/a11y-navigation \
  -L lisp/a11y-completion \
  -L lisp/a11y-emacs \
  --eval "(require 'a11y-emacs)" \
  --eval "(dolist (p (a11y-emacs-loaded-packages)) (unless (featurep p) (error \"missing: %s\" p)))" \
  --eval "(message \"OK: a11y-emacs e todos os modulos base carregados\")"
```

### Critério de sucesso

- Saída: `OK: a11y-emacs e todos os modulos base carregados`
- Código de saída: `0`

---

## Cenário 3 — Instalação isolada de opcional após o agregador

**Given** que `a11y-emacs` já está instalado  
**When** um pacote opcional (ex.: `a11y-java`) é instalado separadamente  
**Then** a instalação ocorre sem dependências não relacionadas e sem erros

```elisp
;; Instalar opcional de forma isolada (não exige a11y-emacs pré-instalado)
(package-vc-install
 '(a11y-java
   :url "https://github.com/A11yDevs/emacs-a11y-setup.git"
   :branch "main"
   :lisp-dir "lisp/a11y-java"
   :main-file "a11y-java.el"))

(require 'a11y-java)
```

### Critério de sucesso

- `(featurep 'a11y-java)` → `t`
- Nenhuma dependência de pacotes opcionais não relacionados

---

## Cenário 4 — Idempotência (instalação repetida)

```elisp
;; Segunda chamada ao package-vc-install para a11y-emacs
(package-vc-install
 '(a11y-emacs
   :url "https://github.com/A11yDevs/emacs-a11y-setup.git"
   :branch "main"
   :lisp-dir "lisp/a11y-emacs"
   :main-file "a11y-emacs.el"))
```

### Critério de sucesso

- Nenhum erro ou duplicação de metadados
- `(featurep 'a11y-emacs)` → `t`

---

## Links

- Pacote agregador: [lisp/a11y-emacs/a11y-emacs.el](../../../../lisp/a11y-emacs/a11y-emacs.el)
- Pacotes base: [lisp/a11y-core/](../../../../lisp/a11y-core/), [lisp/a11y-accessibility/](../../../../lisp/a11y-accessibility/), [lisp/a11y-navigation/](../../../../lisp/a11y-navigation/), [lisp/a11y-completion/](../../../../lisp/a11y-completion/)
- Quickstart canônico: [quickstart.md](../quickstart.md)
