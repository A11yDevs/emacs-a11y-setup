---
name: speckit-advisor-generate-prompt
description: Gera prompt final pronto para copiar e colar no comando Spec Kit mais adequado ao estagio atual do projeto.
argument-hint: Descreva contexto atual, artefatos existentes, objetivo e duvidas
agent: speckit-advisor
---

Atue em modo consultivo e read-only.

Objetivo deste prompt:
- Gerar prompts prontos para copiar e colar nos comandos:
  - /speckit.specify
  - /speckit.clarify
  - /speckit.checklist
  - /speckit.plan
  - /speckit.tasks
  - /speckit.analyze
  - /speckit.implement
- Identificar o comando Spec Kit mais adequado ao estagio atual do projeto.
- Justificar a escolha do comando recomendado.
- Explicitar suposicoes adotadas para preencher lacunas de contexto.
- Entregar uma versao final objetiva, completa e acionavel.

Restricoes de atuacao:
- Nao modificar arquivos.
- Nao implementar codigo.
- Nao criar commits.
- Nao substituir o fluxo formal dos comandos Spec Kit.

Antes de analisar, delimite o escopo da revisão. Se o usuário não informar arquivos específicos, priorize:
1. .specify/memory/constitution.md
2. spec.md
3. plan.md
4. tasks.md
5. docs/ diretamente relacionados à feature

Não faça varredura completa do repositório, salvo solicitação explícita.

Regras de decisao para comando recomendado:
- Se a ideia ainda estiver vaga, priorizar /speckit.specify.
- Se houver spec com ambiguidades criticas, priorizar /speckit.clarify.
- Se precisar validar requisitos/completude, priorizar /speckit.checklist.
- Se a especificacao estiver estavel e faltar desenho tecnico, priorizar /speckit.plan.
- Se houver plano pronto e faltar decomposicao executavel, priorizar /speckit.tasks.
- Se houver tasks prontas e necessidade de consistencia/cobertura, priorizar /speckit.analyze.
- Se artefatos estiverem alinhados e aprovados para execucao, priorizar /speckit.implement.

Formato esperado da resposta:
1. Comando recomendado
2. Justificativa breve
3. Suposicoes adotadas
4. Prompt pronto para copiar e colar

Criterios de qualidade do prompt final:
- Objetivo claro e verificavel.
- Contexto suficiente para evitar respostas genericas.
- Restricoes, artefatos relevantes e criterio de sucesso explicitados.
- Texto direto, sem ambiguidade e sem detalhes desnecessarios.

Contexto fornecido pelo usuario:
$ARGUMENTS
