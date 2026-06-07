# Checklist: Package-Requires Validation

Purpose: Validar que cada pacote no monorepo declara `Package-Requires` consistente com seu uso.

- [ ] Definir escopo: lista de pacotes a validar (ex.: todos em `lisp/*`)
- [ ] Verificar presença de cabeçalho `Package-Requires` em cada main-file
- [ ] Comparar versões declaradas com dependências reais detectadas (quando possível)
- [ ] Marcar pacotes não conformes e gerar issue com diagnóstico
- [ ] Registrar evidência (arquivo de saída JSON) em `specs/002-community-package-management/artifacts/`

Notes:
- Esta é uma checklist esqueleto — preencha com comandos e exemplos específicos durante a execução.
