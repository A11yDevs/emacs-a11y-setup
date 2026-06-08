# Research: 001-migracao-modulos-config-workspace

## Decisão 1: Estrutura base do pacote Emacs Lisp
- Decisão: organizar o pacote com `emacs-a11y-setup.el` na raiz, módulos em `lisp/` e testes ERT em `test/`.
- Racional: é o padrão mais comum no ecossistema Emacs Lisp, facilita `load-path`, byte-compilation em batch e manutenção incremental.
- Alternativas consideradas:
  - Estrutura monolítica em um único arquivo: rejeitada por reduzir modularidade.
  - Framework de teste externo: rejeitado por aumentar acoplamento desnecessário.

## Decisão 2: Modo batch e status de execução
- Decisão: definir entradas públicas compatíveis com execução `emacs --batch`, com retorno de status por código de saída e relatório textual.
- Racional: integração robusta com bootstrap externo, execução automatizável e diagnóstico acessível.
- Alternativas consideradas:
  - Apenas mensagens em buffer interativo: rejeitada por não atender automação.
  - Falha sem mapeamento de status: rejeitada por dificultar troubleshooting.

## Decisão 3: Workspace separado e isolamento
- Decisão: workspace padrão isolado em caminho dedicado por plataforma, com estrutura mínima `init.el`, `custom.el`, `config/`, `profiles/`, `logs/`, `reports/`, `backups/`; `early-init.el` será criado em versão mínima já nesta feature.
- Racional: reduz risco de regressão sobre configuração pessoal e prepara evolução semântica do workspace desde o início.
- Alternativas consideradas:
  - Adiar `early-init.el`: rejeitada por empurrar dívida técnica de inicialização.
  - Reutilizar diretórios pessoais: rejeitada por violar isolamento constitucional.

## Decisão 4: Contrato de handoff versionado
- Decisão: usar contrato de handoff versionado em JSON, com campos obrigatórios (`contract_version`, `platform`, `bootstrap_mode`, `workspace_path`) e opcionais documentados.
- Racional: JSON é simples, testável e interoperável com repositórios externos.
- Alternativas consideradas:
  - Argumentos ad hoc sem schema: rejeitada por baixa robustez.
  - Dependência de layout interno do workspace: rejeitada por violar baixo acoplamento.

<!-- Decisão 5 (migração de módulos legados) removida: migração de módulos legados não será realizada nesta feature. -->

## Decisão 6: Núcleo mínimo da feature
- Decisão: habilitar no perfil padrão somente módulos essenciais (núcleo, acessibilidade, navegação básica, dired básico e shell básico seguro), mantendo Java/Java LSP/LaTeX/GPTel/layout IDE como opcionais desabilitados.
- Racional: onboarding seguro e acessível, sem exigir credenciais ou dependências avançadas.
- Alternativas consideradas:
  - Perfil padrão com módulos avançados: rejeitada por risco de quebra e complexidade.

## Decisão 7: Diagnóstico interno e relatórios
- Decisão: implementar doctor interativo e batch com relatório textual acessível em `reports/` e logs em `logs/`.
- Racional: atende diagnóstico-first e facilita suporte reprodutível.
- Alternativas consideradas:
  - Diagnóstico apenas em memória: rejeitada por baixa rastreabilidade.
  - Relatórios não textuais: rejeitada por impacto de acessibilidade.
