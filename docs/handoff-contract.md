# Contrato de Handoff - emacs-a11y-setup

## Objetivo
Entregar um contrato versionado entre bootstrap externo e setup interno, sem acoplamento a estrutura privada do workspace.

## Campos obrigatorios

```json
{
  "contract_version": "1.0",
  "platform": "debian-ubuntu",
  "bootstrap_mode": "recommended",
  "workspace_path": "/home/user/.emacs-a11y/workspace"
}
```

## Campos opcionais aceitos

```json
{
  "emacs_path": "...",
  "emacspeak_path": "...",
  "tts_backend": "...",
  "external_diagnostics_status": "...",
  "external_diagnostics_report": "...",
  "next_action": "..."
}
```

## Regras
- Validar `contract_version` no formato `1.x`.
- Validar campos obrigatorios.
- Ausencia de opcionais gera aviso e defaults seguros.
- Erro de validacao deve ser textual, acessivel e acionavel.
- O installer nao deve conhecer detalhes internos do workspace.
- O launcher externo deve garantir que o pacote `emacs-a11y-setup` esteja no
  load path (por exemplo via `EMACSLOADPATH`) ao abrir o `workspace_path` com
  `--init-directory`.
- O layout recomendado para runtime separa pacote e workspace sob uma raiz como
  `~/.emacs-a11y`, mantendo `package/emacs-a11y-setup` e `workspace` como
  diretorios distintos.
