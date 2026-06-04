# Data Model: 001-migracao-modulos-config-workspace

## Entidade: Workspace
- Descrição: representa o ambiente isolado gerenciado pelo `emacs-a11y-setup`.
- Campos principais:
  - `path` (string, obrigatório)
  - `init_file` (string, obrigatório)
  - `early_init_file` (string, obrigatório nesta feature)
  - `custom_file` (string, obrigatório)
  - `directories` (lista obrigatória: `config`, `profiles`, `logs`, `reports`, `backups`)
  - `created_at` (timestamp)
  - `last_checked_at` (timestamp)
- Regras de validação:
  - `path` deve ser gravável.
  - não pode apontar para `~/.emacs.d` ou `~/.config/emacs`.
  - arquivos mínimos devem existir após `create-workspace`.
- Transições de estado:
  - `absent` -> `created`
  - `created` -> `validated`
  - `validated` -> `repaired` (quando doctor aplica correções seguras)

## Entidade: HandoffContract
- Descrição: representa o contrato de entrada entre bootstrap externo e setup.
- Campos obrigatórios:
  - `contract_version` (string)
  - `platform` (enum: `windows-native`, `debian-ubuntu`, `macos`, `android-termux`, `wsl`, `unknown`)
  - `bootstrap_mode` (enum: `minimal`, `recommended`, `full`, `unknown`)
  - `workspace_path` (string)
- Campos opcionais:
  - `emacs_path` (string)
  - `emacspeak_path` (string)
  - `tts_backend` (string)
  - `external_diagnostics_status` (enum: `ok`, `warning`, `error`, `unknown`)
  - `external_diagnostics_report` (string)
  - `next_action` (string)
- Regras de validação:
  - versão incompatível bloqueia bootstrap com erro acessível.
  - ausência de campo obrigatório bloqueia bootstrap com erro acessível.
  - ausência de campo opcional gera aviso e fallback seguro.

## Entidade: Profile
- Descrição: representa conjunto de módulos habilitados para um cenário de uso.
- Campos:
  - `id` (string, obrigatório)
  - `description` (string)
  - `essential_modules` (lista)
  - `optional_modules` (lista)
  - `requires_credentials` (bool)
- Regras:
  - perfil padrão `iniciante-conservador` MUST existir.
  - módulos com credenciais MUST NOT estar ativos por padrão.

## Entidade: ModuleRegistryItem
- Descrição: descreve módulo disponível no setup.
- Campos:
  - `name` (string)
  - `domain` (string)
  - `required` (bool)
  - `load_status` (enum: `loaded`, `failed`, `skipped`)
  - `failure_message` (string opcional)
- Regras:
  - falha em módulo obrigatório impacta status geral do doctor.
  - falha em módulo opcional gera aviso sem bloquear doctor.

## Entidade: MigrationInventoryItem
- Descrição: item de inventário de módulo legado do repositório `emacs-a11y`.
- Campos:
  - `legacy_module` (string)
  - `legacy_origin_path` (string)
  - `functional_domain` (string)
  - `decision` (enum: `migrar`, `adaptar`, `adiar`, `descartar`)
  - `justification` (string)
  - `external_dependencies` (lista)
  - `risks` (lista)
  - `status` (enum: `pendente`, `em-progresso`, `concluido`)
  - `new_module` (string opcional)

## Entidade: DoctorReport
- Descrição: relatório textual acessível produzido por `doctor`.
- Campos:
  - `timestamp` (timestamp)
  - `setup_version` (string)
  - `workspace_path` (string)
  - `active_profile` (string)
  - `handoff_summary` (objeto opcional)
  - `essential_modules` (lista com status)
  - `optional_modules` (lista com status)
  - `failures` (lista)
  - `warnings` (lista)
  - `next_steps` (lista)
  - `report_path` (string)
  - `log_path` (string)
