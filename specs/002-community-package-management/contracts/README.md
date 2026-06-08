# Contracts README — Public Commands & Schema

Este diretório contém contratos (specs) que definem a interface pública
de comandos batch/CLI usados pelo subsistema de pacotes comunitários.

Arquivos principais
- `public-commands.md` — documentação humana da superfície de comandos públicos.
- `public-commands.schema.json` — schema JSON que descreve o envelope esperado
  (campos, tipos e valores permitidos) para chamadas em modo batch.

Objetivo
- Fornecer um formato estável para invocação automatizada (scripts, CI)
  e facilitar validação programática das mensagens/retornos entre consumidores.

Como validar:

1. Revisar `public-commands.md` para entender campos e fluxos esperados.
2. Usar um validador JSON Schema (ex.: `ajv`, `jsonschema`, `jq` + ferramenta)
   para validar envelopes contra `public-commands.schema.json`.

Exemplo (node + ajv):

```bash
npm install -g ajv-cli
ajv validate -s specs/002-community-package-management/contracts/public-commands.schema.json -d payload.json
```

Observações
- Mantenha o schema compatível retroativamente quando possível — adições
  não devem invalidar consumidores existentes. Use `oneOf`/`anyOf` com cuidado.
# Contracts for 002-community-package-management

This directory contains public contract definitions for the feature, such as `public-commands.md` and `public-commands.schema.json`.

- `public-commands.md` — human-readable contract for command envelopes and return codes.
- `public-commands.schema.json` — machine-readable schema for command envelopes (exists in repo).

Contracts must be stable and documented before exposing new commands to distribution or installer components.
