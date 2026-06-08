# Init Audit Checklist

Objetivo: auditar arquivos `init-*.el` no repositório e prevenir migração automática
de configurações pessoais para o workspace. Esse checklist ajuda a identificar
scripts que alteram `~/.emacs.d` ou que presumem um ambiente interativo.

Passos executáveis:

1. Listar arquivos `init-*.el` no repositório:

```bash
ls -1 **/init-*.el || true
```

2. Para cada `init-*.el`, verificar padrões problemáticos (exemplos):

- Uso direto de `user-emacs-directory` para escrita sem checagem de sandbox.
- Execução de comandos interativos (`read-buffer`, `switch-to-buffer` etc.) sem
  proteção para modos batch.
- Chamadas que alteram configurações globais sem opção de rollback.

3. Executar uma checagem rápida via `grep` para padrões comuns:

```bash
grep -Hn "user-emacs-directory\|switch-to-buffer\|read-buffer\|package-initialize" -n lisp || true
```

4. Validar que arquivos `init-*.el` só definem funções/variáveis e não executam
   mutações automaticamente; se necessário, envolver execuções em guardas:

```elisp
(when (and (not noninteractive) (bound-and-true-p after-init-time))
  ;; ação interativa segura
  )
```

5. Documentar exceções ou necessidades de migração em `specs/002-community-package-management/checklists/init-audit.md`.

Critério de sucesso:

- Todos os `init-*.el` auditados e/ou modificados para evitar mutações automáticas
  em ambientes batch; exceções documentadas no checklist.
# Init-audit checklist

Purpose: auditar arquivos `init-*.el` para identificar riscos de migração automática e detectar padrões que possam impedir extração segura de pacotes.

Evidence path: `specs/002-community-package-management/artifacts/init-audit/`

Steps:

- [ ] Locate all `init-*.el` files across the repository and list them to `specs/002-community-package-management/artifacts/init-audit/init-files.txt`.
- [ ] For each `init-*.el`, scan for patterns indicating user-specific configuration writes (e.g., writes to `custom-file`, `user-emacs-directory`, modifications of `load-path` with absolute home paths). Record occurrences in `init-audit-findings.txt`.
- [ ] Detect use of `setq`/`setf` on global variables without namespacing that could cause side-effects when extracted into a package; list these in `init-unscoped-vars.txt`.
- [ ] Identify functions or forms that perform file system mutations outside a workspace path (e.g., `write-region` to home paths); record examples in `init-disk-writes.txt`.
- [ ] Classify each init file as: `SAFE_FOR_EXTRACTION`, `REQUIRES_REFACTOR`, or `NOT_SAFE` and record classification in `init-audit-summary.md` with remediation suggestions.
- [ ] If automated fixes are possible (small nsps renames, add `defvar` guards), create patch proposals and link to issues in `ISSUES.md`.

Notes:

- This audit is informational and MUST be reviewed by maintainers before any automated migration is attempted.
- Do not perform bulk changes without explicit PR and code review.
# Checklist: init-*.el Audit

Purpose: Auditar `init-*.el` e evitar migração automática indevida para pacotes.

- [ ] Listar todos os arquivos `init-*.el` no repositório e identificar responsabilidades
- [ ] Classificar conteúdo: configuração de usuário vs biblioteca reutilizável vs bootstrap
- [ ] Marcar trechos que podem virar pacote e criar issue de refatoração (não transformar automaticamente)
- [ ] Validar que nenhum `init-*.el` será renomeado/movido sem revisão arquitetural e aprovação constitucional
- [ ] Gerar relatório de auditoria em `specs/002-community-package-management/artifacts/`

Notes:
- Esta é uma checklist esqueleto para ser completada com passos executáveis.
