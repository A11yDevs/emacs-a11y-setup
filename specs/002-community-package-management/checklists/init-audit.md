# Init Audit Checklist

Objetivo: auditar `init-*.el` e evitar migração automática sem separação de responsabilidades.

- [ ] Listar todos os `init-*.el` existentes e mapear responsabilidades de cada trecho de código.
- [ ] Identificar funções/variáveis que pertencem claramente a pacotes reutilizáveis vs configuração do usuário.
- [ ] Marcar trechos que exigem extração antes de transformá-los em pacote.
- [ ] Criar passos de extração incremental e testes para cada extração proposta.
- [ ] Validar ausência de dependências circulares após extração simulada.

Como executar (manual):

```sh
ls -1 **/init-*.el || true
```
# Checklist: init-*.el Audit

Purpose: Auditar `init-*.el` e evitar migração automática indevida para pacotes.

- [ ] Listar todos os arquivos `init-*.el` no repositório e identificar responsabilidades
- [ ] Classificar conteúdo: configuração de usuário vs biblioteca reutilizável vs bootstrap
- [ ] Marcar trechos que podem virar pacote e criar issue de refatoração (não transformar automaticamente)
- [ ] Validar que nenhum `init-*.el` será renomeado/movido sem revisão arquitetural e aprovação constitucional
- [ ] Gerar relatório de auditoria em `specs/002-community-package-management/artifacts/`

Notes:
- Esta é uma checklist esqueleto para ser completada com passos executáveis.
