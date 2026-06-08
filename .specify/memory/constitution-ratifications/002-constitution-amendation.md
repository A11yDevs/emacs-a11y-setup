# Ratification Record: Constitution Amendment 002

- Amendment: Relax Constitution Check requirement (MUST -> SHOULD) and allow documented exceptions.
- Branch/PR: 002-constitution-amend (https://github.com/A11yDevs/emacs-a11y-setup/pull/8)
- Ratified Date: 2026-06-07
- Ratified By: A11yDevs maintainers (PR review)

## Rationale
Mudança MAJOR para reduzir bloqueios operacionais em fluxos de prototipagem e correção urgente, mantendo obrigatoriedade de documentação e aprovação para exceções.

## Impact
- Governaça: altera uma exigência normativa para permitir exceções aprovadas.
- Processos: continua exigindo justificativa técnica por exceção; fluxos automatizados devem ser atualizados se dependerem de texto literal "MUST".

## Follow-up
- Atualizar templates e scripts que façam parsing literal do texto da constituição.
- Garantir que `specs/*/tasks.md` incluam `T028` ou link para exceção documentada quando aplicável.
