# Package-Requires Validation Checklist

Objetivo: garantir que todos os pacotes em `lisp/` declarem `Package-Requires`
adequadamente e que as dependências listadas sejam realistas para o alvo Emacs.

Passos:

1. Enumerar arquivos `lisp/*.el` e identificar cabeçalhos `Package-Requires`:

```bash
grep -H --line-number "Package-Requires" lisp/*.el || true
```

2. Para cada arquivo com `Package-Requires`, verificar formato e versão:

- Critérios:
  - Sintaxe: `Package-Requires: ((pkg "MAJOR.MINOR"))` ou lista similar válida.
  - Não declarar dependências irreais (ex.: versões maiores que a suportada pelo CI).
  - Preferir dependências mínimas compatíveis (sem pins de patch quando desnecessário).

3. Automatizar verificação via Emacs Lisp (exemplo):

```elisp
(require 'finder-inf)
(dolist (f (directory-files-recursively "lisp" "\\.el$"))
  (with-temp-buffer
    (insert-file-contents f)
    (goto-char (point-min))
    (when (re-search-forward "^;; Package-Requires: *\((.*)\)" nil t)
      (let ((deps (match-string 1)))
        (message "%s => %s" f deps)))))
```

4. Validar que as dependências listadas existem no repositório ou no MELPA/ELPA,
   e documentar exceções (ex.: pacotes locais ou forks privados).

5. Atualizar o checklist `specs/002-community-package-management/checklists/README.md`
   com notas específicas para pacotes que requerem atenção.

Critério de sucesso:

- Todos os arquivos `lisp/*.el` têm `Package-Requires` válidos ou possuem uma
  justificativa documentada em `checklists/package-requires-validation.md`.
# Checklist: Package-Requires validation

Objetivo: Validar automaticamente os cabeçalhos Lisp (`;;;`) e a consistência de `Package-Requires` nos pacotes sob `lisp/`.

Critérios de validação
- Cada pacote em `lisp/<nome-pacote>/` deve conter:
  - Cabeçalho com `Package-Requires` presente.
  - `Package-Requires` listado como uma lista de pares `(DEPENDENT . VERSION)` onde `VERSION` é um número ou string de versão.
  - `;;;###autoload` em pontos públicos quando aplicável.
- `Package-Requires` não deve declarar dependências duplicadas.
- Versões devem usar formato semântico simples (ex.: `0.1`, `1.2.3`) ou ser o número mínimo necessário.
- Dependências listadas em `Package-Requires` devem corresponder a features realmente requeridas pelo código (verificar `require`/`provide` simples).
- Pacotes locais (ex.: `a11y-*` no mesmo repositório) podem usar `:local` na checagem manual (apenas alerta automático).
- Em caso de falha, o checklist deve indicar: arquivo, regra violada e sugestão de correção.

Passos executáveis (manual)
1. Procurar diretórios de pacote em `lisp/` (cada subdiretório com `.el` principal).
2. Para cada pacote:
   - Abrir o arquivo principal e localizar a linha `Package-Requires`.
   - Validar sintaxe e formato das entradas.
   - Verificar se há `require` de features não presentes em `Package-Requires`.
   - Registrar alertas/erros em formato legível (arquivo:linha — problema — sugestão).
3. Resumo final:
   - Número de pacotes verificados.
   - Número de avisos.
   - Número de erros (falhas bloqueantes).

Exemplos de mensagens
- `ERROR: lisp/a11y-foo/a11y-foo.el:12 — missing Package-Requires header`
- `WARN: lisp/a11y-bar/a11y-bar.el:45 — declared dependency 'baz' not found in code; confirm intent`
- `FIX: lisp/a11y-baz/a11y-baz.el — change Package-Requires: ((emacs "29.1"))`

Critério de aceite
- Checklist criado em specs/002-community-package-management/checklists/package-requires-validation.md
- Instruções claras para executar manualmente e interpretar resultados.
- (Opcional) Script automatizado separado para execução em CI.

Notas
- Recomenda-se implementar um script Emacs Lisp separado para automação (p.ex. `scripts/check-package-requires.el`) e integrá-lo a CI posteriormente.
