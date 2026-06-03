<!--
Sync Impact Report
- Version change: 1.2.0 -> 1.3.0
- Modified principles:
   - Nenhum
- Modified sections:
   - Decisões arquiteturais iniciais
   - Contrato de handoff entre installer e setup
   - Governance
- Added sections:
   - Política de organização de repositórios
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
* O emacs-a11y-installer MUST atuar principalmente na camada do sistema operacional e MUST ser responsável por levar o usuário até um Emacs falante funcional sempre que a plataforma permitir.
* O modo recomendado de instalação MUST entregar Emacs com fala funcional sempre que possível; quando isso não for viável automaticamente, o bootstrap MUST fornecer diagnóstico claro, instruções acessíveis e caminho de recuperação por terminal ou log.
* O sucesso mínimo do bootstrap MUST ser invocar o emacs-a11y-setup por interface estável, abrir o ambiente Emacs Acessível por launcher ou comando documentado usando workspace separado e registrar resultado acessível do bootstrap.
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
* O emacs-a11y-installer MUST conhecer apenas contratos estáveis de bootstrap, launcher e handoff; ele MUST NOT depender do layout interno completo do workspace, de cache, de preferências internas do usuário, da implementação interna de init.el ou de regras avançadas de perfil além do necessário para invocar o setup.
* O emacs-a11y-setup MUST ser o dono lógico do workspace e MUST manter a evolução semântica do conteúdo interno do ambiente acessível.
* O projeto MUST evitar acoplamento excessivo entre plataformas e entre installer e setup, e cada backend de instalação/TTS/servidor de fala MUST ser extensível.
* Lógica para Windows nativo, Debian/Ubuntu, macOS, Android/Termux e WSL MUST residir em módulos separados.

Rationale: modularidade reduz impacto de mudanças e facilita manutenção.

### X. Qualidade, testes de bootstrap e manutenção
* Funcionalidades críticas MUST ter testes automatizados quando viável, e scripts MUST ser idempotentes sempre que possível.
* Erros MUST produzir mensagens claras com ação corretiva sugerida.
* Implementações MUST priorizar legibilidade, manutenção simples e evolução incremental, evitando automações frágeis dependentes de estado implícito do sistema do usuário.
* O emacs-a11y-installer MUST executar testes básicos de bootstrap: instalação/localização do Emacs, execução de Emacs em modo batch, instalação/localização do Emacspeak, disponibilidade de TTS/servidor inicial quando aplicável, localização ou invocação do emacs-a11y-setup, funcionamento do handoff para o setup, criação de launcher, validação de que o launcher aponta para o workspace separado sem carregar configuração pessoal padrão e geração de log e relatório acessíveis.
* O emacs-a11y-setup MUST executar testes internos do workspace: criação do workspace, geração e carregamento do init.el do workspace, validade de custom.el e perfis internos, carregamento do Emacspeak no workspace, diagnóstico interno acessível, configuração de voz/idioma/TTS e exportação de relatórios internos.

Rationale: estabilidade operacional e previsibilidade são partes do requisito de acessibilidade.

## Decisões arquiteturais iniciais

* O ecossistema do projeto MUST incluir, no mínimo, dois componentes principais: emacs-a11y-installer e emacs-a11y-setup.
* O emacs-a11y-installer MUST ser o bootstrap externo do projeto.
* O emacs-a11y-setup MUST ser o pacote Emacs Lisp principal para diagnóstico, configuração assistida, manutenção e reparo do workspace dentro do Emacs.
* Scripts externos MUST ser usados quando necessários para bootstrap de plataforma, instalação do Emacs, instalação inicial do Emacspeak, dependências de sistema, TTS inicial, diagnóstico externo e criação de launchers.
* Scripts externos SHOULD permanecer modulares e auditáveis, MUST ser idempotentes quando possível e MUST ser seguros.
* Scripts externos MUST NOT sobrescrever configurações pessoais do usuário e MUST registrar logs acessíveis.
* O emacs-a11y-installer MUST instalar ou localizar: Emacs, Emacspeak, dependências externas mínimas, TTS/servidor inicial quando aplicável e Git/curl/unzip (ou equivalentes).
* O emacs-a11y-installer MUST instalar, localizar ou disponibilizar o emacs-a11y-setup o suficiente para invocá-lo em modo batch ou interativo.
* O emacs-a11y-installer MUST executar diagnóstico externo inicial, criar launchers/atalhos ou comandos de inicialização por plataforma, validar esses launchers e gerar logs e relatórios acessíveis do bootstrap.
* O emacs-a11y-installer MUST evitar se tornar um configurador completo do Emacs; seu foco principal MUST ser bootstrap, instalação inicial, validação, criação de launchers e abertura do ambiente acessível.
* O emacs-a11y-installer MUST NOT governar a estrutura interna do workspace e MUST NOT depender do layout completo de profiles, da estrutura interna de cache, de preferências internas do usuário, da implementação interna de init.el ou de detalhes de load-path além do estritamente necessário para invocar o setup inicial.
* O emacs-a11y-installer MAY conhecer apenas: caminho do Emacs, caminho do workspace, comando estável de inicialização, localização do emacs-a11y-setup, resultado do bootstrap e tipo de launcher adequado à plataforma.
* O projeto MUST usar por padrão um workspace separado para o ambiente emacs-a11y.
* O workspace separado MUST ser customizável pelo usuário e versionável quando apropriado.
* O projeto MUST fornecer formas simples de iniciar o Emacs com esse workspace por meio de launchers ou comandos estáveis por plataforma.
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
* O modo minimal MUST instalar ou localizar Emacs, disponibilizar o emacs-a11y-setup para invocação e oferecer Emacspeak mínimo quando viável; esse modo MAY criar launcher básico, MAY não concluir configuração completa de TTS/perfis e SHOULD ser usado para depuração e cenários especiais.
* O modo recommended MUST ser o padrão; ele MUST instalar ou localizar Emacs, Emacspeak, TTS inicial e dependências principais, MUST invocar o emacs-a11y-setup para criação da configuração inicial, MUST criar launchers por plataforma apontando para o workspace separado, MUST executar doctor/check do fluxo e MUST tentar entregar um Emacs com fala funcional.
* O modo full MUST incluir tudo do recommended e adicionar perfis e ferramentas pedagógicas, como Java, LaTeX, Git, exemplos, tutoriais e módulos adicionais, preferencialmente gerenciados pelo emacs-a11y-setup.
* O modo recommended MUST ser o padrão por reduzir a barreira inicial para usuários cegos.

## Política de workspace separado

* O ambiente emacs-a11y MUST ter diretório de configuração próprio.
* O usuário MUST poder editar esse ambiente sem afetar seu Emacs pessoal.
* Importação de configurações pessoais MUST ocorrer apenas por opção explícita.
* O projeto MAY fornecer mecanismos de exportação, backup e restauração.
* O workspace MUST suportar perfis, incluindo: iniciante, desenvolvimento Java, Emacspeak avançado, Termux, Windows nativo e oficina/curso.
* A configuração padrão MUST ser conservadora, acessível e segura.
* O modo recomendado de execução MUST iniciar o Emacs com diretório específico do emacs-a11y (por exemplo, emacs --init-directory ~/.emacs-a11y.d, emacs -q -l ~/.emacs-a11y.d/init.el ou launcher equivalente).
* O emacs-a11y-setup MUST ser responsável por criar, estruturar, manter, diagnosticar, reparar e evoluir semanticamente o conteúdo interno do workspace, incluindo init.el, early-init.el, custom.el, perfis e preferências do usuário.
* O emacs-a11y-installer MAY criar apenas o diretório raiz do workspace quando isso for necessário para permissões, preparação inicial ou criação de launchers, mas MUST NOT assumir controle da estrutura interna do workspace.
* O emacs-a11y-installer MUST usar uma interface estável definida pelo emacs-a11y-setup para iniciar o ambiente e validar launchers.
* O projeto MUST NOT alterar ~/.emacs.d ou ~/.config/emacs por padrão.
* Integração com configurações pessoais MUST ser sempre opcional, explícita, reversível e documentada.

## Contrato de handoff entre installer e setup

* O handoff entre emacs-a11y-installer e emacs-a11y-setup MUST usar interface simples, estável, documentada e de baixo acoplamento.
* O handoff MAY usar argumentos de linha de comando, variáveis de ambiente documentadas, arquivos de estado simples, chamada ao Emacs em modo batch ou chamada ao Emacs em modo interativo com emacs-a11y-setup-first-run.
* O contrato de handoff MUST ser mínimo e MUST NOT exigir que o installer conheça a estrutura interna do workspace.
* O contrato de handoff MUST ser documentado de forma compartilhada e versionada para permitir consumo por repositórios separados.
* O handoff MAY transportar apenas informações necessárias ao bootstrap: plataforma detectada, modo de instalação, caminho do workspace, caminho do Emacs, caminho do Emacspeak quando conhecido, backend TTS inicial quando conhecido, resultado do diagnóstico externo e próxima ação recomendada.
* O emacs-a11y-setup MUST expor a entrada estável consumida pelo installer e MUST tratar a criação e manutenção do conteúdo interno do workspace como responsabilidade exclusiva.
* Todo launcher criado pelo installer MUST ser simples e estável, MUST iniciar o Emacs usando o workspace separado do emacs-a11y, MUST evitar carregar ~/.emacs.d ou ~/.config/emacs por padrão, MUST apontar para entrada estável como emacs --init-directory <workspace> ou emacs -q -l <workspace>/init.el, MUST ser documentado no relatório de bootstrap, MUST ser validado pelo doctor/check do installer e MUST emitir mensagem clara com referência a logs em caso de falha.

## Política de organização de repositórios

* O ecossistema Emacs Acessível SHOULD ser organizado em repositórios separados por responsabilidade, tecnologia e ciclo de vida.
* A separação de repositórios SHOULD preservar baixo acoplamento entre bootstrap externo, setup interno, empacotamento/distribuição e materiais auxiliares.
* A integração entre repositórios MUST ocorrer por contratos versionados, documentados e testáveis, e MUST NOT depender de detalhes internos de implementação.
* O emacs-a11y-installer SHOULD residir em repositório próprio.
* Esse repositório MUST ser responsável pelo bootstrap externo em Python.
* Seu ciclo de vida envolve empacotamento Python, CLI multiplataforma, testes Python, distribuição por canais como pip, pipx ou instaladores e integração com o sistema operacional.
* Esse repositório MUST respeitar o contrato de handoff com o emacs-a11y-setup.
* Esse repositório MUST NOT depender da estrutura interna do workspace mantido pelo emacs-a11y-setup.
* O emacs-a11y-setup SHOULD residir em repositório próprio.
* Esse repositório MUST ser responsável pelo pacote Emacs Lisp principal.
* Seu ciclo de vida envolve testes Emacs Lisp, byte-compilation, comandos interativos dentro do Emacs, painel acessível, criação e manutenção do workspace, perfis, diagnóstico interno e configuração assistida.
* Esse repositório MUST expor uma interface estável de entrada para o emacs-a11y-installer.
* Esse repositório MUST documentar o contrato de handoff consumido pelo installer.
* Um repositório de distribuição, como emacs-a11y, MAY atuar como agregador de empacotamento, integração Debian/Ubuntu, launchers, metapacotes, documentação operacional, scripts auxiliares e composição de artefatos.
* Esse repositório MAY empacotar ou integrar componentes produzidos por emacs-a11y-installer e emacs-a11y-setup.
* Esse repositório MUST respeitar os contratos públicos entre os componentes e MUST NOT depender de detalhes internos não documentados.
* Launchers e empacotamentos específicos de sistema operacional MAY residir no repositório de distribuição quando fizer sentido operacional, desde que respeitem a interface estável definida para iniciar o workspace.
* Repositórios auxiliares, como forks, overlays ou empacotamentos específicos do Emacspeak, MAY existir quando houver necessidade técnica clara.
* Esses repositórios MUST documentar seu papel no ecossistema, sua relação com os demais componentes e seu ciclo de manutenção.
* Dependências entre repositórios auxiliares e os componentes centrais MUST ser explícitas, versionadas e documentadas.
* Contratos entre repositórios MUST ser documentados em arquivos como docs/handoff-contract.md, docs/repositories.md, README.md ou equivalente.
* Mudanças que quebrem contratos entre repositórios MUST atualizar documentação, testes de handoff, versão compatível e notas de migração.
* Releases dos repositórios centrais SHOULD declarar compatibilidade mínima com os demais componentes do ecossistema.
* Sempre que possível, contratos devem usar interfaces simples, como comandos estáveis, variáveis de ambiente documentadas, arquivos de estado com schema versionado ou entrypoints Emacs Lisp documentados.
* Um repositório MUST NOT depender de caminhos internos, layouts privados, nomes de arquivos internos ou estruturas não documentadas de outro repositório.
* O emacs-a11y-installer MUST NOT assumir a estrutura interna do workspace do emacs-a11y-setup.
* O repositório de distribuição MUST NOT duplicar lógica interna do emacs-a11y-setup quando puder consumir interfaces públicas.
* O repositório de distribuição MUST NOT duplicar lógica de bootstrap do emacs-a11y-installer quando puder consumir o componente oficial.
* Módulos Emacs Lisp existentes em repositórios de distribuição ou empacotamento SHOULD ser migrados gradualmente para o repositório emacs-a11y-setup quando representarem lógica interna do Emacs.
* Launchers e scripts específicos de sistema operacional MAY permanecer em repositórios de distribuição ou bootstrap, pois pertencem à camada de integração com o sistema operacional.
* Durante a migração, compatibilidade e documentação devem ser preservadas.
* Migrações MUST evitar que usuários percam configurações ou tenham fluxos existentes quebrados sem aviso, migração ou fallback.

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
   * MUST configurar ou localizar TTS/servidor inicial quando aplicável.
   * MUST localizar ou invocar o emacs-a11y-setup por interface estável.
   * MUST criar launcher ou comando de inicialização documentado apontando para workspace separado.
   * MUST validar que o launcher não carrega configuração pessoal padrão.
   * MUST executar doctor/check básico do bootstrap e do handoff.
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

14. Mudanças entre repositórios:
   * Mudanças que alterem contratos públicos entre repositórios MUST atualizar documentação, testes e notas de compatibilidade.
   * PRs que afetem integração entre repositórios MUST declarar impacto nos repositórios relacionados.
   * Releases SHOULD declarar compatibilidade mínima entre emacs-a11y-installer, emacs-a11y-setup e repositórios de distribuição.
   * Alterações que movam código entre repositórios MUST incluir plano de migração e preservação de compatibilidade.

**Version**: 1.3.0 | **Ratified**: 2026-06-03 | **Last Amended**: 2026-06-03
