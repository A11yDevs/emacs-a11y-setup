# Tasks: 001-migracao-modulos-config-workspace

**Input**: Design documents from `/specs/001-migracao-modulos-config-workspace/`

**Prerequisites**: plan.md (required), spec.md (required), research.md, data-model.md, contracts/

**Tests**: Esta feature exige testes ERT em modo batch para fluxos críticos.

**Organization**: Tarefas agrupadas por user story para implementação e validação independentes.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Inicializar estrutura do repositório e convenções base de pacote Emacs Lisp.

- [X] T001 Criar arquivo principal do pacote em `emacs-a11y-setup.el`
- [X] T002 Criar diretório de módulos internos em `lisp/.gitkeep`
- [X] T003 Criar diretório de testes ERT em `test/.gitkeep`
- [X] T004 [P] Criar estrutura base de documentação em `docs/README.md`
- [X] T005 [P] Criar diretório de diagramas de sequência em `docs/sequence/.gitkeep`
- [X] T006 Definir convenção de `provide`/`require` no cabeçalho de `emacs-a11y-setup.el`
- [X] T007 [P] Registrar instruções de carregamento local do pacote em `README.md`
- [X] T008 [P] Definir comando batch padrão de testes ERT em `specs/001-migracao-modulos-config-workspace/quickstart.md`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Implementar fundamentos que bloqueiam todas as user stories.

**CRITICAL**: Nenhuma user story inicia antes desta fase.

- [X] T009 Implementar esqueleto de inicialização pública em `emacs-a11y-setup.el`
- [X] T010 [P] Criar módulo de workspace em `lisp/emacs-a11y-setup-workspace.el`
- [X] T011 [P] Criar módulo de handoff em `lisp/emacs-a11y-setup-handoff.el`
- [X] T012 [P] Criar módulo de perfis em `lisp/emacs-a11y-setup-profiles.el`
- [X] T013 [P] Criar módulo de registro/carregamento de módulos em `lisp/emacs-a11y-setup-modules.el`
- [X] T014 [P] Criar módulo de doctor e relatório em `lisp/emacs-a11y-setup-doctor.el`
- [X] T015 Integrar `require` dos módulos internos em `emacs-a11y-setup.el`
- [X] T016 Definir funções públicas vazias (`first-run`, `bootstrap`, `create-workspace`, `doctor`, `doctor-batch`, `open-dashboard`) em `emacs-a11y-setup.el`
- [X] T017 [P] Publicar contrato funcional das entradas públicas em `specs/001-migracao-modulos-config-workspace/contracts/public-commands.md`
- [X] T018 [P] Atualizar mapa de entidades e estados de execução em `specs/001-migracao-modulos-config-workspace/data-model.md`

**Checkpoint**: fundação pronta para implementação por user story.

---

## Phase 3: User Story 1 - Primeiro uso com workspace isolado (Priority: P1) MVP

**Goal**: Criar/validar workspace separado sem alterar configuração pessoal do Emacs.

**Independent Test**: Executar `emacs-a11y-setup-first-run` em diretório temporário e comprovar criação de estrutura mínima sem tocar `~/.emacs.d` e `~/.config/emacs`.

### Tests for User Story 1

- [X] T019 [P] [US1] Adicionar teste de criação de workspace em diretório temporário em `test/emacs-a11y-setup-workspace-tests.el`
- [X] T020 [P] [US1] Adicionar teste de idempotência de criação/reexecução de workspace em `test/emacs-a11y-setup-workspace-tests.el`
- [X] T021 [P] [US1] Adicionar teste de preservação de configuração pessoal (`~/.emacs.d` e `~/.config/emacs`) em `test/emacs-a11y-setup-workspace-tests.el`

### Implementation for User Story 1

- [X] T022 [US1] Implementar resolução configurável de caminho por plataforma em `lisp/emacs-a11y-setup-workspace.el`
- [X] T023 [US1] Implementar criação idempotente de `config/`, `profiles/`, `logs/`, `reports/` e `backups/` em `lisp/emacs-a11y-setup-workspace.el`
- [X] T024 [US1] Implementar geração de `init.el`, `early-init.el` e `custom.el` do workspace em `lisp/emacs-a11y-setup-workspace.el`
- [X] T025 [US1] Implementar validação de permissões e reparo básico de workspace parcial em `lisp/emacs-a11y-setup-workspace.el`
- [X] T026 [US1] Implementar comando público `emacs-a11y-setup-create-workspace` em `emacs-a11y-setup.el` (depends on T022, T023, T024, T025)
- [X] T027 [US1] Implementar fluxo `emacs-a11y-setup-first-run` com aplicação inicial de perfil em `emacs-a11y-setup.el` (depends on T026, T012)

**Checkpoint**: primeiro uso funcional com workspace isolado.

---

## Phase 4: User Story 2 - Handoff mínimo com bootstrap externo (Priority: P1)

**Goal**: Expor entrada estável para bootstrap externo com contrato versionado e validado.

**Independent Test**: Simular handoff JSON válido e inválido em batch, validando mensagens acessíveis e status de retorno.

### Tests for User Story 2

- [X] T028 [P] [US2] Adicionar teste de handoff válido com campos obrigatórios em `test/emacs-a11y-setup-handoff-tests.el`
- [X] T029 [P] [US2] Adicionar teste de falha sem `contract_version` em `test/emacs-a11y-setup-handoff-tests.el`
- [X] T030 [P] [US2] Adicionar teste de falha por versão incompatível em `test/emacs-a11y-setup-handoff-tests.el`
- [X] T031 [P] [US2] Adicionar teste de falha por `workspace_path` ausente/inválido em `test/emacs-a11y-setup-handoff-tests.el`
- [X] T032 [P] [US2] Adicionar teste de campos opcionais ausentes com fallback seguro em `test/emacs-a11y-setup-handoff-tests.el`

### Implementation for User Story 2

- [X] T033 [US2] Implementar parser/normalização de contrato JSON em `lisp/emacs-a11y-setup-handoff.el`
- [X] T034 [US2] Implementar validação de obrigatórios e semântica de `contract_version` em `lisp/emacs-a11y-setup-handoff.el`
- [X] T035 [US2] Implementar tratamento de opcionais e mensagens acessíveis de erro em `lisp/emacs-a11y-setup-handoff.el`
- [X] T036 [US2] Integrar handoff com criação/validação de workspace no comando `emacs-a11y-setup-bootstrap` em `emacs-a11y-setup.el` (depends on T033, T034, T035, T026)
- [X] T037 [US2] Registrar resultado do handoff para relatório interno em `lisp/emacs-a11y-setup-doctor.el` (depends on T036)
- [X] T038 [US2] Atualizar documentação de contrato versionado em `docs/handoff-contract.md`
- [X] T039 [US2] Alinhar contrato da feature em `specs/001-migracao-modulos-config-workspace/contracts/handoff-contract.md`
- [X] T040 [US2] Atualizar schema JSON do contrato em `specs/001-migracao-modulos-config-workspace/contracts/handoff-contract.schema.json`

**Checkpoint**: handoff versionado funcionando com baixo acoplamento.

---

<!-- Phase 5 (User Story 3 - legacy module migration) removed: migration of legacy modules is out of scope. -->

---

## Phase 6: User Story 4 - Diagnóstico interno e relatório acessível (Priority: P2)

**Goal**: Entregar doctor interativo e batch com relatório textual acionável e seguro.

**Independent Test**: Executar doctor em cenário saudável e com falhas controladas, validando relatório em `reports/` e logs em `logs/`.

### Tests for User Story 4

- [X] T049 [P] [US4] Adicionar teste de relatório textual com timestamp, perfil e status de módulos em `test/emacs-a11y-setup-doctor-tests.el`
- [X] T050 [P] [US4] Adicionar teste de cenário com falha de permissão de escrita em `test/emacs-a11y-setup-doctor-tests.el`
- [X] T051 [P] [US4] Adicionar teste de detecção de ausência de Emacspeak/TTS como aviso em `test/emacs-a11y-setup-doctor-tests.el`
- [X] T052 [P] [US4] Adicionar teste de escrita em `reports/` e `logs/` em `test/emacs-a11y-setup-doctor-tests.el`

### Implementation for User Story 4

- [X] T053 [US4] Implementar checagens de integridade do workspace (`init.el`, `custom.el`, diretórios essenciais) em `lisp/emacs-a11y-setup-doctor.el` (depends on T025)
- [X] T054 [US4] Implementar checagens de perfil padrão e status de módulos essenciais/opcionais em `lisp/emacs-a11y-setup-doctor.el` (depends on T065, T066, T067, T068)
- [X] T055 [US4] Implementar detecção/report de Emacspeak e backend TTS do handoff em `lisp/emacs-a11y-setup-doctor.el`
- [X] T056 [US4] Implementar geração de relatório textual acessível com próximos passos em `lisp/emacs-a11y-setup-doctor.el`
- [X] T057 [US4] Implementar sanitização para não expor segredos/tokens em logs em `lisp/emacs-a11y-setup-doctor.el`
- [X] T058 [US4] Implementar comandos públicos `emacs-a11y-setup-doctor` e `emacs-a11y-setup-doctor-batch` em `emacs-a11y-setup.el` (depends on T053, T054, T055, T056, T057)
- [X] T059 [US4] Implementar `emacs-a11y-setup-open-dashboard` com buffer textual acessível em `emacs-a11y-setup.el` (depends on T056, T058)

**Checkpoint**: doctor/reporting funcional em modo interativo e batch.

---

## Phase 7: User Story 5 - Perfil padrão conservador e expansão futura (Priority: P2)

**Goal**: Definir perfil padrão seguro e carregamento resiliente de módulos.

**Independent Test**: Validar aplicação do perfil conservador, módulos essenciais ativos e opcionais sensíveis desabilitados por padrão.

### Tests for User Story 5

- [X] T060 [P] [US5] Adicionar teste de aplicação do perfil padrão conservador em `test/emacs-a11y-setup-profiles-tests.el`
- [X] T061 [P] [US5] Adicionar teste de módulos opcionais desabilitados por padrão em `test/emacs-a11y-setup-modules-tests.el`
- [X] T062 [P] [US5] Adicionar teste de falha de módulo opcional sem bloqueio do doctor em `test/emacs-a11y-setup-modules-tests.el`
- [X] T063 [P] [US5] Adicionar teste para manter módulos com credenciais desabilitados por padrão em `test/emacs-a11y-setup-profiles-tests.el`

### Implementation for User Story 5

- [X] T064 [US5] Definir estrutura inicial dos perfis (`iniciante`, `emacspeak-basico`, `java`, `latex`, `termux`, `windows-nativo`, `oficina-curso`, `avancado`) em `lisp/emacs-a11y-setup-profiles.el`
- [X] T065 [US5] Implementar perfil padrão conservador em `lisp/emacs-a11y-setup-profiles.el`
- [X] T066 [US5] Implementar registro de módulos essenciais por domínio em `lisp/emacs-a11y-setup-modules.el`
- [X] T067 [US5] Implementar registro de módulos opcionais e política de credenciais em `lisp/emacs-a11y-setup-modules.el`
- [X] T068 [US5] Implementar carregamento resiliente com erro crítico para essencial e aviso para opcional em `lisp/emacs-a11y-setup-modules.el`

**Checkpoint**: perfil conservador aplicado com modularidade resiliente.

---

## Phase 8: User Story 6 - Continuidade com distribuição externa (Priority: P3)

**Goal**: Documentar interfaces públicas e artefatos de engenharia para integração externa sem acoplamento indevido.

**Independent Test**: Validar que contratos e documentação descrevem fronteiras claras entre setup, installer e distribuição.

### Tests for User Story 6

- [X] T069 [P] [US6] Adicionar teste de presença dos artefatos obrigatórios em `docs/` em `test/emacs-a11y-setup-doctor-tests.el`
- [X] T070 [P] [US6] Adicionar validação sintática de PlantUML (quando ferramenta disponível) em `test/emacs-a11y-setup-doctor-tests.el`
- [X] T071 [P] [US6] Adicionar teste de cobertura de user stories P1/P2 pelos casos de uso textuais em `test/emacs-a11y-setup-doctor-tests.el`

### Implementation for User Story 6

- [X] T072 [US6] Criar índice de documentação e rastreabilidade geral em `docs/README.md`
- [X] T073 [US6] Criar diagrama de caso de uso global com fronteira de escopo em `docs/use-case-global.puml`
- [X] T074 [US6] Criar casos de uso textuais UC01-UC12 com vínculo a FR/aceite em `docs/use-cases.md`
- [X] T075 [US6] Criar sequência de primeiro uso e criação de workspace em `docs/sequence/first-run-workspace.puml`
- [X] T076 [US6] Criar sequência de handoff com bootstrap externo em `docs/sequence/bootstrap-handoff.puml`
- [X] T077 [US6] Criar sequência de diagnóstico interno em `docs/sequence/internal-doctor.puml`
- [X] T078 [US6] Criar sequência de carregamento resiliente de módulos em `docs/sequence/module-loading.puml`
- [X] T079 [US6] Criar sequência de inventário/classificação de migração (histórico) em `docs/sequence/module-migration-inventory.puml`

**Checkpoint**: integração documental pronta para consumo por distribuição externa.

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Fechar execução batch, quickstart e revisão constitucional/final.

- [X] T080 Atualizar execução local dos comandos públicos em `specs/001-migracao-modulos-config-workspace/quickstart.md`
- [X] T081 [P] Validar comando de simulação de handoff JSON em `specs/001-migracao-modulos-config-workspace/quickstart.md`
- [X] T082 [P] Validar comando de execução ERT em batch em `specs/001-migracao-modulos-config-workspace/quickstart.md`
- [X] T083 Gerar matriz de compatibilidade e consistência entre `docs/handoff-contract.md`, `specs/001-migracao-modulos-config-workspace/contracts/handoff-contract.md` e `specs/001-migracao-modulos-config-workspace/contracts/handoff-contract.schema.json`
- [X] T084 [P] Revisar acessibilidade textual de logs/relatórios e dashboard em `lisp/emacs-a11y-setup-doctor.el`
- [X] T085 [P] Revisar conformidade de isolamento e não alteração da configuração pessoal em `lisp/emacs-a11y-setup-workspace.el`
- [X] T086 Revisar rastreabilidade `spec.md` -> `plan.md` -> `tasks.md` -> docs -> testes em `specs/001-migracao-modulos-config-workspace/tasks.md`
- [X] T087 Executar suíte completa de testes ERT em batch via `specs/001-migracao-modulos-config-workspace/quickstart.md`
- [X] T088 Validar checklist de conformidade constitucional e fora de escopo em `specs/001-migracao-modulos-config-workspace/plan.md`
- [X] T089 Definir matriz de compatibilidade futura de empacotamento/publicação (sem implementar publicação) em `docs/README.md` e `specs/001-migracao-modulos-config-workspace/quickstart.md` (FR-021)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: inicia imediatamente.
- **Phase 2 (Foundational)**: depende da Phase 1 e bloqueia todas as user stories.
- **US1-US6 (Phases 3-8)**: dependem da conclusão da Phase 2.
- **Phase 9 (Polish)**: depende da conclusão das fases US prioritárias desejadas.

### User Story Dependencies

- **US1 (P1)**: começa após Foundational; base para fluxo de primeiro uso.
- **US2 (P1)**: começa após Foundational; depende de integração mínima com workspace.
- **US3 (P1)**: começa após Foundational; independente da implementação completa de doctor.
- **US4 (P2)**: depende de US1, US2 e US5 para checagens completas.
- **US5 (P2)**: depende de US1 para aplicar perfis no workspace.
- **US6 (P3)**: pode avançar em paralelo com US3/US4 após contratos e comandos públicos estarem definidos.

### Within Each User Story

- Escrever testes primeiro, quando aplicável, e garantir que falhem antes da implementação.
- Implementar funções/módulos base antes de integração com comando público.
- Finalizar documentação e validação independente da história antes de avançar.

### Parallel Opportunities

- T003, T004, T005, T007, T008 podem rodar em paralelo na Phase 1.
- T010-T014 podem rodar em paralelo na Phase 2.
- Testes marcados com `[P]` em cada US podem rodar em paralelo.
- T072-T079 (docs de US6) podem ser divididas entre múltiplos mantenedores em paralelo.

---

## Parallel Example: User Story 1

```bash
# Testes paralelos de US1
Task: "T019 Adicionar teste de criação de workspace em test/emacs-a11y-setup-workspace-tests.el"
Task: "T020 Adicionar teste de idempotência em test/emacs-a11y-setup-workspace-tests.el"
Task: "T021 Adicionar teste de preservação de configuração pessoal em test/emacs-a11y-setup-workspace-tests.el"

# Implementação paralela inicial de US1
Task: "T022 Implementar resolução de caminho por plataforma em lisp/emacs-a11y-setup-workspace.el"
Task: "T023 Implementar criação de diretórios mínimos em lisp/emacs-a11y-setup-workspace.el"
Task: "T024 Implementar geração de init/custom/early-init em lisp/emacs-a11y-setup-workspace.el"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Completar Phase 1 e Phase 2.
2. Completar Phase 3 (US1).
3. Validar fluxo de primeiro uso e isolamento.
4. Demonstrar MVP com workspace funcional e sem alteração de configuração pessoal.

### Incremental Delivery

1. Setup + Foundational.
2. US1 (workspace) + validação.
3. US2 (handoff) + validação.
4. US3 (migração legada) - REMOVIDA do fluxo incremental (fora de escopo).
5. US5 (perfis/módulos) + validação.
6. US4 (doctor/reporting) + validação.
7. US6 (documentação de engenharia) + validação.
8. Polish final com conformidade constitucional.

### Parallel Team Strategy

1. Equipe A: workspace e comandos públicos (US1).
2. Equipe B: handoff/schema/contratos (US2).
3. Equipe C: perfis/módulos (US5) e parte dos testes.
4. Equipe D: documentação PlantUML/Markdown (US6) em paralelo após contratos definidos.

