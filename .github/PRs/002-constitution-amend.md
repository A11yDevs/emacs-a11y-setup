Title: MAJOR: Relax Constitution Check requirement to allow approved exceptions

Summary
-------
Esta PR atualiza a constituição do projeto para relaxar a obrigação estrita de que o "Constitution Check" seja sempre marcado como um bloqueio antes de iniciar a implementação. Em vez de um requisito absoluto (MUST), a emenda torna a revisão uma recomendação (SHOULD) e permite exceções documentadas e aprovadas por um mantenedor ativo.

Rationale
---------
- O requisito absoluto tem bloqueado implementações legítimas em casos onde evidências objetivas não são imediatamente disponíveis (ex.: protótipos rápidos, correções urgentes de acessibilidade com risco conhecido).
- Permitir exceções documentadas mantém a governança e a rastreabilidade, reduzindo atritos operacionais.

Changes
-------
- Substitui linguagem MUST por SHOULD em trechos relativos ao "Constitution Check".
- Adiciona exigência de exceção documentada com justificativa técnica e aprovador responsável.
- Atualiza `Version` para `2.0.0` e metadata de `Ratified`/`Last Amended` para `2026-06-07`.

Impact
------
- Governança: alteração MAJOR (redefinição de obrigação normativa) conforme política de Versionamento.
- Processos: continua exigindo documentação e aprovações para exceções; portanto, não reduz a responsabilização de mantenedores.

Migration / How to review
-------------------------
1. Verificar se o texto novo mantém a intenção de registrar evidências quando viável.
2. Confirmar que a exigência de exceção documentada inclui um approver (mantenedor ativo).
3. Validar que nenhum processo automatizado dependa estritamente do texto anterior (scripts que buscam "MUST" literal).

Suggested commit message
------------------------
chore(constitution): relax Constitution Check requirement; add exception flow (MAJOR)

Suggested git commands
----------------------
```bash
# create branch
git checkout -b 002-constitution-amend

# stage changes and commit
git add .specify/memory/constitution.md .github/PRs/002-constitution-amend.md
git commit -m "chore(constitution): relax Constitution Check requirement; add exception flow (MAJOR)"

# push and create PR (example)
git push -u origin 002-constitution-amend

# then open PR on GitHub or use hub/gh CLI
# gh pr create --title "MAJOR: Relax Constitution Check requirement" --body ".github/PRs/002-constitution-amend.md"
```

Notes
-----
Esta alteração é deliberada como MAJOR; a ratificação deve seguir o processo descrito na constituição (PR review, ratificação por mantenedor). A PR inclui um rascunho de justificativa e os comandos sugeridos para criar o branch e abrir a PR.
