# Implementation Plan: 001-migracao-modulos-config-workspace

**Branch**: `001-migracao-modulos-config-workspace` | **Date**: 2026-06-03 | **Spec**: `specs/001-migracao-modulos-config-workspace/spec.md`

**Input**: Feature specification from `/specs/001-migracao-modulos-config-workspace/spec.md`

## Summary

Implementar o esqueleto técnico do pacote Emacs Lisp `emacs-a11y-setup` para primeiro uso com workspace isolado, handoff versionado e de baixo acoplamento com bootstrap externo, perfil padrão conservador, carregamento modular resiliente e diagnóstico interno com relatórios textuais acessíveis. A entrega será incremental: estrutura base do pacote, workspace e isolamento, contrato de handoff, perfis/módulos, doctor/reporting, documentação de projeto de software em PlantUML/Markdown na pasta `docs/`, documentação de migração legada e suíte ERT em batch.

## Technical Context

**Language/Version**: Emacs Lisp (GNU Emacs 28+; Emacs 29+ preferencial para `--init-directory`, com fallback para `-q -l <workspace>/init.el`)

**Primary Dependencies**: bibliotecas nativas de Emacs (`cl-lib`, `subr-x`, `json`, `seq`), ERT para testes; Emacspeak detectado/integrado como dependência opcional de runtime

**Storage**: sistema de arquivos local (workspace separado), arquivos de relatório/log textuais e contrato de handoff em JSON (payload de entrada e/ou arquivo)

**Testing**: ERT em modo interativo e batch (`emacs --batch`), com testes unitários e de integração leve para workspace, handoff, perfis, módulos e doctor

**Target Platform**: Windows nativo, Debian/Ubuntu, macOS, Android/Termux e WSL

**Project Type**: pacote/biblioteca Emacs Lisp com comandos interativos e comandos batch

**Performance Goals**: fluxo de primeiro uso e doctor concluindo em tempo interativo aceitável (< 5s em ambiente de referência sem rede); geração de relatório textual em execução única

**Constraints**: não implementar installer/launchers; não alterar `~/.emacs.d` ou `~/.config/emacs` por padrão; não usar caminhos Debian fixos; não habilitar módulos com credenciais por padrão; manter baixo acoplamento com repositórios externos

**Out of Scope (reinforced)**: sem geração de PDF, sem documentação gráfica proprietária, sem implementação do installer, sem criação de launchers, sem empacotamento Debian final e sem publicação MELPA/ELPA nesta feature

**Scale/Scope**: primeira feature do repositório; núcleo mínimo para perfil conservador, inventário inicial de 13 módulos legados e base de evolução para próximas fases

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Accessibility gate: The plan MUST describe keyboard-first flows, screen-reader-
  friendly outputs, and no GUI-only critical path.
- Emacs/Emacspeak gate: The plan MUST define how Emacs Lisp is the primary interface
  and how Emacspeak feedback is preserved or improved.
- Installer/setup boundary gate: The plan MUST separate responsibilities between
  `emacs-a11y-installer` (external bootstrap) and `emacs-a11y-setup` (in-Emacs control
  and maintenance).
- Handoff gate: The plan MUST define a minimal, stable handoff contract between
  installer and setup, including allowed inputs, launcher ownership, and explicit
  avoidance of installer dependence on internal workspace structure.
- Platform gate: The plan MUST analyze impact for Windows native, Debian/Ubuntu,
  macOS, Android/Termux, and WSL, with explicit justification for any exclusions.
- Workspace isolation gate: The plan MUST preserve user personal Emacs config and use
  separate emacs-a11y workspace defaults.
- Diagnostics gate: The plan MUST include doctor/check strategy before mutating setup.
- Bootstrap speaking gate: The recommended installation path MUST target a speaking
  Emacs when technically possible; if not possible automatically, the plan MUST define
  an accessible recovery path via terminal/log guidance.
- Installation modes gate: The plan MUST document scope differences for `minimal`,
  `recommended` (default), and `full` installation modes.
- Bootstrap validation gate: The plan MUST include installer-side checks (Emacs,
  batch Emacs, Emacspeak, initial TTS/server, setup invocation, handoff, launcher,
  no personal config load, accessible bootstrap report) and setup-side checks
  (workspace creation, workspace init load, internal configuration validity,
  Emacspeak in workspace, internal diagnostics/reporting).
- Modularity gate: The plan MUST isolate platform-specific logic in dedicated modules.
- Quality gate: The plan MUST include idempotency, clear error reporting, and test
  strategy for critical flows.
- Governance gate: The plan MUST map required docs, linked issues, and PR compliance
  checklist updates.

### Gate Evaluation (Pre-Design)

- Accessibility gate: PASS - comandos e relatórios serão textuais, acionáveis e legíveis por leitor de tela.
- Emacs/Emacspeak gate: PASS - Emacs Lisp como interface primária; presença/ausência de Emacspeak verificada no doctor.
- Installer/setup boundary gate: PASS - setup interno em escopo; installer tratado apenas por contrato público de handoff.
- Handoff gate: PASS - contrato JSON versionado com validações de obrigatórios/opcionais e mensagens acessíveis.
- Platform gate: PASS - sem lógica de SO específica nesta feature, com caminhos equivalentes documentados para as 5 plataformas alvo + WSL.
- Workspace isolation gate: PASS - criação/validação de workspace separado com proteção explícita de configuração pessoal.
- Diagnostics gate: PASS - doctor interativo e batch definidos como parte do núcleo.
- Bootstrap speaking gate: PASS - setup registra condição de fala e próximos passos quando Emacspeak/TTS não estiverem disponíveis.
- Installation modes gate: PASS - compatível com evolução dos modos, sem expandir escopo do installer.
- Bootstrap validation gate: PASS - lado setup coberto diretamente; lado installer coberto por contrato/documentação e testes de integração de handoff simulado.
- Modularity gate: PASS - módulos por domínio com obrigatório/opcional e fallback resiliente.
- Quality gate: PASS - idempotência de workspace, mensagens claras e suíte ERT definida.
- Governance gate: PASS - documentação obrigatória incluída (`docs/handoff-contract.md`, `docs/migration-from-emacs-a11y.md`, artefatos de spec/plan).

## Project Structure

### Documentation (this feature)

```text
specs/001-migracao-modulos-config-workspace/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── handoff-contract.md
│   └── handoff-contract.schema.json
└── tasks.md
```

### Source Code (repository root)

```text
emacs-a11y-setup.el
lisp/
├── emacs-a11y-setup-workspace.el
├── emacs-a11y-setup-handoff.el
├── emacs-a11y-setup-doctor.el
├── emacs-a11y-setup-profiles.el
└── emacs-a11y-setup-modules.el
docs/
├── README.md
├── use-case-global.puml
├── use-cases.md
├── handoff-contract.md
├── migration-from-emacs-a11y.md
└── sequence/
  ├── first-run-workspace.puml
  ├── bootstrap-handoff.puml
  ├── internal-doctor.puml
  ├── module-loading.puml
  └── module-migration-inventory.puml
test/
├── emacs-a11y-setup-workspace-tests.el
├── emacs-a11y-setup-handoff-tests.el
├── emacs-a11y-setup-doctor-tests.el
├── emacs-a11y-setup-profiles-tests.el
└── emacs-a11y-setup-modules-tests.el
```

**Structure Decision**: Projeto único em Emacs Lisp com entrada principal no repositório raiz e módulos em `lisp/`, documentação operacional em `docs/` e testes ERT em `test/`. Esta estrutura maximiza isolamento, previsibilidade de load-path e evolução incremental do pacote sem acoplamento com distribuição externa.

## Phase Plan

### Phase 0 - Research & Architecture Baseline

**Objective**: Fechar decisões técnicas de workspace, handoff, perfis e estratégia de migração incremental.

**Affected artifacts**: `specs/001-migracao-modulos-config-workspace/research.md`

**Key decisions**:
- Contrato de handoff em JSON com `contract_version` e validação de obrigatórios.
- `early-init.el` será criado em versão mínima já nesta feature para preparar evolução segura de inicialização sem tocar configuração pessoal.
- Perfil padrão conservador com módulos essenciais e opcionais explicitamente desabilitados por padrão.

**Tests**: N/A (fase de decisão)

**Risks**:
- Ambiguidade de fallback entre `--init-directory` e `-q -l`.
- Definição inicial de contrato insuficiente para evoluções futuras.

**Exit criteria**:
- `research.md` completo sem `NEEDS CLARIFICATION`.
- Decisões com rationale e alternativas registradas.

### Phase 1 - Package Skeleton & Workspace Isolation

**Objective**: Criar esqueleto do pacote e API mínima para criação/validação de workspace sem tocar configuração pessoal.

**Affected files**:
- `emacs-a11y-setup.el`
- `lisp/emacs-a11y-setup-workspace.el`
- `lisp/emacs-a11y-setup-profiles.el`

**Key decisions**:
- Definir variável configurável de caminho do workspace por plataforma.
- Criar estrutura mínima: `init.el`, `custom.el`, `config/`, `profiles/`, `logs/`, `reports/`, `backups/`.
- `init.el` do workspace carrega setup/módulos essenciais e nunca referencia `~/.emacs.d`/`~/.config/emacs`.

**Tests**:
- Criação de workspace em diretório temporário.
- Geração de `init.el` e `custom.el` no workspace.
- Preservação de configuração pessoal padrão.

**Risks**:
- Escrita em caminho inválido/não gravável.
- Reexecução de criação com estado parcial.

**Exit criteria**:
- Função pública `emacs-a11y-setup-create-workspace` funcional e idempotente.
- Estrutura mínima criada/validada com testes ERT.

### Phase 2 - Handoff Contract & Bootstrap Entry

**Objective**: Implementar entrada estável para bootstrap externo com validação acessível de contrato.

**Affected files**:
- `lisp/emacs-a11y-setup-handoff.el`
- `emacs-a11y-setup.el`
- `docs/handoff-contract.md`
- `specs/001-migracao-modulos-config-workspace/contracts/handoff-contract.md`
- `specs/001-migracao-modulos-config-workspace/contracts/handoff-contract.schema.json`

**Key decisions**:
- Campos obrigatórios: `contract_version`, `platform`, `bootstrap_mode`, `workspace_path`.
- Campos opcionais aceitos sem bloquear fluxo.
- Erros de contrato retornam mensagem textual clara e status de falha adequado em batch.

**Tests**:
- Handoff válido.
- Falha sem `contract_version`.
- Falha por versão incompatível.
- Falha por `workspace_path` ausente/inválido.
- Fluxo com opcionais ausentes.

**Risks**:
- Evolução de versão do contrato sem compatibilidade reversa.
- Entradas incompletas vindas de bootstrap externo.

**Exit criteria**:
- Função pública `emacs-a11y-setup-bootstrap` implementada e testada.
- Contrato publicado e versionado.

### Phase 3 - Module Registry, Profiles & Resilient Loading

**Objective**: Registrar módulos essenciais/opcionais, aplicar perfil padrão e garantir carregamento resiliente.

**Affected files**:
- `lisp/emacs-a11y-setup-modules.el`
- `lisp/emacs-a11y-setup-profiles.el`
- `emacs-a11y-setup.el`

**Key decisions**:
- Núcleo mínimo ativo por padrão: base, acessibilidade, navegação básica, dired básico e shell básico seguro.
- Opcionais inventariados/desabilitados por padrão: Java, Java LSP, LaTeX, GPTel/IA, layout IDE avançado.
- Falha em módulo opcional gera aviso e não bloqueia doctor/painel.

**Tests**:
- Carregamento de módulos essenciais.
- Falha simulada de módulo opcional sem bloquear diagnóstico.
- Perfil padrão sem módulos que exigem credencial.

**Risks**:
- Dependências implícitas entre módulos legados.
- Regressão de inicialização por ordem de carregamento.

**Exit criteria**:
- Funções públicas `emacs-a11y-setup-first-run` e `emacs-a11y-setup-open-dashboard` operacionais.
- Perfil padrão aplicado com sucesso em primeiro uso.

### Phase 4 - Doctor, Reports & Batch Diagnostics

**Objective**: Implementar diagnóstico interno completo, acessível e exportável.

**Affected files**:
- `lisp/emacs-a11y-setup-doctor.el`
- `emacs-a11y-setup.el`

**Key decisions**:
- Relatório textual conterá timestamp, versão, workspace, perfil, resultado de handoff, status de módulos, falhas/avisos e próximos passos.
- `emacs-a11y-setup-doctor-batch` retorna status compatível com automação.

**Tests**:
- Geração de relatório textual.
- Verificações de workspace, permissões, módulos, Emacspeak/TTS.
- Escrita de logs e relatórios.

**Risks**:
- Ambiguidade de severidade entre aviso e falha.
- Exposição de dados sensíveis em logs.

**Exit criteria**:
- Funções públicas `emacs-a11y-setup-doctor` e `emacs-a11y-setup-doctor-batch` implementadas.
- Relatório acessível e acionável gerado em `reports/`.

### Phase 5 - Legacy Module Migration Documentation

**Objective**: Produzir inventário inicial e plano de migração gradual dos módulos legados do repositório histórico.

**Affected files**:
- `docs/migration-from-emacs-a11y.md`
- `specs/001-migracao-modulos-config-workspace/data-model.md`

**Key decisions**:
- Inventariar 13 módulos legados do `init.el` histórico.
- Registrar decisão por item: migrar, adaptar, adiar ou descartar.

**Tests**:
- Revisão de consistência documental com spec/plan/contrato.

**Risks**:
- Migração prematura de módulos avançados fora de escopo.

**Exit criteria**:
- Inventário completo com status e justificativa por módulo.
- Dependências externas e riscos explícitos por item.

### Phase 6 - Software Project Documentation in PlantUML

**Objective**: Produzir artefatos de documentação de projeto de software em PlantUML/Markdown na pasta `docs/` com rastreabilidade para `spec.md`, requisitos e testes.

**Affected files**:
- `docs/README.md`
- `docs/use-case-global.puml`
- `docs/use-cases.md`
- `docs/sequence/first-run-workspace.puml`
- `docs/sequence/bootstrap-handoff.puml`
- `docs/sequence/internal-doctor.puml`
- `docs/sequence/module-loading.puml`
- `docs/sequence/module-migration-inventory.puml`

**Key decisions**:
- Caso de uso global delimita claramente escopo interno do setup e fronteira com installer/distribuição.
- Casos de uso textuais cobrem user stories P1 e P2 com objetivo, atores, pré-condições, fluxo principal, alternativos, pós-condições, regras, critérios de aceite e FR relacionados.
- Diagramas de sequência cobrem fluxos críticos: primeiro uso, handoff, doctor, carregamento resiliente e inventário de migração.

**Tests**:
- Validação sintática de todos os arquivos PlantUML.
- Revisão de rastreabilidade entre user stories, casos de uso, FR e testes ERT.

**Risks**:
- Divergência entre documentação e comportamento planejado das APIs públicas.
- Diagramas ficarem genéricos sem refletir fronteiras de escopo.

**Exit criteria**:
- Todos os artefatos em `docs/` criados e consistentes com `spec.md`/`plan.md`.
- `docs/README.md` lista e contextualiza todos os artefatos.
- Fronteira de escopo entre `emacs-a11y-setup`, `emacs-a11y-installer` e distribuição explícita e inequívoca.

### Phase 7 - Test Suite and Validation

**Objective**: Consolidar suíte ERT, execução batch e validação de cobertura funcional e documental antes de `speckit.tasks`.

**Affected files**:
- `test/*.el`
- `README.md` (instruções de execução)
- `specs/001-migracao-modulos-config-workspace/quickstart.md`

**Key decisions**:
- Comando padrão de testes batch documentado em quickstart.
- Critérios de aceite vinculados a FR/SC da spec.

**Tests**:
- Execução completa `emacs --batch` da suíte ERT.
- Verificação de isolamento de configuração pessoal.
- Verificação de cobertura de user stories P1/P2 pelos casos de uso textuais.
- Verificação de cobertura dos fluxos críticos pelos diagramas de sequência.

**Risks**:
- Flakiness em testes com sistema de arquivos temporário.

**Exit criteria**:
- Todos os testes centrais estáveis.
- Critérios de testabilidade da documentação atendidos.

### Phase 8 - Constitutional and Governance Review

**Objective**: Revisão final de conformidade constitucional e de governança antes da geração de tarefas.

**Affected files**:
- `specs/001-migracao-modulos-config-workspace/plan.md`
- `specs/001-migracao-modulos-config-workspace/quickstart.md`
- `docs/README.md`

**Key decisions**:
- Registrar aderência a documentação aberta, versionada e reprodutível com PlantUML/Markdown.
- Confirmar rastreabilidade entre stories, casos de uso, FR, diagramas e testes.

**Tests**:
- Checklist de conformidade constitucional e de escopo fora de implementação.

**Risks**:
- Drift de escopo para itens explicitamente fora da feature.

**Exit criteria**:
- Constitution Check pós-design em estado PASS.
- Plano pronto para `speckit.tasks` sem pendências abertas.

## Documentation Testability Criteria

- Todos os arquivos PlantUML em `docs/` MUST estar sintaticamente válidos.
- Casos de uso textuais MUST cobrir todas as user stories P1 e P2 do `spec.md`.
- Diagramas de sequência MUST cobrir primeiro uso, handoff, doctor e carregamento resiliente de módulos.
- O caso de uso global MUST explicitar limite de escopo entre `emacs-a11y-setup` e `emacs-a11y-installer`.
- `docs/README.md` MUST listar todos os artefatos produzidos e seus vínculos com spec/plan/testes.
- Linguagem documental MUST ser clara, acessível e tecnicamente rastreável.

## Constitution Check (Post-Design Re-evaluation)

- Acessibilidade: PASS - comandos/relatórios textuais com linguagem acionável.
- Emacs/Emacspeak: PASS - foco em Emacs Lisp e validação de estado Emacspeak no doctor.
- Separação installer/setup: PASS - interface estável de handoff sem lógica de installer no pacote.
- Workspace isolado: PASS - criação/reparo dentro de workspace separado e proteção de configuração pessoal.
- Handoff versionado/baixo acoplamento: PASS - schema versionado com obrigatórios/opcionais e validação.
- Política multi-repositório: PASS - migração gradual documentada e consumo por contratos públicos.
- Diagnóstico antes de mutações: PASS - doctor integrado aos fluxos de primeiro uso/bootstrap.
- Logs e relatórios acessíveis: PASS - saídas textuais e estrutura dedicada no workspace.
- Segurança e preservação de configuração pessoal: PASS - sem alteração padrão fora do workspace.
- Modularidade: PASS - separação por módulos e perfil padrão conservador.
- Testes: PASS - suíte ERT cobrindo workspace, handoff, doctor, perfis e módulos.
- Documentação aberta e versionada: PASS - artefatos em Markdown e PlantUML planejados na pasta `docs/`.
- Documentação reprodutível com PlantUML: PASS - diagramas textuais versionáveis e validáveis.
- Rastreabilidade: PASS - vínculo explícito entre user stories, casos de uso, requisitos, sequências e testes.
- Separação setup/installer/distribuição: PASS - fronteiras de escopo explícitas nos casos de uso e sequências.

## Documentation Deliverables in docs/

- `docs/use-case-global.puml`: caso de uso global com atores e fronteiras de escopo.
- `docs/use-cases.md`: casos de uso textuais UC01-UC12 com rastreabilidade para FR/aceite.
- `docs/sequence/first-run-workspace.puml`: sequência de primeiro uso e criação/validação de workspace.
- `docs/sequence/bootstrap-handoff.puml`: sequência de handoff com bootstrap externo.
- `docs/sequence/internal-doctor.puml`: sequência de diagnóstico interno e relatório.
- `docs/sequence/module-loading.puml`: sequência de carregamento resiliente de módulos.
- `docs/sequence/module-migration-inventory.puml`: sequência de inventário/classificação de módulos legados.
- `docs/README.md`: índice documental e relação com spec/plan/testes.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| Nenhuma | N/A | N/A |
