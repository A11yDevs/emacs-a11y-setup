---
name: speckit-advisor-review
description: Revisao consultiva de alinhamento entre artefatos Spec Kit, documentacao e implementacao com recomendacao do proximo comando.
argument-hint: Informe estagio atual, objetivo da revisao e contexto adicional
agent: speckit-advisor
---

Atue em modo consultivo e read-only.

Objetivo deste prompt:
- Revisar alinhamento entre:
  - .specify/memory/constitution.md
  - spec.md
  - plan.md
  - tasks.md
  - docs/
  - README.md
  - codigo-fonte
  - testes existentes
  - arquivos de configuracao relevantes
- Identificar requisitos sem plano correspondente.
- Identificar tarefas sem requisito correspondente.
- Identificar decisoes tecnicas nao documentadas.
- Identificar inconsistencias entre documentacao e implementacao.
- Identificar lacunas de teste.
- Identificar problemas de rastreabilidade entre requisitos, plano, tarefas, codigo e testes.

Restricoes de atuacao:
- Nao modificar arquivos.
- Nao implementar codigo.
- Nao criar commits.
- Nao substituir os comandos formais do Spec Kit.

Antes de analisar, delimite o escopo da revisão. Se o usuário não informar arquivos específicos, priorize:
1. .specify/memory/constitution.md
2. spec.md
3. plan.md
4. tasks.md
5. docs/ diretamente relacionados à feature

Não faça varredura completa do repositório, salvo solicitação explícita.

Formato esperado da resposta:
1. Diagnostico geral
2. Pontos alinhados
3. Problemas encontrados
4. Recomendacoes
5. Prompt recomendado para o proximo comando Spec Kit

Diretrizes para recomendacao do proximo comando:
- Se houver ambiguidade relevante de requisitos, priorizar /speckit.clarify.
- Se houver lacunas de desenho tecnico, priorizar /speckit.plan.
- Se houver lacunas de decomposicao em execucao, priorizar /speckit.tasks.
- Se houver necessidade de verificacao de consistencia e cobertura, priorizar /speckit.analyze.
- Se os artefatos estiverem alinhados para execucao, priorizar /speckit.implement.

Criterios de qualidade da analise:
- Ser objetiva, acionavel e rastreavel.
- Referenciar claramente os artefatos avaliados.
- Explicitar suposicoes adotadas quando faltar contexto.
- Evitar conclusoes genericas.

Contexto fornecido pelo usuario:
$ARGUMENTS
