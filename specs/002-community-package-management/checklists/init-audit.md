# Checklist: init-*.el Audit

Purpose: Auditar `init-*.el` e evitar migração automática indevida para pacotes.

- [ ] Listar todos os arquivos `init-*.el` no repositório e identificar responsabilidades
- [ ] Classificar conteúdo: configuração de usuário vs biblioteca reutilizável vs bootstrap
- [ ] Marcar trechos que podem virar pacote e criar issue de refatoração (não transformar automaticamente)
- [ ] Validar que nenhum `init-*.el` será renomeado/movido sem revisão arquitetural e aprovação constitucional
- [ ] Gerar relatório de auditoria em `specs/002-community-package-management/artifacts/`

Notes:
- Esta é uma checklist esqueleto para ser completada com passos executáveis.
