# Placeholder de Testes — specs/002-community-package-management

Este arquivo serve como base para descrever cenários de teste ERT que
validam o comportamento do subsistema de pacotes comunitários A11yDevs.

Formato sugerido:

- Nome do cenário
  - Passos reproduzíveis (comandos shell ou expressões Emacs Lisp)
  - Artefatos esperados (arquivos, símbolos carregáveis)
  - Critério de sucesso (ex.: `ert` passa, `require` não falha)

Exemplo rápido:

1. Preparar ambiente limpo (usar `emacs -Q` ou temp dir para `package-user-dir`).
2. Executar `package-vc-install` apontando para `specs/.../artifacts/a11y-hello`.
3. Verificar `(require 'a11y-hello)` não lança erro.

Comandos úteis para execução local:

```bash
# executar todos os testes ERT localmente
emacs -Q --batch -l ert -L . -L lisp -l test/emacs-a11y-setup-community-packages-tests.el -f ert-run-tests-batch

# Recomendado: usar o wrapper que garante `TMPDIR=/tmp` (evita falhas no macOS):
bin/run-ert.sh
```

Colabore expandindo este arquivo com cenários específicos por User Story
(US1, US2, US3) e linkando aos testes ERT em `test/`.
# Tests placeholder for 002-community-package-management

This file is a placeholder for ERT and manual test plans.

- `test/emacs-a11y-setup-community-packages-tests.el` — ERT tests for list/install/update/remove flows.
- `specs/002-community-package-management/tests/install-aggregator.md` — manual steps for validating `a11y-emacs` aggregator.

Add concrete test steps and example commands here.
