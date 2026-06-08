# Checklist: Validação de `Package-Requires`

Objetivo: validar `Package-Requires` em todos os arquivos de `lisp/` e gerar um artefato JSON com as dependências coletadas para auditoria.

Local de evidência: `specs/002-community-package-management/artifacts/package-requires.json`

Como usar
- Execute os passos em um ambiente de teste (usar `HOME` isolado se desejar).

Passos executáveis

- [ ] Preparar diretório de artefatos

  ```bash
  mkdir -p specs/002-community-package-management/artifacts
  ```

- [ ] Extrair cabeçalhos `Package-Requires` de todos os arquivos `lisp/*.el`

  - Comando shell (requere `rg`/`ripgrep`):

  ```bash
  rg "^;;\s*-\*-.*Package-Requires:|^;;\s*Package-Requires:" -n lisp/ || true
  ```

  - Alternativa Emacs batch: gera JSON com detalhes (arquivo `extract-package-requires.el` temporário):

  ```bash
  cat > /tmp/extract-package-requires.el <<'EL'
(require 'json)

(defun extract-package-requires (dir out)
  (let ((files (directory-files-recursively dir "\\.el$"))
        (acc '()))
    (dolist (f files)
      (with-temp-buffer
        (insert-file-contents f)
        (goto-char (point-min))
        (let ((pr (when (re-search-forward "^\s-*;;\s-*Package-Requires:\s-*\(.*\)$" nil t)
                    (match-string 1))))
          (push (list :file (file-relative-name f)
                      :package-requires (and pr (string-trim pr))) acc))))
    (with-temp-file out
      (insert (json-encode acc)))))

(extract-package-requires "lisp" "specs/002-community-package-management/artifacts/package-requires.json")
EL

  emacs --batch -Q -l /tmp/extract-package-requires.el
  ```

- [ ] Validar consistência de versões e ausência de entradas duplicadas

  - Abra o JSON gerado e verifique pacotes repetidos com versões conflitantes.
  - Pode usar `jq` para inspeção:

  ```bash
  jq '.' specs/002-community-package-management/artifacts/package-requires.json
  ```

- [ ] Gerar relatório resumido (texto) indicando conflitos e sugestões

  - Comando exemplo (bash + jq):

  ```bash
  jq -r '.[] | "File: \(.file) -- Package-Requires: \(.package-requires)"' \
    specs/002-community-package-management/artifacts/package-requires.json > \
    specs/002-community-package-management/artifacts/package-requires-summary.txt
  ```

- [ ] Anexar evidência ao spec

  - Confirme que os arquivos `package-requires.json` e `package-requires-summary.txt` existem em `specs/002-community-package-management/artifacts/` e referencie-os no PR.

Critérios de aceitação

- O artefato `package-requires.json` existe e lista todos os arquivos `.el` analisados.
- Não existem versões conflitantes para o mesmo pacote sem justificativa documentada.
- Checklist deve ser executável em CI usando Emacs batch e ferramentas comuns (`jq`, `rg`).

Notas

- Esta checklist é um esqueleto executável. Scripts auxiliares podem ser movidos para `specs/002-community-package-management/scripts/` e versionados.
# Checklist: Package-Requires Validation

Purpose: Validar que cada pacote no monorepo declara `Package-Requires` consistente com seu uso.

- [ ] Definir escopo: lista de pacotes a validar (ex.: todos em `lisp/*`)
- [ ] Verificar presença de cabeçalho `Package-Requires` em cada main-file
- [ ] Comparar versões declaradas com dependências reais detectadas (quando possível)
- [ ] Marcar pacotes não conformes e gerar issue com diagnóstico
- [ ] Registrar evidência (arquivo de saída JSON) em `specs/002-community-package-management/artifacts/`

Notes:
- Esta é uma checklist esqueleto — preencha com comandos e exemplos específicos durante a execução.
