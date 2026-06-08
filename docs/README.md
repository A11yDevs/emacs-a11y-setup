# Documentacao do emacs-a11y-setup

Este diretorio concentra artefatos de engenharia em Markdown e PlantUML para a feature 001.

## Indice

- `use-case-global.puml`: fronteiras entre setup interno, installer externo e distribuicao.
- `use-cases.md`: casos de uso UC01-UC12 com rastreabilidade para FR e testes.
- `handoff-contract.md`: contrato de handoff em linguagem operacional.
- `migration-from-emacs-a11y.md`: (histórico) inventário de módulos legados — migração retirada do escopo desta feature.
- `sequence/first-run-workspace.puml`: fluxo de primeiro uso com workspace isolado.
- `sequence/bootstrap-handoff.puml`: fluxo de bootstrap com handoff.
- `sequence/internal-doctor.puml`: fluxo de diagnostico interno e relatorio.
- `sequence/module-loading.puml`: carregamento resiliente de modulos.
- `sequence/module-migration-inventory.puml`: (histórico) fluxo de inventário de migração — não ativo nesta feature.

## Matriz de compatibilidade de contrato (T083)

| Artefato | Conteudo | Consistencia |
|---|---|---|
| docs/handoff-contract.md | contrato operacional | Alinhado com obrigatorios/opcionais |
| specs/.../contracts/handoff-contract.md | contrato da feature | Alinhado com docs e schema |
| specs/.../contracts/handoff-contract.schema.json | validacao automatica | Alinhado com campos e formato 1.x |

## Compatibilidade futura de publicacao (FR-021)

A feature nao publica pacote em MELPA/ELPA neste momento, mas preserva compatibilidade futura por:

- Estrutura padrao de pacote Emacs Lisp com arquivo principal e `provide`.
- Entradas publicas estaveis e documentadas.
- Testes ERT em batch para validacao automatizada.
- Contrato de handoff versionado para integracao externa sem acoplamento interno.

---

## Feature 002: Community Package Management

**Status**: Implemented | **Spec**: `specs/002-community-package-management/`

The community package engine (`lisp/emacs-a11y-setup-community-packages.el`)
provides workspace-local package management for A11yDevs packages.

### Public commands

All commands return a standardized envelope plist (`:ok`, `:command`,
`:package-id`, `:message`, `:errors`, `:next-action`, etc.) compatible with
`specs/002-community-package-management/contracts/public-commands.schema.json`.

| Command | Type | Description |
|---------|------|-------------|
| `eaacs-list` | Engine | List installed packages |
| `eaacs-install` | Engine | Install package from path |
| `eaacs-activate` | Engine | Activate/require package |
| `eaacs-deactivate` | Engine | Deactivate/unload package |
| `eaacs-remove` | Engine | Remove from registry |
| `eaacs-update` | Engine | Reload package file |
| `eaacs-batch-execute` | Batch | Run any command in batch mode with exit code |

Interactive wrappers (`emacs-a11y-packages-*`) add
`interactive` specs and confirmation prompts for destructive actions.

### Trust policy

- Only `https://github.com/A11yDevs/*` URLs are trusted.
- Untrusted sources are blocked with diagnostic message and `next-action`.
- Validation occurs before any mutation.

### Workspace isolation

- State persisted in `.eaacs-registry.el` inside workspace directory.
- Logs written to `.eaacs-logs/` inside workspace.
- Personal `~/.emacs.d` is never modified.

### Quickstart

See `specs/002-community-package-management/quickstart.md` for complete
batch validation commands and expected output.
