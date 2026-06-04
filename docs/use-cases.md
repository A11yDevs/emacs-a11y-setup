# Casos de Uso

## UC01 - Criar workspace isolado
- Story: US1
- FR: FR-007, FR-008, FR-009, FR-010
- Fluxo principal: cria estrutura minima sem tocar configuracao pessoal.
- Testes: workspace-tests (criacao, idempotencia, preservacao).

## UC02 - Executar primeiro uso
- Story: US1
- FR: FR-011, FR-013
- Fluxo principal: cria workspace, aplica perfil conservador, carrega modulo essencial.
- Testes: workspace-tests e profiles-tests.

## UC03 - Processar handoff valido
- Story: US2
- FR: FR-014, FR-015
- Fluxo principal: valida contrato 1.x, cria/valida workspace, registra resultado.
- Testes: handoff-tests (contrato valido).

## UC04 - Rejeitar handoff invalido
- Story: US2
- FR: FR-014
- Fluxo principal: falha com mensagem textual acessivel.
- Testes: handoff-tests (sem contract_version, versao invalida, workspace invalido).

## UC05 - Inventariar modulos legados
- Story: US3
- FR: FR-002, FR-003, FR-020
- Fluxo principal: registrar 13 modulos, dominio, decisao e risco.
- Testes: modules-tests (inventario e classificacao).

## UC06 - Aplicar perfil conservador
- Story: US5
- FR: FR-011, FR-012, FR-019
- Fluxo principal: habilitar apenas nucleo minimo.
- Testes: profiles-tests e modules-tests.

## UC07 - Carregar modulos com resiliencia
- Story: US5
- FR: FR-006
- Fluxo principal: erro em essencial bloqueia sucesso; opcional vira aviso.
- Testes: modules-tests.

## UC08 - Executar doctor interativo
- Story: US4
- FR: FR-016, FR-017, FR-018
- Fluxo principal: verificar workspace, perfil, modulos, fala, logs e relatorios.
- Testes: doctor-tests.

## UC09 - Executar doctor batch
- Story: US4
- FR: FR-016, FR-017
- Fluxo principal: gerar relatorio textual e codigo de saida para automacao.
- Testes: doctor-tests.

## UC10 - Registrar limitacao de Emacspeak/TTS
- Story: US4
- FR: FR-016
- Fluxo principal: ausencia de Emacspeak/TTS vira aviso com proximos passos.
- Testes: doctor-tests.

## UC11 - Produzir artefatos de engenharia
- Story: US6
- FR: FR-022
- Fluxo principal: manter docs e diagramas com fronteira de escopo clara.
- Testes: doctor-tests (presenca de artefatos obrigatorios).

## UC12 - Manter compatibilidade futura de publicacao
- Story: US6
- FR: FR-021
- Fluxo principal: documentar preparo para publicacao sem publicar nesta feature.
- Testes: validacao documental.
