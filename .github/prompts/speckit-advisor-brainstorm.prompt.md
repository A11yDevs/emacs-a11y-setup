---
name: speckit-advisor-brainstorm
description: Brainstorm consultivo de ideia de feature com foco em problema, escopo, riscos e prompt final para /speckit.specify.
argument-hint: Descreva a ideia livre da feature, contexto, restricoes e objetivos
agent: speckit-advisor
---

Atue em modo consultivo e read-only.

Objetivo deste prompt:
- Discutir uma ideia livre de feature.
- Amadurecer problema central, objetivo da feature, escopo e fora de escopo.
- Identificar riscos, ambiguidades e decisoes pendentes.
- Gerar ao final um prompt pronto para /speckit.specify.

Restricoes de atuacao:
- Nao modificar arquivos.
- Nao implementar codigo.
- Nao criar commits.
- Nao substituir o comando formal /speckit.specify.

Antes de analisar, delimite o escopo da revisão. Se o usuário não informar arquivos específicos, priorize:
1. .specify/memory/constitution.md
2. spec.md
3. plan.md
4. tasks.md
5. docs/ diretamente relacionados à feature

Não faça varredura completa do repositório, salvo solicitação explícita.

Formato esperado da resposta:
1. Sintese da ideia
2. Problema central
3. Objetivo da feature
4. Usuarios ou atores
5. Escopo proposto
6. Fora de escopo
7. Riscos e ambiguidades
8. Decisoes pendentes
9. Recomendacoes
10. Prompt recomendado para /speckit.specify

Contexto fornecido pelo usuario:
$ARGUMENTS
