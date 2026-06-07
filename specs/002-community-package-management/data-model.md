# Data Model: Gestao de Pacotes Comunitarios A11yDevs

## Lisp Package Source Unit

- Entity: unidade de codigo fonte em `lisp/<nome-pacote>/`.
- Fields:
  - `package_name`: nome simbolico do pacote (ex.: `a11y-java`).
  - `lisp_dir`: caminho relativo no monorepo (ex.: `lisp/a11y-java`).
  - `main_file`: arquivo principal `.el` (ex.: `a11y-java.el`).
  - `role`: `base`, `optional`, `aggregator` ou `infrastructure`.
  - `status`: `planned`, `validated`, `ready`.
- Validation rules:
  - `main_file` deve ter o mesmo nome de `package_name`.
  - `lisp_dir` deve conter apenas o codigo do pacote correspondente.
  - `role=infrastructure` nao pode ser promovido a pacote comum sem analise de dependencia circular.

## Emacs Package Metadata Contract

- Entity: contrato de metadados dentro do arquivo principal do pacote.
- Required fields/sections:
  - linha inicial com descricao curta
  - `lexical-binding`
  - `Author`
  - `Version`
  - `Package-Requires`
  - `Keywords`
  - `URL`
  - `;;; Commentary:`
  - `;;; Code:`
  - `(provide 'nome-do-pacote)`
  - linha final `;;; nome-do-pacote.el ends here`
- Conditional requirements:
  - `;;;###autoload` para comandos publicos, quando aplicavel
  - `defgroup` e `defcustom` para opcoes configuraveis, quando aplicavel

## Package Documentation Unit

- Entity: README minimo por pacote (`lisp/<nome-pacote>/README.md`).
- Fields:
  - `description`
  - `dependencies`
  - `install_example` (`package-vc-install`)
  - `require_example`
  - `basic_configuration_example`
- Validation rules:
  - exemplos devem refletir `:lisp-dir` e `:main-file` reais do pacote
  - README ausente ou incompleto bloqueia status `ready`

## Package Topology

- Entity: relacao de dependencias entre pacotes no monorepo.
- Base packages:
  - `a11y-core`
  - `a11y-accessibility`
  - `a11y-navigation`
  - `a11y-completion`
- Aggregator package:
  - `a11y-emacs`
- Optional packages:
  - `a11y-java`
  - `a11y-java-lsp`
  - `a11y-gptel`
  - `a11y-shell`
  - `a11y-dired`
  - `a11y-layout`
  - `a11y-layout-ide`
- Validation rules:
  - `a11y-emacs` deve carregar/depender dos pacotes base
  - opcionais nao devem depender de modulos nao relacionados
  - dependencias circulares invalidam o pacote

## Legacy Packaging Mirror Mapping (optional)

- Entity: mapeamento opcional entre origem `lisp/` e destinos de consumidores legados (ex.: empacotamento sistêmico).
- Fields:
-  - `source_path` (em `lisp/`)
-  - `consumer_target_path` (ex.: `packages/emacs-a11y-config/usr/share/a11y-emacs/lisp`)
-  - `sync_mode` (`copy`, `mirror` ou `reuse`)
-  - `manual_duplication` (boolean, esperado `false`)
- Validation rules:
-  - `manual_duplication` deve permanecer `false`
-  - consumidores legados devem ser atualizados para consumir artefatos da fonte em `lisp/` quando aplicavel

## Planned Validation Checklist Entity

- Entity: checklist tecnico de readiness para implementacao.
- Fields:
  - `id`
  - `description`
  - `type` (`install`, `load`, `autoload`, `customization`, `dependency`, `documentation`)
  - `status` (`pending`, `pass`, `fail`)
  - `evidence`
- Required checklist items:
  - instalacao de pacote individual via `package-vc-install`
  - instalacao de opcional via `package-vc-install`
  - instalacao do agregador `a11y-emacs`
  - `require` apos instalacao
  - validacao de autoload
  - validacao de `defgroup`/`defcustom`
  - isolamento de opcionais
  - dependencia base no agregador
  - ausencia de dependencia circular
  - `Package-Requires` completo
  - compatibilidade com consumidores documentados (se aplicavel)
  - README minimo funcional por pacote
