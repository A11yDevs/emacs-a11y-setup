# Checklists — Gestão de Pacotes Comunitários (002-community-package-management)

Este diretório contém checklists executáveis que ajudam na validação, auditoria
e diagnóstico das operações do subsistema de pacotes comunitários A11yDevs.

Formato
- Cada checklist é um arquivo Markdown com itens do tipo `- [ ]` e `- [x]`.
- Itens devem ser escritos como passos reproduzíveis e idempotentes quando possível.

Arquivos existentes
- `diagnostics-checklist.md` — checagens de diagnóstico e pré-requisitos.
- `workspace-isolation.md` — verificações para garantir isolamento do workspace.
- `package-requires-validation.md` — (esqueleto) validação de `Package-Requires`.
- `init-audit.md` — (esqueleto) auditoria de arquivos `init-*.el`.

Como usar
- Abra o checklist relevante, execute os passos descritos e marque os itens como
  concluídos localmente antes de atualizar o repositório.
- Checklists devem conter comandos, arquivos esperados e critérios de sucesso
  claros (ex.: saída esperada, retorno do teste, caminhos de artefatos).

Nota sobre execução de testes em macOS:

- Alguns ambientes macOS usam caminhos temporários sob `/var/folders/...` que
  podem causar falhas na criação de diretórios temporários durante execuções
  batch. Para contornar, execute a suíte via `bin/run-ert.sh`, que exporta
  `TMPDIR=/tmp` antes de rodar os testes.

```bash
# executar todos os testes com TMPDIR ajustado
bin/run-ert.sh
```

Contribuição
- Para adicionar um novo checklist, crie um arquivo com nome representativo e
  inclua passos numerados ou bullets com `- [ ]` para itens pendentes.

-- fim --
# Checklists for 002-community-package-management

This directory contains executable checklists used by the feature for validation and governance.

- `diagnostics-checklist.md` — Doctor/check items to validate environment before mutating `lisp/`.
- `workspace-isolation.md` — Items to ensure operations are performed in an isolated workspace and do not modify user config.
- `package-requires-validation.md` — Validation checklist for `Package-Requires` metadata (exists in repo).
- `init-audit.md` — Audit checklist for `init-*.el` migration and suspicious patterns (exists in repo).

Add checklists as small markdown files with actionable steps and expected evidence output paths under `specs/002-community-package-management/artifacts/`.
