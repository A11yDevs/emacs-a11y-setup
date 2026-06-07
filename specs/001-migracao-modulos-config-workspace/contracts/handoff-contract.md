# Handoff Contract (v1.x)

## Objetivo
Definir contrato minimo, versionado e de baixo acoplamento entre bootstrap externo e `emacs-a11y-setup`.

## Formato
JSON validado por schema em `handoff-contract.schema.json`.

## Campos obrigatorios
- `contract_version`
- `platform`
- `bootstrap_mode`
- `workspace_path`

## Campos opcionais
- `emacs_path`
- `emacspeak_path`
- `tts_backend`
- `external_diagnostics_status`
- `external_diagnostics_report`
- `next_action`

## Regras de validacao
- Ausencia de qualquer campo obrigatorio: erro bloqueante com mensagem acessivel.
- `contract_version` fora da faixa suportada: erro bloqueante com orientacao de compatibilidade.
- `workspace_path` ausente, invalido ou nao gravavel: erro bloqueante com instrucao de correcao.
- Campos opcionais ausentes: fluxo continua com fallback seguro e aviso no relatorio.
- O launcher externo deve garantir que o pacote `emacs-a11y-setup` esteja no
  load path ao iniciar com `--init-directory` no `workspace_path` (por exemplo,
  via `EMACSLOADPATH` ou mecanismo equivalente da plataforma).

## Exemplo minimo

```json
{
  "contract_version": "1.0",
  "platform": "debian-ubuntu",
  "bootstrap_mode": "recommended",
  "workspace_path": "/home/user/.emacs-a11y/workspace"
}
```

## Exemplo completo

```json
{
  "contract_version": "1.0",
  "platform": "windows-native",
  "bootstrap_mode": "recommended",
  "workspace_path": "C:/Users/user/AppData/Roaming/emacs-a11y/workspace",
  "emacs_path": "C:/Program Files/Emacs/bin/runemacs.exe",
  "emacspeak_path": "C:/emacspeak",
  "tts_backend": "sapi5",
  "external_diagnostics_status": "warning",
  "external_diagnostics_report": "tts fallback enabled",
  "next_action": "run doctor after first-run"
}
```

## Layout recomendado de runtime

```text
~/.emacs-a11y/
  package/emacs-a11y-setup
  workspace
  bin/
```

O bootstrap externo pode escolher outro layout, mas deve preservar a separacao
entre codigo do pacote e estado do workspace.
