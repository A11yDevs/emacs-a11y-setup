# Branch protection setup

Recomendações para proteger branches importantes (ex.: `main`, `release/*`, `feature/*`):

1. Vá em Settings → Branches → Add rule
2. Em "Branch name pattern" use `main` e outra regra para `feature/**` se desejar
3. Marque "Require status checks to pass before merging"
   - Selecione a checagem `Run ERT tests` (workflow name) ou o status correspondente
4. Marque "Require pull request reviews before merging" e configure o número mínimo de aprovações
5. (Opcional) Marque "Include administrators" para aplicar a regra a administradores

Observação: não é possível criar regras de proteção apenas com arquivos no repositório — estas configurações devem ser aplicadas via GitHub UI ou API por um administrador do repositório.
