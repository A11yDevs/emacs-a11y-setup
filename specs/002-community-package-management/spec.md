# Feature Specification: Gestão de Pacotes Comunitários A11yDevs

**Feature Branch**: `002-community-package-management`

**Created**: 2026-06-07

**Status**: Draft (tasks updated — validates and governance checks added)

**Input**: User description: "Nova feature de gerenciamento de pacotes comunitários A11yDevs usando package-vc-install no emacs-a11y-setup."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Operar ciclo básico de pacotes (Priority: P1)

Como pessoa usuária do emacs-a11y-setup, quero instalar um pacote Emacs Lisp comunitário específico diretamente do repositório A11yDevs via package-vc-install, para usar apenas o componente necessário sem copiar arquivos manualmente.

**Why this priority**: Sem instalação modular individual, a proposta de distribuição comunitária não entrega autonomia nem reduz fricção de adoção.

**Independent Test**: Pode ser testada instalando um pacote individual via package-vc-install, carregando com require e validando que não houve cópia manual de arquivos.

**Acceptance Scenarios**:

1. **Given** que um pacote comunitário válido da organização A11yDevs está disponível, **When** a pessoa executa o comando de instalação, **Then** o pacote fica no estado instalado e aparece na listagem com metadados essenciais.
2. **Given** que a instalação foi concluída, **When** a pessoa carrega o pacote com `(require 'nome-do-pacote)`, **Then** o carregamento ocorre sem erro.
3. **Given** que o pacote está disponível no repositório comunitário, **When** a pessoa realiza a instalação, **Then** o fluxo não exige cópia manual de arquivos Lisp.

---

### User Story 2 - Instalar ambiente agregado ou componentes opcionais (Priority: P2)

Como pessoa usuária iniciante ou avançada, quero instalar tanto o pacote agregador a11y-emacs quanto pacotes opcionais isolados, para escolher entre experiência simplificada e composição modular.

**Why this priority**: O pacote agregador acelera adoção para iniciantes e a instalação isolada preserva flexibilidade para perfis avançados.

**Independent Test**: Pode ser testada instalando o pacote a11y-emacs em um ambiente limpo e, separadamente, instalando apenas um pacote opcional sem o agregador.

**Acceptance Scenarios**:

1. **Given** que o pacote agregador a11y-emacs está publicado no repositório comunitário, **When** a pessoa executa a instalação, **Then** o ambiente acessível principal é instalado por um único pacote.
2. **Given** que um pacote opcional (como Java, LSP, terminal, navegação, complementação ou integração com IA) está publicado, **When** a pessoa instala somente esse pacote, **Then** a instalação ocorre de forma isolada sem exigir instalação prévia de todos os opcionais.

---

### User Story 3 - Implantar monorepo de pacotes Lisp (Priority: P3)

Como mantenedora/mantenedor do repositório, quero que o monorepo `A11yDevs/emacs-a11y-setup` (ex.: https://github.com/A11yDevs/emacs-a11y-setup/tree/main/lisp) seja a fonte primária dos pacotes Lisp, com estrutura clara de `lisp/<package>/` e convenções de metadados, para permitir instalação direta via `package-vc-install` e extração futura quando apropriado.

**Why this priority**: Consolidar a fonte única facilita colaboração, testes automáticos e reduz ambiguidade sobre onde os pacotes residem.

**Independent Test**: Validar que cada pacote no monorepo segue a convenção de layout (`lisp/<package>/<package>.el`), possui `Package-Requires`, `provide` e `README.md` mínimo; e que `package-vc-install` consegue instalar pelo menos um pacote apontando para o monorepo `:lisp-dir`.

**Acceptance Scenarios**:

1. **Given** o monorepo com `lisp/<package>` organizado, **When** a pessoa chama `package-vc-install` com `:lisp-dir` apontando para o subdiretório do pacote, **Then** a instalação conclui e `(require 'nome-do-pacote)` funciona.
2. **Given** um pacote no monorepo sem `Package-Requires` ou `README.md`, **When** a pessoa tenta instalar, **Then** a validação falha e o pacote é listado como não conforme até correção de metadados.
### Edge Cases

- Tentativa de instalar pacote inexistente no monorepo deve retornar erro acionável sem exigir busca manual de caminhos internos.
- Instalação repetida do mesmo pacote deve ser idempotente e não duplicar metadados.
- Pacote sem metadados obrigatórios deve ser rejeitado com diagnóstico claro.
- Pacote sem documentação mínima deve ser sinalizado como não aderente ao padrão de distribuição.
- Instalação do agregador a11y-emacs não deve impedir a instalação isolada posterior de opcionais.
 - Reorganização modular não deve quebrar consumidores documentados; migração de consumidores legados está fora do escopo inicial.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: O sistema MUST permitir distribuição modular dos componentes Emacs Lisp da comunidade A11yDevs como pacotes instaláveis via package-vc-install.
- **FR-002**: O sistema MUST permitir instalação individual de cada pacote comunitário publicado no repositório A11yDevs sem exigir instalação do conjunto completo.
- **FR-003**: O sistema MUST disponibilizar um pacote agregador chamado a11y-emacs para instalação simplificada do ambiente acessível principal.
- **FR-004**: O sistema MUST permitir instalação isolada de pacotes opcionais, incluindo módulos de Java, LSP, terminal, navegação, complementação e integração com IA.
- **FR-005**: O sistema MUST exigir que cada pacote tenha metadados compatíveis com o sistema de pacotes do Emacs.
- **FR-006**: O sistema MUST exigir documentação mínima de instalação e uso para cada pacote distribuído.
- **FR-007**: O sistema MUST permitir instalação de pacote sem cópia manual de arquivos Lisp pelo usuário.
 - **FR-008**: O sistema MUST manter a estratégia inicial em monorepo nesta fase e MUST NOT exigir criação de repositório separado por pacote.
 - **FR-009**: O sistema MUST tratar repositórios separados como possibilidade futura e não como pré-requisito para esta entrega.
- **FR-011**: O sistema MUST manter rastreabilidade entre pacote, metadados e documentação mínima para validação de conformidade.
- **FR-012**: O sistema MUST limitar a reorganização inicial aos módulos com responsabilidades claramente separadas e MUST NOT converter automaticamente todos os arquivos init-*.el em pacotes nesta etapa.

### Key Entities *(include if feature involves data)*

- **Pacote Comunitario A11yDevs**: unidade modular instalavel a partir do monorepo da comunidade, com nome, escopo, metadados de pacote e documentacao minima.
- **Pacote Agregador a11y-emacs**: pacote principal que reune a instalacao simplificada do ambiente acessivel base.
- **Pacote Opcional**: unidade modular complementar (como Java, LSP, terminal, navegacao, complementacao e IA) instalavel de forma independente.
- **Manifesto de Metadados**: conjunto de informacoes exigidas pelo sistema de pacotes do Emacs para reconhecer, instalar e carregar cada pacote.
 - **Monorepo Package Layout**: convenção e evidências (estrutura `lisp/<package>/`, `Package-Requires`, `provide`, `README.md`) que comprovam que o monorepo é a fonte canônica dos pacotes.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100% dos pacotes comunitarios elegiveis no escopo inicial podem ser instalados individualmente via package-vc-install em ambiente suportado.
- **SC-002**: 100% dos pacotes instalados individualmente podem ser carregados com `(require 'nome-do-pacote)` sem erro de resolucao do pacote.
- **SC-003**: O pacote agregador a11y-emacs pode ser instalado e reconhecido em 100% dos testes de aceitacao do fluxo simplificado.
- **SC-004**: Pelo menos um pacote opcional pode ser instalado de forma isolada, sem depender da instalacao previa de todos os opcionais, em 100% dos cenarios de teste definidos.
- **SC-005**: 100% dos pacotes publicados no escopo desta feature apresentam metadados compativeis com o sistema de pacotes do Emacs e documentacao minima de instalacao e uso.
 - **SC-006**: 100% dos pacotes no escopo desta feature atendem aos critérios de metadados e podem ser instalados via `package-vc-install` apontando para o monorepo.

## Assumptions

- O repositorio comunitario A11yDevs mantera os componentes Lisp candidatos em estrutura de monorepo `lisp/` durante esta fase; `packages/emacs-a11y-config` nao e mais o target primario de desenvolvimento.
- A reorganizacao sera incremental e NAO HAVERA migracao automatica cega dos `init-*.el`.
- Pessoas usuarias terao acesso ao repositorio Git comunitario para instalacao dos pacotes modulares.

## Acceptance Criteria *(mandatory)*

- Instalacao de um pacote individual via package-vc-install concluida com sucesso em ambiente suportado.
- Carregamento do pacote instalado com `(require 'nome-do-pacote)` concluido sem erro.
- Instalacao do pacote agregador a11y-emacs concluida e reconhecida no ambiente.
- Instalacao isolada de ao menos um pacote opcional concluida sem dependencia de instalacao de todos os opcionais.
- Presenca de documentacao minima de instalacao e uso em cada pacote incluido no escopo da feature.
 

## Constraints

- Nao criar repositorios separados para cada pacote nesta fase.
- Manter a estrategia inicial em monorepo.
- Tratar repositorios separados apenas como possibilidade futura.
- Nao implementar codigo de produção nesta etapa sem revisão adequada; esta entrega pode, contudo, incluir artefatos de verificação e validação (checklists, ERT tests, auditorias de `Package-Requires` e scripts de auditoria para `init-*.el`) para suportar a especificação e testes automatizados. Implementações de código (mudanças em `lisp/`) devem seguir o processo normal de revisão de código e CI descrito pelo projeto.
- Nao transformar automaticamente todos os arquivos init-*.el em pacotes antes da separacao de responsabilidades.

## Spec/Tasks sync note

As tarefas em `specs/002-community-package-management/tasks.md` foram atualizadas para incluir validações automatizadas e tarefas de governança (T029..T030) — criação de checklists para `Package-Requires`, auditoria de `init-*.el` e padronização/remoção de duplicações no arquivo de tasks. Mudanças de código resultantes dessas validações devem seguir o processo normal de revisão de código e CI do projeto.

## Constitution Alignment *(mandatory)*

- **CA-001 Accessibility**: Todos os comandos fornecem saída textual linear, legível por leitor de tela, sem caminho crítico dependente de GUI; confirmações e erros são descritos com linguagem acionável.
- **CA-002 Emacs/Emacspeak**: O gerenciamento de pacotes comunitários ocorre no fluxo nativo do Emacs, preservando feedback auditivo estruturado e sem exigir navegação fora do ambiente principal.
- **CA-003 Platform scope**: O comportamento é definido de forma equivalente para Windows nativo, Linux, macOS, Android/Termux e WSL; diferenças de suporte externo ficam encapsuladas e não alteram semântica dos comandos.
- **CA-004 Workspace isolation**: A feature opera no workspace isolado do emacs-a11y e não altera `~/.emacs.d` nem `~/.config/emacs` por padrão.
- **CA-005 Diagnostics-first**: Validações de origem, disponibilidade e estado são executadas antes de mutações; falhas interrompem operação de forma segura com orientação clara.
- **CA-006 Modularity and maintainability**: Comandos públicos e lógica de estado são separados por responsabilidade, com regras idempotentes e pontos de extensão para novos pacotes comunitários.
- **CA-007 Evidence and governance**: A especificação define critérios de confiança e logging auditável, fornecendo base para testes, documentação e revisão de risco.
- **CA-008 Installer/setup architecture**: A feature permanece no domínio do emacs-a11y-setup; não altera o contrato mínimo de handoff do installer, apenas adiciona capacidade interna de gerenciamento de pacotes.
- **CA-009 Base core mínima e escopo dinâmico**: A feature assume uma base core mínima previamente instalada, trata sua ausência como condição de pré-requisito e limita seu ciclo de gestão aos pacotes comunitários A11yDevs, sem depender de modos de instalação.
- **CA-010 Bootstrap acceptance**: A feature não redefine critérios de bootstrap; adiciona pós-bootstrap seguro com mensagens de recuperação para falhas de rede/repositório e validação explícita de origem.
