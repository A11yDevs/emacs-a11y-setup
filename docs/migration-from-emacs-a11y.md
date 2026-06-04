# Inventario de migracao dos modulos legados

| Modulo legado | Origem | Dominio | Decisao | Justificativa | Dependencias externas | Riscos | Status | Modulo novo |
|---|---|---|---|---|---|---|---|---|
| init-packages | emacs-a11y/init.el | pacotes | adaptar | remover pressupostos Debian | repos de pacote | divergencia de mirrors | pendente | init-core |
| init-accessibility | emacs-a11y/init.el | acessibilidade | migrar | nucleo de acessibilidade | emacspeak opcional | diferencas TTS por SO | em-progresso | init-accessibility |
| init-core | emacs-a11y/init.el | core | migrar | base obrigatoria | nenhuma | regressao de bootstrap | em-progresso | init-core |
| init-dired | emacs-a11y/init.el | arquivos | migrar | necessario para navegacao basica | nenhuma | mudanca de atalhos | pendente | init-dired |
| init-completion | emacs-a11y/init.el | produtividade | adaptar | manter baseline conservador | nenhuma | impacto em performance | pendente | init-completion |
| init-java | emacs-a11y/init.el | java | adiar | fora do escopo minimo | JDK | toolchain ausente | pendente | init-java |
| init-java-lsp | emacs-a11y/init.el | java | adiar | exige dependencias externas | jdtls | complexidade alta | pendente | init-java-lsp |
| init-gptel | emacs-a11y/init.el | IA | adiar | exige credenciais | API key | vazamento de segredo | pendente | init-gptel |
| init-shell | emacs-a11y/init.el | shell | migrar | essencial para fluxo seguro | shell local | variacoes por plataforma | em-progresso | init-shell |
| init-layout | emacs-a11y/init.el | interface | adaptar | manter simplificado no padrao | nenhuma | sobrecarga visual | pendente | init-layout |
| init-activities | emacs-a11y/init.el | produtividade | adiar | opcional de baixa prioridade | nenhuma | pouca cobertura de teste | pendente | init-activities |
| init-navigation | emacs-a11y/init.el | navegacao | migrar | essencial para onboarding | nenhuma | alteracao de teclas | em-progresso | init-navigation |
| init-layout-ide | emacs-a11y/init.el | interface avancada | descartar | fora do perfil conservador inicial | LSP extra | alto acoplamento | pendente | - |
