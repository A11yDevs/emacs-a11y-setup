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

## Exemplo minimo

```json
{
  "contract_version": "1.0",
  "platform": "debian-ubuntu",
  "bootstrap_mode": "recommended",
  "workspace_path": "/home/user/.emacs-a11y.d"
}
```

## Exemplo completo

```json
{
  "contract_version": "1.0",
  "platform": "windows-native",
  "bootstrap_mode": "recommended",
  "workspace_path": "C:/Users/user/.emacs-a11y.d",
  "emacs_path": "C:/Program Files/Emacs/bin/runemacs.exe",
  "emacspeak_path": "C:/emacspeak",
  "tts_backend": "sapi5",
  "external_diagnostics_status": "warning",
  "external_diagnostics_report": "tts fallback enabled",
  "next_action": "run doctor after first-run"
}
```
