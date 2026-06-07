# Research: Gestao de Pacotes Comunitarios A11yDevs

## Decision 1: manter monorepo `A11yDevs/emacs-a11y-setup` nesta fase

- Decision: a distribuicao modular de pacotes Emacs Lisp sera organizada no mesmo repositorio `https://github.com/A11yDevs/emacs-a11y-setup`.
- Rationale: reduz custo operacional inicial, centraliza governanca e permite evolucao incremental sem overhead de multiplos repositorios.
- Alternatives considered: criar repositorio por pacote desde o inicio. Rejeitado por aumentar custo de manutencao, versionamento e coordenacao prematuramente.

## Decision 2: split por repositorio vira opcao futura

- Decision: extracao de pacote para repositorio proprio so ocorre quando houver ciclo de vida, documentacao, issues, versionamento e base de usuarios proprios.
- Rationale: evita fragmentacao precoce e preserva foco em estabilizacao da distribuicao modular.
- Alternatives considered: policy de split imediato por dominio. Rejeitado por baixa maturidade inicial dos pacotes.

## Decision 3: separar fonte Lisp de consumidores legados

- Decision: a fonte principal dos pacotes passa a ser `lisp/` no monorepo; quaisquer consumidores legados (ex.: pipelines de empacotamento) devem ser atualizados para consumir artefatos de `lisp/` ou documentar mapeamento de migração.
- Rationale: evita duplicacao manual e define uma unica fonte de verdade para codigo Emacs Lisp.
- Alternatives considered: manter fonte principal no layout de consumidores legados. Rejeitado por dificultar instalacao modular via `package-vc-install`.

## Decision 4: um pacote por subdiretorio em `lisp/`

- Decision: cada subdiretorio de `lisp/` representa um pacote instalavel independentemente, com arquivo principal de mesmo nome do pacote.
- Rationale: mapeamento direto para `:lisp-dir` e `:main-file` simplifica instalacao e validacao.
- Alternatives considered: varios pacotes compartilhando diretorio unico. Rejeitado por aumentar acoplamento e ambiguidade.

## Decision 5: pacote agregador `a11y-emacs`

- Decision: `a11y-emacs` e o pacote de entrada simplificada e deve carregar/depender do conjunto base (`a11y-core`, `a11y-accessibility`, `a11y-navigation`, `a11y-completion`).
- Rationale: oferece onboarding simples sem remover composicao modular para usuarios avancados.
- Alternatives considered: somente instalacao pacote a pacote. Rejeitado por piorar experiencia inicial.

## Decision 6: opcionais isolados por dependencia minima

- Decision: pacotes opcionais (`a11y-java`, `a11y-java-lsp`, `a11y-gptel`, `a11y-shell`, `a11y-dired`, `a11y-layout`, `a11y-layout-ide`) devem instalar isoladamente, sem exigir modulos nao relacionados.
- Rationale: reduz acoplamento e permite adocao incremental por necessidade real.
- Alternatives considered: opcionais com dependencia implicita do conjunto completo. Rejeitado por contrariar objetivo modular.

## Decision 7: padrao minimo de metadados/autoload/customizacao

- Decision: cada pacote deve conter cabecalho padrao (`lexical-binding`, `Author`, `Version`, `Package-Requires`, `Keywords`, `URL`, `Commentary`, `Code`, `provide`, linha final), alem de `;;;###autoload` e `defgroup`/`defcustom` quando aplicavel.
- Rationale: garante compatibilidade com ecossistema de pacotes Emacs e melhora descobribilidade/configurabilidade.
- Alternatives considered: metadados parciais e padrao relaxado. Rejeitado por reduzir confiabilidade de instalacao e manutencao.

## Decision 8: nao converter automaticamente `init-*.el`

- Decision: o plano exige separacao previa de responsabilidades (configuracao de usuario, biblioteca reutilizavel, comandos interativos, opcoes customizaveis, integracoes externas e inicializacao completa) antes de empacotar.
- Rationale: evita transformar scripts de inicializacao em bibliotecas acopladas e frageis.
- Alternatives considered: renomeacao direta de arquivos `init-*.el`. Rejeitado por alto risco arquitetural.

## Decision 9: modulo de setup de pacotes nao vira pacote comum

- Decision: modulo responsavel por configurar o proprio sistema de pacotes do Emacs fica fora da malha de pacotes distribuiveis comuns.
- Rationale: evita dependencia circular no bootstrap de instalacao.
- Alternatives considered: tratar modulo de package setup como pacote comum. Rejeitado por risco de deadlock de dependencia.

## Decision 10: validacao orientada por exemplos reais de instalacao

- Decision: o planejamento inclui exemplos canonicos com `package-vc-install`, `require` e `use-package` como baseline de verificacao.
- Rationale: transforma requisito arquitetural em criterio objetivo e reproduzivel.
- Alternatives considered: validacao apenas conceitual sem exemplos executaveis. Rejeitado por baixa testabilidade.
