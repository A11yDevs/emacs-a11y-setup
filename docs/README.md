# Documentacao do emacs-a11y-setup

Este diretorio concentra artefatos de engenharia em Markdown e PlantUML para a feature 001.

## Indice

- `use-case-global.puml`: fronteiras entre setup interno, installer externo e distribuicao.
- `use-cases.md`: casos de uso UC01-UC12 com rastreabilidade para FR e testes.
- `handoff-contract.md`: contrato de handoff em linguagem operacional.
- `migration-from-emacs-a11y.md`: inventario dos 13 modulos legados.
- `sequence/first-run-workspace.puml`: fluxo de primeiro uso com workspace isolado.
- `sequence/bootstrap-handoff.puml`: fluxo de bootstrap com handoff.
- `sequence/internal-doctor.puml`: fluxo de diagnostico interno e relatorio.
- `sequence/module-loading.puml`: carregamento resiliente de modulos.
- `sequence/module-migration-inventory.puml`: fluxo de inventario de migracao.

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
