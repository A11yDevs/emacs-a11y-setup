# Implementation Plan: Gestao de Pacotes Comunitarios A11yDevs

**Branch**: `002-community-package-management` | **Date**: 2026-06-07 | **Spec**: `specs/002-community-package-management/spec.md`

**Input**: Feature specification from `/specs/002-community-package-management/spec.md`

## Summary

Planejar a distribuicao modular dos modulos Emacs Lisp da Comunidade A11yDevs via `package-vc-install`, usando o monorepo `https://github.com/A11yDevs/emacs-a11y-setup` (fonte canônica, ex.: https://github.com/A11yDevs/emacs-a11y-setup/tree/main/lisp) como fonte única nesta fase. A proposta define o layout `lisp/<package>/`, estabelece pacote agregador `a11y-emacs`, define metadados/documentacao obrigatorios por pacote, registra riscos arquiteturais e descreve validacoes tecnicas para implementacao posterior.

## Technical Context

**Language/Version**: Emacs Lisp (runtime alvo com suporte pratico a `package-vc-install`)

**Primary Dependencies**: `package.el`, `package-vc-install`, convencoes de metadados de pacote Emacs, ERT para validacoes futuras

**Repository Strategy**: monorepo `A11yDevs/emacs-a11y-setup` nesta fase (fonte canônica: https://github.com/A11yDevs/emacs-a11y-setup/tree/main/lisp); sem split por repositorio agora

**Source of Truth (Lisp)**: arvore `lisp/` no repositório `A11yDevs/emacs-a11y-setup` como fonte principal dos pacotes Emacs Lisp

**Packaging Relationship**: Artefatos de empacotamento/instalacao sistêmica que existam (ex.: `packages/emacs-a11y-config`) devem consumir ou referenciar a nova árvore `lisp/`; migração de consumidores legados é tratada fora do escopo inicial desta feature.

**Target Platform**: Windows nativo, Linux, macOS, Android/Termux e WSL

**Project Type**: monorepo com multiplos pacotes Emacs Lisp instalaveis por `:lisp-dir` e um pacote agregador

**Performance Goals**: instalacao modular sem copia manual de arquivos; carregamento por `require` funcional e previsivel apos instalacao

**Constraints**:
- manter estrategia monorepo nesta fase
- nao criar repositorios separados por pacote nesta etapa
- nao transformar automaticamente arquivos `init-*.el` em pacotes sem separacao de responsabilidades
- modulo que configura o proprio sistema de pacotes do Emacs nao vira pacote comum (evitar dependencia circular)
 - manter estrategia monorepo; consumidores legados serão migrados fora do escopo inicial
- nao implementar codigo nesta etapa

**Scale/Scope**: pacote agregador + pacotes base/opcionais definidos na feature; split futuro condicionado a maturidade individual de cada pacote

## Constitution Check

The Constitution Check requirement (T028) has been removed for this feature. Implementation changes to `lisp/` should follow the project's standard code-review, CI and contribution policies; maintainers must still verify package metadata, accessibility considerations, and test coverage before merging production changes.

## Project Structure

### Documentation (this feature)

```text
specs/002-community-package-management/
|-- plan.md
|-- research.md
|-- data-model.md
|-- quickstart.md
|-- contracts/
|   |-- public-commands.md
|   `-- public-commands.schema.json
`-- tasks.md
```

Include generated validation artifacts:

```text
|-- checklists/
|   |-- metadata.md
|   |-- validation.md
|   |-- package-requires-validation.md
|   `-- init-audit.md
|-- artifacts/   # output: audit reports, JSON evidence
``` 

### Source Code (repository root)

```text
lisp/
|-- a11y-core/
|   `-- a11y-core.el
|-- a11y-accessibility/
|   `-- a11y-accessibility.el
|-- a11y-navigation/
|   `-- a11y-navigation.el
|-- a11y-completion/
|   `-- a11y-completion.el
|-- a11y-dired/
|   `-- a11y-dired.el
|-- a11y-shell/
|   `-- a11y-shell.el
|-- a11y-java/
|   `-- a11y-java.el
|-- a11y-java-lsp/
|   `-- a11y-java-lsp.el
|-- a11y-gptel/
|   `-- a11y-gptel.el
|-- a11y-layout/
|   `-- a11y-layout.el
|-- a11y-layout-ide/
|   `-- a11y-layout-ide.el
`-- a11y-emacs/
    `-- a11y-emacs.el

packages/
`-- emacs-a11y-config/
    `-- usr/share/a11y-emacs/lisp/  # destino sistêmico (não fonte primária)
```

**Structure Decision**: cada subdiretorio de `lisp/` representa um pacote instalavel independentemente via `package-vc-install`, com arquivo principal de mesmo nome do pacote. A estrutura de empacotamento sistêmico deixa de ser fonte manual e passa a consumir artefatos da árvore `lisp/`.

## Phase Plan

### Phase 0 - Research & Policy Baseline

**Objective**: consolidar as decisoes arquiteturais de distribuicao modular no monorepo.

**Affected artifacts**: `specs/002-community-package-management/research.md`

- **Key decisions**:
- manter monorepo `A11yDevs/emacs-a11y-setup` agora e confirmar a URL canônica para `lisp/` (ver Phase 0 follow-up / T032)
- tratar split de repositorios como opcao futura, nao prerequisito
- separar fonte Lisp de empacotamento/consumidores legados
- formalizar contrato minimo de metadados e documentacao por pacote

**Tests**: N/A nesta fase

**Risks**:
- fronteiras internas mal definidas dificultarem extracao futura
- inconsistencia de versionamento no monorepo

**Exit criteria**:
- `research.md` sem lacunas de decisao

### Phase 1 - Data Model and Public Contracts

**Objective**: modelar entidades de pacote e contratos minimos para instalacao modular.

**Affected artifacts**: `specs/002-community-package-management/data-model.md`, `specs/002-community-package-management/contracts/public-commands.md`, `specs/002-community-package-management/quickstart.md`

**Key decisions**:
- pacote agregador `a11y-emacs` carrega/depende de `a11y-core`, `a11y-accessibility`, `a11y-navigation`, `a11y-completion`
- pacotes opcionais instalam de forma isolada sem dependencias nao relacionadas
- cada pacote possui metadados padrao Emacs, autoload quando aplicavel e README minimo

**Tests**:
- conformidade de metadados por pacote
- conformidade de instalacao individual/opcional/agregador
- conformidade de documentacao minima

**Risks**:
- autoload ausente
- `Package-Requires` incompleto
- acoplamento indevido entre opcionais

**Exit criteria**:
- modelo e contrato tecnicos prontos para guiar tasks

### Phase 2 - Responsibility Split Design (Pre-Implementation)

**Objective**: preparar separacao de responsabilidades dos atuais `init-*.el` antes de qualquer migracao.

**Affected scope (future)**:
- biblioteca reutilizavel
- comandos interativos
- configuracao de usuario
- opcoes customizaveis
- integracoes externas
- inicializacao do ambiente completo

**Key decisions**:
- nao renomear mecanicamente `init-*.el` para pacotes
- separar modulo de configuracao do sistema de pacotes para evitar dependencia circular
- definir matriz de responsabilidade por modulo antes da implementacao

**Tests**:
- revisao arquitetural da matriz de responsabilidades

**Risks**:
- mistura entre config de usuario e biblioteca
- APIs fragilizadas por decomposicao inadequada

**Exit criteria**:
- diretrizes de refatoracao incremental registradas

### Phase 3 - Validation Matrix and Monorepo Deployment

**Objective**: definir matriz de validacao tecnica para aceitar implementacao futura sem regressao.

**Affected artifacts**: `specs/002-community-package-management/quickstart.md`

**Key decisions**:
- validar instalacao por `package-vc-install` (individual, opcional, agregador)
- validar `require`, autoloads e customizacao
- validar isolamento de opcionais e ausencia de dependencia circular
 - validar que `package-vc-install` e consumidores documentados conseguem apontar para `lisp/` e instalar pacotes corretamente

**Tests**:
- execucao dos checkpoints tecnicos desta feature

**Risks**:
- regressao em consumidores legados
- dependencias implicitas entre opcionais

**Exit criteria**:
- matriz de validacao pronta para tarefas e implementacao

### Phase 4 - Governance for Future Repository Split

**Objective**: documentar quando um pacote pode sair do monorepo para repositorio proprio.

**Key decisions**:
- split futuro somente com ciclo de vida, documentacao, issues, versionamento e usuarios proprios
- manter convencoes uniformes no monorepo para facilitar extracao futura

**Tests**: N/A

**Exit criteria**:
- criterios de split registrados no planejamento


- Dependencias circulares entre pacotes.
- Transformacao inadequada de arquivos `init-*.el` em pacotes sem separacao de responsabilidades.
- Mistura entre configuracao de usuario e biblioteca reutilizavel.
- Duplicacao entre `lisp/` e `packages/emacs-a11y-config/usr/share/a11y-emacs/lisp`.
- Autoloads incompletos ou ausentes.
- Dependencias externas nao declaradas em `Package-Requires`.
- Pacotes opcionais exigindo modulos nao relacionados.
 - Quebra da instalacao sistemica ou de consumidores legados caso nao exista plano de migração claro.
- Versionamento inconsistente entre pacotes do mesmo monorepo.
- Dificuldade futura de extrair pacotes para repositorios independentes caso a estrutura interna nao seja bem definida.

## Technical Acceptance Criteria

- Instalar pelo menos um pacote individual com `package-vc-install`.
- Instalar pelo menos um pacote opcional com `package-vc-install`.
- Instalar o pacote agregador `a11y-emacs` com `package-vc-install`.
- Executar `(require 'nome-do-pacote)` apos a instalacao.
- Validar comandos publicos por autoload, quando aplicavel.
- Validar opcoes configuraveis no grupo correto (`defgroup`/`defcustom`), quando aplicavel.
- Validar instalacao isolada de pacotes opcionais.
- Validar que `a11y-emacs` carrega/depende dos modulos principais.
- Validar ausencia de dependencias circulares.
- Validar declaracao de dependencias externas em `Package-Requires`.
 - Validar que consumidores documentados (se aplicavel) continuam funcionando ou foram atualizados para consumir `lisp/`.
- Validar que cada pacote tem `README.md` minimo com exemplo funcional de instalacao.

## Test Strategy

- Contract checks: metadados obrigatorios por pacote (`lexical-binding`, `Author`, `Version`, `Package-Requires`, `Keywords`, `URL`, `Commentary`, `Code`, `provide`, linha final `ends here`).
- Install checks: fluxo individual, opcional e agregador por `package-vc-install`.
- Load checks: `(require 'a11y-java)` e exemplo equivalente com `use-package`.
- Dependency checks: isolamento de opcionais, declaracao de dependencias e deteccao de circularidade.
- Packaging checks: continuidade para consumidores documentados (migração de consumidores legados está fora do escopo inicial).
- Documentation checks: README minimo por pacote com instalacao, require e configuracao basica.

## Installation Examples (Expected)

Pacote individual:

```elisp
(package-vc-install
 '(a11y-java
   :url "https://github.com/A11yDevs/emacs-a11y-setup.git"
   :branch "main"
   :lisp-dir "lisp/a11y-java"
   :main-file "a11y-java.el"))
```

Pacote opcional:

```elisp
(package-vc-install
 '(a11y-gptel
   :url "https://github.com/A11yDevs/emacs-a11y-setup.git"
   :branch "main"
   :lisp-dir "lisp/a11y-gptel"
   :main-file "a11y-gptel.el"))
```

Pacote agregador:

```elisp
(package-vc-install
 '(a11y-emacs
   :url "https://github.com/A11yDevs/emacs-a11y-setup.git"
   :branch "main"
   :lisp-dir "lisp/a11y-emacs"
   :main-file "a11y-emacs.el"))
```

Require esperado:

```elisp
(require 'a11y-java)
```

Use-package esperado:

```elisp
(use-package a11y-java
  :vc (:url "https://github.com/A11yDevs/emacs-a11y-setup.git"
       :branch "main"
       :lisp-dir "lisp/a11y-java"
       :main-file "a11y-java.el"))
```

## Implementation Readiness

Planejamento tecnico concluido para orientar a fase de tasks sem implementacao de codigo nesta etapa: estrutura alvo, fronteiras arquiteturais, riscos, criterios de validacao e exemplos canonicamente esperados foram definidos.
