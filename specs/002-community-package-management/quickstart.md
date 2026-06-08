# Quickstart: Gestão de Pacotes Comunitários A11yDevs

## Goal

Validar o engine de gerenciamento de pacotes comunitários A11yDevs (`eaacs-*`),
incluindo instalação, ativação, desativação, remoção, atualização e listagem
de pacotes, com saída em envelope padronizado, política de confiança A11yDevs
e diagnóstico de falhas.

## Prerequisites

- Emacs 29+ com suporte a `package-vc-install`.
- Este repositório clonado (`A11yDevs/emacs-a11y-setup`).
- Engine implementado em `lisp/emacs-a11y-setup-community-packages.el`.
- Artefato de teste em `specs/002-community-package-management/artifacts/a11y-hello/`.

## Batch Validation Commands

Os comandos abaixo usam `eaacs-batch-execute` em modo batch.
A saída de cada comando é uma linha no formato:

```
[OK|FAIL] <comando> | package=<nome> | <mensagem> | errors=(...) | next=<ação>
```

O código de saída (exit code) é 0 para sucesso, 1 para falha.

### 1. Listar pacotes (vazio inicial)

```sh
emacs -Q --batch \
  -l lisp/emacs-a11y-setup-community-packages.el \
  --eval "(eaacs-batch-execute 'list nil)"
```

**Saída esperada**: `[OK] list | none`

### 2. Instalar pacote individual

```sh
emacs -Q --batch \
  -l lisp/emacs-a11y-setup-community-packages.el \
  --eval '(eaacs-batch-execute 'install nil "a11y-hello" "specs/002-community-package-management/artifacts/a11y-hello/a11y-hello.el" t)'
```

**Saída esperada**: `[OK] install | package=a11y-hello | Installed a11y-hello`

### 3. Ativar pacote

```sh
emacs -Q --batch \
  -l lisp/emacs-a11y-setup-community-packages.el \
  --eval '(eaacs-batch-execute 'activate nil "a11y-hello" t)'
```

**Saída esperada**: `[OK] activate | package=a11y-hello | Activated a11y-hello`

### 4. Listar pacotes (com ativo)

```sh
emacs -Q --batch \
  -l lisp/emacs-a11y-setup-community-packages.el \
  --eval '(eaacs-batch-execute 'list nil)'
```

**Saída esperada**: `[OK] list | a11y-hello(active)`

### 5. Desativar pacote

```sh
emacs -Q --batch \
  -l lisp/emacs-a11y-setup-community-packages.el \
  --eval '(eaacs-batch-execute 'deactivate nil "a11y-hello" t)'
```

**Saída esperada**: `[OK] deactivate | package=a11y-hello | Deactivated a11y-hello`

### 6. Remover pacote

```sh
emacs -Q --batch \
  -l lisp/emacs-a11y-setup-community-packages.el \
  --eval '(eaacs-batch-execute 'remove nil "a11y-hello" t)'
```

**Saída esperada**: `[OK] remove | package=a11y-hello | Removed a11y-hello`

### 7. Instalação idempotente

```sh
emacs -Q --batch \
  -l lisp/emacs-a11y-setup-community-packages.el \
  --eval '(progn
  (eaacs-batch-execute '\''install nil "a11y-hello" "specs/002-community-package-management/artifacts/a11y-hello/a11y-hello.el" t)
  (eaacs-batch-execute '\''install nil "a11y-hello" "specs/002-community-package-management/artifacts/a11y-hello/a11y-hello.el" t)
  (eaacs-batch-execute '\''list nil))'
```

**Saída esperada**: `[OK] list | a11y-hello` (apenas uma entrada, mesmo com duas instalações)

### 8. Bloqueio de origem não confiável

```sh
emacs -Q --batch \
  -l lisp/emacs-a11y-setup-community-packages.el \
  --eval '(eaacs-batch-execute '\''install nil "evil" "/tmp/evil.el" t "https://github.com/evil/malware" "main")'
```

**Saída esperada**: `[FAIL] install | package=evil | Blocked source: not under A11yDevs | errors=(untrusted-source:...) | next=Use a repository under https://github.com/A11yDevs/.`

### 9. Runtime check

```sh
emacs -Q --batch \
  -l lisp/emacs-a11y-setup-community-packages.el \
  --eval "(eaacs-batch-execute 'eaacs-check-runtime nil)"
```

**Saída esperada**: `[OK] runtime-check | Runtime OK`

### 10. Comando desconhecido

```sh
emacs -Q --batch \
  -l lisp/emacs-a11y-setup-community-packages.el \
  --eval "(eaacs-batch-execute 'nonexistent-command nil)"
```

**Saída esperada**: `[FAIL] nonexistent-command | Unknown command: nonexistent-command | errors=(unknown-command:nonexistent-command) | next=Check available commands: list, install, remove, activate, deactivate, update`

## Running the ERT Test Suite

```sh
emacs -Q --batch \
  -l lisp/emacs-a11y-setup-community-packages.el \
  -l test/emacs-a11y-setup-community-packages-tests.el \
  -f ert-run-tests-batch
```

**Resultado esperado**: `Ran 27 tests, 27 results as expected, 0 unexpected`

## Public API (Engine Commands)

Todos os comandos aceitam `workspace-path` como primeiro argumento (ou `nil`
para usar `default-directory`) e retornam um envelope plist padronizado.

| Comando | Assinatura | Descrição |
|---------|-----------|-----------|
| `eaacs-install` | `(name path &optional batch workspace source-url ref)` | Instala pacote |
| `eaacs-activate` | `(name &optional batch workspace)` | Ativa/require pacote |
| `eaacs-deactivate` | `(name &optional batch workspace)` | Desativa/unload pacote |
| `eaacs-remove` | `(name &optional batch workspace)` | Remove do registry |
| `eaacs-update` | `(name &optional path batch workspace source-url ref)` | Recarrega pacote |
| `eaacs-list` | `(&optional workspace)` | Lista pacotes instalados |
| `eaacs-batch-execute` | `(command workspace-path &rest args)` | Executa em batch, retorna exit code |

## Envelope Contract

Cada comando retorna um envelope plist compatível com
`public-commands.schema.json` contendo:

- `:ok` — booleano
- `:command` — string
- `:package-id` — string ou nil
- `:state-before` / `:state-after` — string ou nil
- `:changed` — booleano
- `:message` — string (linha única)
- `:warnings` / `:errors` — listas de strings
- `:next-action` — string ou nil
- `:log-path` — string ou nil

## Logs

Operações gravam logs em `<workspace>/.eaacs-logs/<comando>-<pacote>-<timestamp>.log`.
Para workspace explícito, use:

```sh
emacs -Q --batch \
  -l lisp/emacs-a11y-setup-community-packages.el \
  --eval '(eaacs-batch-execute '\''install "/tmp/eaacs-ws" "a11y-hello" "specs/002-community-package-management/artifacts/a11y-hello/a11y-hello.el" t)'
```

Logs estarão em `/tmp/eaacs-ws/.eaacs-logs/`.

## Trust Policy

- Apenas URLs sob `https://github.com/A11yDevs/` são confiáveis.
- Origens fora da política são bloqueadas com diagnostico e next-action.
- A validação ocorre antes de qualquer mutação no registry ou disco.

## Interactive Wrappers

Para uso interativo no Emacs, os comandos abaixo solicitam confirmação
(`y-or-n-p`) em ações destrutivas (remove, deactivate, update):

- `M-x emacs-a11y-packages-list`
- `M-x emacs-a11y-packages-install`
- `M-x emacs-a11y-packages-activate`
- `M-x emacs-a11y-packages-deactivate`
- `M-x emacs-a11y-packages-remove`
- `M-x emacs-a11y-packages-update`
- `M-x emacs-a11y-packages-dashboard`

Para chamada programática em batch, passe `batch=t` para pular confirmações.