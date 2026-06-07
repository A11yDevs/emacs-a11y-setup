# Package-Requires Validation Checklist

Objetivo: validar que cada pacote no escopo desta feature declara corretamente `Package-Requires` e metadados essenciais.

- [ ] Cada pacote tem `Package-Requires` declarado com versão mínima apropriada.
- [ ] Cada arquivo principal contém `lexical-binding` no header.
- [ ] `provide` está presente no final do arquivo principal.
- [ ] `Author`, `Version`, `Keywords` e `URL` preenchidos no header.
- [ ] `README.md` mínimo presente ao lado do pacote com instruções de instalação e uso.
- [ ] Ferramenta automática (CI) para varredura de metadados executada e verde.

Como executar (manual):

```sh
# varrer subdiretórios em lisp/ e checar cabeçalhos
grep -R "Package-Requires" lisp/ || echo "Package-Requires missing"
```
# Checklist: Package-Requires Validation

Purpose: Validar que cada pacote no monorepo declara `Package-Requires` consistente com seu uso.

- [ ] Definir escopo: lista de pacotes a validar (ex.: todos em `lisp/*`)
- [ ] Verificar presença de cabeçalho `Package-Requires` em cada main-file
- [ ] Comparar versões declaradas com dependências reais detectadas (quando possível)
- [ ] Marcar pacotes não conformes e gerar issue com diagnóstico
- [ ] Registrar evidência (arquivo de saída JSON) em `specs/002-community-package-management/artifacts/`

Notes:
- Esta é uma checklist esqueleto — preencha com comandos e exemplos específicos durante a execução.
