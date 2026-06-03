<!--
Sync Impact Report
- Version change: 1.0.0 -> 1.1.0
- Modified principles:
  - II. Integração nativa com Emacs e Emacspeak -> II. Integração nativa com Emacs, Emacspeak e painel interno de controle
  - III. Bootstrap progressivo e multiplataforma -> III. Bootstrap progressivo, falante funcional e multiplataforma
  - IX. Arquitetura modular -> IX. Arquitetura modular por componentes do ecossistema
  - X. Qualidade, testes e manutenção -> X. Qualidade, testes de bootstrap e manutenção
- Added sections:
  - Política de modos de instalação
  - Critérios mínimos de bootstrap funcional por plataforma (Governance)
- Removed sections:
  - Nenhuma
- Templates requiring updates:
  - ✅ updated: .specify/templates/plan-template.md
  - ✅ updated: .specify/templates/spec-template.md
  - ✅ updated: .specify/templates/tasks-template.md
  - ✅ updated: README.md
  - ⚠ pending: .specify/templates/commands/*.md (diretório inexistente no repositório)
- Follow-up TODOs:
  - Nenhum
-->

# emacs-a11y-setup Constitution

## Core Principles

### I. Acessibilidade como requisito central
* Toda funcionalidade MUST ser plenamente utilizável por teclado e MUST fornecer mensagens, menus, diagnósticos e relatórios compreensíveis por leitores de tela.
* O projeto MUST evitar dependência exclusiva de interfaces gráficas e MUST priorizar experiências adequadas para pessoas cegas ou com baixa visão desde as primeiras etapas de instalação e diagnóstico.

Rationale: acessibilidade tardia gera barreiras estruturais e inviabiliza autonomia de uso.

### II. Integração nativa com Emacs, Emacspeak e painel interno de controle
* O Emacs MUST ser o ambiente principal de interação e o Emacspeak MUST ser tratado como componente central de feedback auditivo estruturado.
* O projeto MUST privilegiar experiência auditiva contextualizada, e não apenas leitura superficial de tela.
* O emacs-a11y-setup MUST ser o pacote Emacs Lisp principal e MUST atuar como painel de controle acessível dentro do Emacs já instalado.
* O emacs-a11y-setup MUST prover diagnóstico contínuo, configuração assistida, personalização de voz e idioma, ajuste de TTS/servidores, perfis, reparos de configuração, exportação de relatórios e orientação contextual no Emacs.
* O emacs-a11y-setup MUST NOT depender de o usuário navegar manualmente por um Emacs ainda não acessível.

Rationale: o fluxo nativo melhora consistência, ergonomia auditiva e capacidade de suporte.

### III. Bootstrap progressivo, falante funcional e multiplataforma
* O ecossistema MUST ser composto por pelo menos dois componentes principais: emacs-a11y-installer (bootstrap externo) e emacs-a11y-setup (camada interna no Emacs).
* O emacs-a11y-installer MUST ser responsável por levar o usuário até um Emacs falante funcional sempre que a plataforma permitir.
* O modo recomendado de instalação MUST entregar Emacs com fala funcional sempre que possível; quando isso não for viável automaticamente, o bootstrap MUST fornecer diagnóstico claro, instruções acessíveis e caminho de recuperação por terminal ou log.
* O sucesso mínimo do bootstrap MUST ser abrir o ambiente Emacs Acessível por launcher ou comando documentado usando workspace separado.
* O suporte MUST seguir a ordem de foco: Windows nativo, Debian/Ubuntu, macOS, Android/Termux e WSL.
* VMs MUST ser alternativa pedagógica/fallback, nunca a única forma de uso.
* Diferenças de plataforma MUST ser encapsuladas em módulos específicos.

Rationale: adoção ampla exige entrada simples com evolução incremental.

### IV. Segurança, isolamento e transparência
* Comandos destrutivos MUST exigir confirmação explícita.
* O usuário MUST conseguir inspecionar o que será instalado, alterado ou configurado antes da execução.
* Arquivos pessoais como init.el, early-init.el, custom.el e diretórios pessoais de configuração MUST NOT ser sobrescritos.
* Scripts e fluxos de bootstrap/setup MUST registrar logs acessíveis e compreensíveis.
* O projeto MUST usar workspace separado por padrão, e qualquer integração com configuração pessoal MUST ser opcional, explícita, reversível, documentada e precedida de backup.

Rationale: proteger dados e reduzir regressão em ambientes reais de estudo e trabalho.

### V. Diagnóstico antes de instalação
* Sempre que viável, o projeto MUST diagnosticar o ambiente antes de instalar ou alterar configurações.
* O toolkit MUST prover comandos doctor/check para validar Emacs, Emacspeak, TTS, servidores de fala, dependências de sistema, permissão, áudio, shell, ambiente terminal/gráfico e estado de configuração.
* Relatórios MUST ser acionáveis, acessíveis e diferenciados por plataforma.
* Diagnósticos de bootstrap MUST ser tratados como parte do conceito de instalação concluída.

Rationale: diagnóstico preventivo reduz falhas acumuladas e suporte reativo.

### VI. Software livre, documentação aberta e reprodutibilidade
* O projeto MUST priorizar ferramentas livres e abertas.
* Configurações relevantes MUST ser documentadas e versionadas com exemplos reutilizáveis.
* Instalações MUST ser reproduzíveis e testáveis.
* Provas de conceito, incluindo Emacspeak no Android/Termux, MUST ser registradas e evoluídas gradualmente para fluxo suportado quando atenderem critérios de manutenção e validação.

Rationale: transparência e continuidade dependem de conhecimento aberto e rastreável.

### VII. Simplicidade para iniciantes e extensibilidade para avançados
* O fluxo principal MUST ser simples para estudantes iniciantes.
* Usuários avançados MUST poder customizar TTS, servidores de fala, linguagens, pacotes Emacs, ferramentas de desenvolvimento e scripts de inicialização.
* O projeto MUST separar claramente modos assistido, automático e avançado.

Rationale: a mesma base precisa servir onboarding e evolução técnica sem bifurcar o produto.

### VIII. Desenvolvimento orientado por validação com usuários
* Decisões de UX e acessibilidade MUST considerar validação com pessoas cegas ou com baixa visão.
* Barreiras detectadas MUST ser registradas como issues, documentação ou casos de teste.
* O ciclo de entrega MUST favorecer iterações curtas de implementação, validação e melhoria.

Rationale: requisitos de acessibilidade só se sustentam quando testados em uso real.

### IX. Arquitetura modular por componentes do ecossistema
* Responsabilidades MUST ser separadas entre emacs-a11y-installer, emacs-a11y-setup, scripts de sistema, launchers por plataforma, workspace emacs-a11y, documentação, templates, testes e materiais pedagógicos.
* O projeto MUST evitar acoplamento excessivo entre plataformas, e cada backend de instalação/TTS/servidor de fala MUST ser extensível.
* Lógica para Windows nativo, Debian/Ubuntu, macOS, Android/Termux e WSL MUST residir em módulos separados.

Rationale: modularidade reduz impacto de mudanças e facilita manutenção.

### X. Qualidade, testes de bootstrap e manutenção
* Funcionalidades críticas MUST ter testes automatizados quando viável, e scripts MUST ser idempotentes sempre que possível.
* Erros MUST produzir mensagens claras com ação corretiva sugerida.
* Implementações MUST priorizar legibilidade, manutenção simples e evolução incremental, evitando automações frágeis dependentes de estado implícito do sistema do usuário.
* O emacs-a11y-installer MUST executar testes básicos de bootstrap: execução de Emacs em modo batch, criação do workspace separado, carregamento do init.el do workspace, instalação/localização do Emacspeak, carregamento de emacspeak-setup.el, presença de TTS/servidor inicial, teste mínimo de fala quando tecnicamente possível, verificação de launcher e geração de relatório acessível.

Rationale: estabilidade operacional e previsibilidade são partes do requisito de acessibilidade.

## Decisões arquiteturais iniciais

* O ecossistema do projeto MUST incluir, no mínimo, dois componentes principais: emacs-a11y-installer e emacs-a11y-setup.
* O emacs-a11y-installer MUST ser o bootstrap externo do projeto.
* O emacs-a11y-setup MUST ser o pacote Emacs Lisp principal para diagnóstico e configuração assistida dentro do Emacs.
* Scripts externos MUST ser usados quando necessários para bootstrap de plataforma, instalação do Emacs, instalação inicial do Emacspeak, dependências de sistema, TTS inicial e criação de launchers.
* Scripts externos SHOULD permanecer modulares e auditáveis, MUST ser idempotentes quando possível e MUST ser seguros.
* Scripts externos MUST NOT sobrescrever configurações pessoais do usuário e MUST registrar logs acessíveis.
* O emacs-a11y-installer MUST instalar ou preparar: Emacs, Emacspeak, dependências de sistema, TTS/servidor inicial, Git/curl/unzip (ou equivalentes), workspace separado, init.el do workspace, emacs-a11y-setup, launchers/atalhos e testes básicos.
* O emacs-a11y-installer MUST evitar se tornar um configurador completo do Emacs; seu foco principal MUST ser bootstrap, instalação inicial, validação e abertura do ambiente acessível.
* O projeto MUST usar por padrão um workspace separado para o ambiente emacs-a11y.
* O workspace separado MUST ser customizável pelo usuário e versionável quando apropriado.
* O projeto MUST fornecer formas simples de iniciar o Emacs com esse workspace.
* A ordem de foco inicial MUST ser: Windows nativo, Debian/Ubuntu, macOS, Android/Termux e WSL.
* Windows nativo MUST ser prioridade por maximizar alcance entre iniciantes.
* Debian/Ubuntu MUST ser a plataforma técnica de referência.
* macOS com Homebrew e servidor swiftmac MUST ser tratado como plataforma importante.
* Android/Termux MUST ser plataforma oficialmente considerada com base em PoCs reais.
* WSL MUST ser alternativa útil para usuários Windows, sem substituir suporte nativo.
* VMs/imagens prontas MAY ser usadas para ensino, demonstração e fallback.
* O projeto MUST NOT sobrescrever configurações pessoais sem backup e confirmação.
* O projeto MUST preferir isolamento, reversibilidade e transparência.

## Política de modos de instalação

* O ecossistema MUST oferecer os modos minimal, recommended e full.
* O modo minimal MUST instalar Emacs, workspace separado, emacs-a11y-setup e launcher; esse modo MAY não garantir Emacspeak completo e SHOULD ser usado para depuração e cenários especiais.
* O modo recommended MUST instalar Emacs, Emacspeak, TTS inicial, dependências principais, workspace separado, emacs-a11y-setup, launcher e testes básicos de bootstrap.
* O modo full MUST incluir tudo do recommended e adicionar perfis e ferramentas pedagógicas, como Java, LaTeX, Git, exemplos, tutoriais e módulos adicionais.
* O modo recommended MUST ser o padrão por reduzir a barreira inicial para usuários cegos.

## Política de workspace separado

* O ambiente emacs-a11y MUST ter diretório de configuração próprio.
* O usuário MUST poder editar esse ambiente sem afetar seu Emacs pessoal.
* Importação de configurações pessoais MUST ocorrer apenas por opção explícita.
* O projeto MAY fornecer mecanismos de exportação, backup e restauração.
* O workspace MUST suportar perfis, incluindo: iniciante, desenvolvimento Java, Emacspeak avançado, Termux, Windows nativo e oficina/curso.
* A configuração padrão MUST ser conservadora, acessível e segura.
* O modo recomendado de execução MUST iniciar o Emacs com diretório específico do emacs-a11y (por exemplo, emacs --init-directory ~/.emacs-a11y.d, emacs -q -l ~/.emacs-a11y.d/init.el ou launcher equivalente).
* O bootstrap MUST criar o workspace separado; o setup MUST mantê-lo, diagnosticar problemas nele e oferecer gestão de perfis.
* O projeto MUST NOT alterar ~/.emacs.d ou ~/.config/emacs por padrão.
* Integração com configurações pessoais MUST ser sempre opcional, explícita, reversível e documentada.

## Critérios de qualidade da constituição

* Todo artefato gerado por /speckit.specify, /speckit.plan, /speckit.tasks e /speckit.implement MUST declarar aderência explícita aos princípios desta constituição.
* Nenhum plano, especificação ou task list pode ser aprovado com conflito não justificado contra princípios de acessibilidade, isolamento, diagnóstico prévio, modularidade e qualidade.
* O Constitution Check MUST registrar evidências objetivas de conformidade, riscos e pendências antes de iniciar implementação.
* Toda exceção MUST conter justificativa técnica, impacto esperado, prazo de revisão e issue de acompanhamento vinculada.

## Governance

1. Escopo e precedência:
   * Esta constituição prevalece sobre guias operacionais locais em caso de conflito.
   * Toda mudança arquitetural relevante MUST atualizar esta constituição ou explicitar por que não a afeta.

2. Versionamento da constituição:
   * SemVer MUST ser usado em todas as emendas.
   * MAJOR: remoção/redefinição incompatível de princípio ou governança.
   * MINOR: adição de princípio, seção ou exigência normativa nova.
   * PATCH: clarificações sem alterar obrigações normativas.

3. Política de branches:
   * Branches de feature MUST seguir o padrão ###-slug-curto.
   * Trabalho direto na branch principal MUST NOT ocorrer para mudanças funcionais.

4. Revisão por Pull Request:
   * Toda alteração funcional MUST passar por PR.
   * Cada PR MUST incluir checklist de conformidade constitucional e impacto por plataforma (Windows nativo, Debian/Ubuntu, macOS, Android/Termux, WSL).
   * Mudanças no emacs-a11y-installer MUST documentar impacto de bootstrap por plataforma.

5. Criação de issues:
   * Novas funcionalidades, regressos e barreiras de acessibilidade MUST ser abertas como issues rastreáveis antes ou junto da implementação.
   * Issues MUST registrar contexto, plataforma, severidade, reprodução e resultado esperado.

6. Documentação obrigatória para novas funcionalidades:
   * Toda feature MUST atualizar ao menos especificação funcional, instruções de uso e notas de diagnóstico/limitações quando aplicável.

7. Critérios mínimos para nova plataforma:
   * MUST existir fluxo de bootstrap documentado e reproduzível.
   * MUST existir comando doctor/check com validações específicas da plataforma.
   * MUST existir evidência de teste real com leitores de tela/fluxo por teclado.
   * MUST existir avaliação de manutenção e responsável técnico definido.
   * MUST incluir avaliação de segurança e reversibilidade para alterações de instalação de sistema.

8. Critérios mínimos para novo sintetizador TTS/servidor de fala:
   * MUST haver integração com Emacs/Emacspeak documentada.
   * MUST haver fallback seguro e orientação de troubleshooting acessível.
   * MUST haver teste funcional básico e registro de limitações conhecidas.

9. Promoção de plataforma experimental para suportada:
   * MUST cumprir critérios de nova plataforma por pelo menos dois ciclos de release.
   * MUST apresentar redução de issues críticas abertas e cobertura de diagnóstico.
   * MUST possuir guia de uso estável e validação com usuários reais.

10. Critérios mínimos de bootstrap funcional por plataforma:
   * MUST instalar ou localizar Emacs.
   * MUST instalar ou localizar Emacspeak.
   * MUST configurar ou localizar TTS/servidor inicial.
   * MUST criar workspace separado.
   * MUST criar launcher ou comando de inicialização documentado.
   * MUST executar doctor/check básico.
   * MUST gerar log acessível.
   * MUST documentar limitações conhecidas.

11. Registro de provas de conceito e limitações conhecidas:
   * Toda PoC relevante MUST ser registrada com comando usado, ambiente, resultado, limites e próximos passos.
   * Limitações conhecidas MUST permanecer visíveis em documentação oficial.

12. Revisão de conformidade:
   * Em cada /speckit.plan e /speckit.tasks, o Constitution Check MUST ser revisado.
   * Não conformidades MUST bloquear implementação até mitigação ou exceção aprovada.
   * Toda mudança que afete fluxo de instalação MUST atualizar documentação e testes de diagnóstico.
   * Novos comandos destrutivos ou potencialmente destrutivos MUST exigir confirmação explícita.
   * Novas dependências externas MUST justificar necessidade, licença, manutenção e impacto de acessibilidade.

13. Processo de emenda:
   * Emendas MUST ser propostas via PR com resumo de impacto, migração e riscos.
   * Ratificação exige revisão técnica e de acessibilidade por pelo menos um mantenedor ativo.

**Version**: 1.1.0 | **Ratified**: 2026-06-03 | **Last Amended**: 2026-06-03
