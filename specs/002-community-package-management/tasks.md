# Tasks: Gestão de Pacotes Comunitários A11yDevs

## Overview

Este arquivo lista tarefas executáveis organizadas por fase e por história de usuário, seguindo o formato de checklist requerido.

**Feature**: 002-community-package-management

---
## Dependencies (story completion order)

- Must complete Foundational tasks (T005,T006) before running User Story tests.
- User Story execution order: US1 (T007-T011) -> US2 (T012-T014) -> US3 (T015).

## Parallel opportunities

- Tasks marked with `[P]` can run in parallel (different files or package-scoped validations): T002, T003, T004, T005, T006, T008, T010, T013, T014, T016.


## Independent test criteria (per story)

- [US1] Install a single package via `package-vc-install`, run `(require 'nome-do-pacote)`, confirm no manual copying and no load errors.
- [US2] Install `a11y-emacs` aggregator in a clean environment and verify required base packages are loaded; install an optional package separately and verify isolation.
- [US3] Verify that documented consumers or install flow (via `package-vc-install` with `:lisp-dir`) can install packages from `lisp/` and confirm no regressions in produced artifacts for those consumers.

## Suggested MVP

- MVP scope: User Story 1 (T007-T011) — deliver concrete validation that an individual package can be installed and loaded via `package-vc-install`.

---

Generated tasks: T001..T034

## Phase 1: Setup (Shared Infrastructure)

Purpose: Project initialization and basic structure for feature implementation.

- [ ] T001 Create feature checklist directory and README: `specs/002-community-package-management/checklists/README.md` (esqueleto de checklists e instruções de uso).
- [ ] T002 [P] Create tests directory and placeholder: `specs/002-community-package-management/tests/placeholder.md` (base para testes ERT e documentação de cenários).
- [ ] T003 [P] Ensure artifacts directory exists and include hello-world artifact: `specs/002-community-package-management/artifacts/a11y-hello/` (verificar presença de `a11y-hello.el` e `README.md`).
- [ ] T004 Create contracts README: `specs/002-community-package-management/contracts/README.md` (explicar schema, uso e localização de `public-commands` contract files).

## Phase 2: Foundational (Blocking Prerequisites)

Purpose: Core validations and safeguards that MUST be completed before user story implementations.

- [x] T005 [P] Add diagnostics-first checklist: `specs/002-community-package-management/checklists/diagnostics-checklist.md` (itens executáveis para `doctor/check` antes de mutações).
- [x] T006 [P] Add workspace isolation checklist: `specs/002-community-package-management/checklists/workspace-isolation.md` (itens para garantir que `~/.emacs.d`/config pessoal não seja sobrescrito).

## Governance

The Constitution Check task T028 has been removed. Proceed with implementations following standard code-review and CI policies; maintainers must still verify metadata, accessibility checks and tests before merging changes that affect `lisp/`.

- [ ] T029 Create checklist: `specs/002-community-package-management/checklists/package-requires-validation.md` (esqueleto e itens executáveis para validar `Package-Requires`).
- [ ] T030 Create checklist: `specs/002-community-package-management/checklists/init-audit.md` (esqueleto e itens executáveis para auditar `init-*.el` e prevenir migração automática).

- [ ] T032 Confirm monorepo repository: criar/confirmar `A11yDevs/emacs-a11y-setup` com árvore `lisp/` e registrar URL canônica (ex.: https://github.com/A11yDevs/emacs-a11y-setup/tree/main/lisp). Incluir evidência em `specs/002-community-package-management/`.
- [x] T033 Create hello-world package (artifact): adicionar `specs/002-community-package-management/artifacts/a11y-hello/` com `a11y-hello.el` e `README.md` como pacote de teste para instalação via `package-vc-install` e testes automatizados. (IMPLEMENTED: artefato armazenado em `artifacts/`.)
  NOTE: O artefato de teste foi criado em `specs/002-community-package-management/artifacts/a11y-hello/` como referência para verificação e testes automatizados.
- [x] T034 Promote hello-world to lisp/: opcional/manual — `a11y-hello` promovido para `lisp/a11y-hello/` (cópia criada a partir de `specs/002-community-package-management/artifacts/`). Promoção deve ocorrer via PR manual quando aplicável; artefato original permanece em `specs/.../artifacts/` como referência.


---

## Phase 3: User Story 1 - Operar ciclo básico de pacotes (Priority: P1)

**Goal**: Entregar list, install, activate, deactivate, remove e update para pacotes comunitários A11yDevs com mensagens acessíveis, idempotência e estado persistido.

**Independent Test**: Executar os seis comandos sobre um pacote de exemplo em workspace temporário e verificar estado final, mensagens lineares e comportamento idempotente quando a mesma operação é repetida.

### Tests for User Story 1

- [x] T008 Adicionar cobertura ERT para list/install/activate/deactivate/remove/update em test/emacs-a11y-setup-community-packages-tests.el, incluindo lista vazia e repetição idempotente.

### Implementation for User Story 1

 - [x] T009 Implementar em lisp/emacs-a11y-setup-community-packages.el o comando de listagem com renderização textual acessível e reconciliação com o state registry.
 - [x] T010 Implementar em lisp/emacs-a11y-setup-community-packages.el os handlers de install, activate, deactivate e remove com transições de estado explícitas e persistência workspace-local.
 - [x] T011 Implementar em lisp/emacs-a11y-setup-community-packages.el o fluxo de update com resultado por pacote, resumo final e preservação do estado de ativação.
 - [x] T012 Amarrar em lisp/emacs-a11y-setup-community-packages.el as seis entradas públicas emacs-a11y-setup-community-packages-list/install/activate/deactivate/remove/update ao mesmo engine interno.
 - [x] T013 Ajustar em lisp/emacs-a11y-setup-community-packages.el as mensagens de sucesso, aviso e erro para manter texto curto, linear e acionável.

**Checkpoint**: A jornada básica de gerenciamento comunitário fica funcional e pode ser validada sozinha como MVP.

---

## Phase 4: User Story 2 - Executar operações em modo interativo e batch (Priority: P2)

**Goal**: Garantir que a mesma lógica funcione em modo interativo e batch com comportamento funcional equivalente, incluindo confirmação explícita para ações destrutivas.

**Independent Test**: Rodar a mesma entrada em modo interativo e batch, comparar o envelope de retorno, o código de saída e a mensagem final, e confirmar que ações destrutivas exigem consentimento explícito.

### Tests for User Story 2

- [ ] T014 Adicionar cobertura ERT em test/emacs-a11y-setup-community-packages-tests.el para parity interativo/batch, mapeamento de exit code e gating de confirmação.

### Implementation for User Story 2

- [ ] T031 [US2/FR-003] Implementar e validar o pacote agregador `a11y-emacs` em `lisp/a11y-emacs/a11y-emacs.el` e criar `specs/002-community-package-management/tests/install-aggregator.md` (instalação via `package-vc-install`, verificação de módulos base carregados). 

### Implementation for User Story 2

- [ ] T015 Implementar em lisp/emacs-a11y-setup-community-packages.el a normalização de resultados batch e o mapeamento de exit codes definido em specs/002-community-package-management/contracts/public-commands.md.
- [ ] T016 Implementar em lisp/emacs-a11y-setup-community-packages.el os wrappers interativos com prompts de confirmação para ações destrutivas, sem alterar o caminho batch.
- [ ] T017 Implementar em lisp/emacs-a11y-setup-community-packages.el o suporte a workspace-path explícito para batch e testes, garantindo que todos os wrappers chamem o mesmo engine.

**Checkpoint**: O recurso se comporta de forma equivalente em batch e interativo, com confirmação segura apenas quando necessário.

---

## Phase 5: User Story 3 - Confiar na origem e nos diagnósticos de falha (Priority: P3)

**Goal**: Bloquear origens fora da política A11yDevs e retornar diagnósticos acionáveis para falhas de rede, repositório, runtime e pré-requisito do ambiente.

**Independent Test**: Simular origem fora da org permitida, indisponibilidade de repositório e runtime sem package-vc, verificando bloqueio seguro, mensagem objetiva e próxima ação sugerida.

### Tests for User Story 3

- [ ] T018 Adicionar cobertura ERT em test/emacs-a11y-setup-community-packages-tests.el para rejeição de origem não confiável, falhas de rede/repositório e diagnóstico do pré-requisito da base core mínima quando aplicável.

### Implementation for User Story 3

- [ ] T019 Implementar em lisp/emacs-a11y-setup-community-packages.el a validação de origem A11yDevs e a normalização de source_url/ref antes de qualquer mutação.
- [ ] T020 Implementar em lisp/emacs-a11y-setup-community-packages.el a classificação de falhas de rede, repositório, estado conflituoso e runtime sem package-vc, com next-action claro.
- [ ] T021 Implementar em lisp/emacs-a11y-setup-community-packages.el o registro de logs e o preenchimento de log-path por operação, mantendo todas as escritas dentro do workspace isolado.

**Checkpoint**: As mutações ficam protegidas por política de confiança e falhas passam a produzir diagnóstico acessível e recuperável.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Fechar documentação, regressões e validação final sem alterar o desenho funcional já aprovado.

- [ ] T022 Atualizar specs/002-community-package-management/quickstart.md com os comandos finais de validação batch e os resultados esperados da feature implementada.
- [ ] T023 [P] Atualizar README.md e docs/README.md com a superfície pública dos comandos, o modelo de estado workspace-local e a política de confiança A11yDevs.
- [ ] T024 [P] Adicionar regressões finais em test/emacs-a11y-setup-community-packages-tests.el para update parcial, no-op idempotente e lista vazia.
- [ ] T025 Executar a suíte batch descrita em specs/002-community-package-management/quickstart.md e corrigir eventuais falhas em lisp/emacs-a11y-setup-community-packages.el ou test/emacs-a11y-setup-community-packages-tests.el.
- [ ] T026 Validar a consistência entre specs/002-community-package-management/contracts/public-commands.schema.json e a envelope implementada, ajustando specs/002-community-package-management/contracts/public-commands.md apenas se a redação precisar de refinamento.
- [ ] T027 Revisar a redação das mensagens e remover código morto em lisp/emacs-a11y-setup-community-packages.el para manter saídas curtas, lineares e amigáveis a leitor de tela.

---

## Dependencies & Execution Order

### Phase Dependencies

- Phase 1 Setup: pode começar imediatamente.
- Phase 2 Foundational: depende da conclusão da Setup e bloqueia todas as user stories.
- Phase 3 US1: depende da Foundational e entrega o MVP.
- Phase 4 US2: depende da Foundational e pode avançar depois do engine comum existir.
- Phase 5 US3: depende da Foundational e fecha a camada de confiança e diagnóstico.
- Phase 6 Polish: depende das user stories que o time quiser estabilizar antes do merge.

### User Story Dependencies

- US1 é a base funcional e deve ser priorizada como MVP.
- US2 reaproveita o engine de US1 e valida paridade entre modos.
- US3 reaproveita o mesmo engine e adiciona política de confiança, diagnósticos e logs.

### Within Each User Story

- Testes vêm antes da implementação principal quando houver cobertura nova.
- Helpers compartilhados vêm antes dos comandos públicos que os consomem.
- O wrapper público só deve ser ligado depois que o engine interno estiver estável.
- A validação final do story acontece antes de iniciar o próximo story.

---

## Parallel Opportunities

- T001, T002 e T003 podem começar em paralelo porque tocam arquivos distintos de setup.
- Em Phase 6, T022, T023 e T024 podem avançar em paralelo porque atualizam documentação e regressões em arquivos diferentes.
- O restante das tasks do módulo principal deve ser tratado de forma sequencial, porque compartilha o mesmo arquivo lisp/emacs-a11y-setup-community-packages.el.

---

## Parallel Example: User Story 1

```text
Task: T008 Adicionar cobertura ERT para list/install/activate/deactivate/remove/update em test/emacs-a11y-setup-community-packages-tests.el, incluindo lista vazia e repetição idempotente.
Task: T009 Implementar em lisp/emacs-a11y-setup-community-packages.el o comando de listagem com renderização textual acessível e reconciliação com o state registry.
```

## Parallel Example: Documentation/Polish

```text
Task: T022 Atualizar specs/002-community-package-management/quickstart.md com os comandos finais de validação batch e os resultados esperados da feature implementada.
Task: T023 Atualizar README.md e docs/README.md com a superfície pública dos comandos, o modelo de estado workspace-local e a política de confiança A11yDevs.
Task: T024 Adicionar regressões finais em test/emacs-a11y-setup-community-packages-tests.el para update parcial, no-op idempotente e lista vazia.
```

---

## Implementation Strategy

### MVP First

1. Concluir Phase 1 Setup.
2. Concluir Phase 2 Foundational.
3. Entregar Phase 3 US1 como primeira fatia útil e demonstrável.
4. Validar o fluxo básico de list/install/activate/deactivate/remove/update antes de expandir escopo.

### Incremental Delivery

1. Infraestrutura e contratos compartilhados.
2. Engine básico de pacotes comunitários A11yDevs.
3. Paridade interativo/batch com confirmação segura.
4. Diagnósticos de confiança, rede e runtime.
5. Polimento, regressões e documentação final.

### Notes

- O escopo dinâmico fica restrito a pacotes comunitários A11yDevs.
- A base core mínima permanece como pré-requisito do ambiente, não como eixo de implementação dinâmica.
- O design deve permanecer acessível, idempotente e seguro em todas as fases.