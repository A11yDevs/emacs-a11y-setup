# Public Command Contract

## Entradas publicas previstas

- `emacs-a11y-setup-first-run`
- `emacs-a11y-setup-bootstrap`
- `emacs-a11y-setup-create-workspace`
- `emacs-a11y-setup-doctor`
- `emacs-a11y-setup-doctor-batch`
- `emacs-a11y-setup-open-dashboard`

## Garantias contratuais

- As entradas MUST permanecer estaveis durante a serie de versao da feature.
- Quebras de assinatura MUST atualizar documentacao, testes e notas de migracao.
- O componente externo MUST NOT depender de detalhes internos de estrutura do workspace.
- Saidas de erro MUST ser textuais e acessiveis.
- `doctor-batch` SHOULD expor codigo de saida apropriado para automacao.
