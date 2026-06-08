# Quickstart: Gestao de Pacotes Comunitarios A11yDevs

## Goal

Validar o planejamento tecnico da distribuicao modular de pacotes Emacs Lisp via `package-vc-install`, usando o monorepo da Comunidade A11yDevs, sem copia manual de arquivos.

## Prerequisites

- Emacs com suporte a `package-vc-install` no ambiente de validacao.
- Acesso ao repositorio `https://github.com/A11yDevs/emacs-a11y-setup`.
- Estrutura de pacotes em `lisp/<nome-pacote>/` definida no plano tecnico.
 - Estrutura de pacotes em `lisp/<nome-pacote>/` definida no plano tecnico.
 - Consumidores legados (ex.: pipelines de empacotamento) podem existir, mas sua validação é opcional e fora do escopo inicial.

## Planned Validation Flow

1. Validar instalacao de um pacote individual (ex.: `a11y-java`).
2. Validar instalacao de um pacote opcional (ex.: `a11y-gptel`) sem depender de modulos nao relacionados.
3. Validar instalacao do pacote agregador `a11y-emacs`.
4. Validar carregamento por `require` apos instalacao.
5. Validar exemplos equivalentes com `use-package`.
6. Validar autoloads, customizacao e dependencias declaradas.

## Canonical Installation Examples

Pacote individual:

```elisp
(package-vc-install
 '(a11y-java
  :url "https://github.com/A11yDevs/emacs-a11y-setup.git"
   :branch "main"
   :lisp-dir "lisp/a11y-java"
   :main-file "a11y-java.el"))
```

Pacote opcional:

```elisp
(package-vc-install
 '(a11y-gptel
  :url "https://github.com/A11yDevs/emacs-a11y-setup.git"
   :branch "main"
   :lisp-dir "lisp/a11y-gptel"
   :main-file "a11y-gptel.el"))
```

Pacote agregador:

```elisp
(package-vc-install
 '(a11y-emacs
  :url "https://github.com/A11yDevs/emacs-a11y-setup.git"
   :branch "main"
   :lisp-dir "lisp/a11y-emacs"
   :main-file "a11y-emacs.el"))
```

## Canonical Load Examples

Require:

```elisp
(require 'a11y-java)
```

Use-package:

```elisp
(use-package a11y-java
  :vc (:url "https://github.com/A11yDevs/emacs-a11y-setup.git"
       :branch "main"
       :lisp-dir "lisp/a11y-java"
       :main-file "a11y-java.el"))
```

## Planned Technical Checks

- Metadados obrigatorios presentes em cada pacote.
- Comandos publicos com `;;;###autoload`, quando aplicavel.
- Opcoes customizaveis com `defgroup`/`defcustom`, quando aplicavel.
- Ausencia de dependencia circular.
- `Package-Requires` consistente com uso real.
- Pacotes opcionais instalaveis isoladamente.
- `a11y-emacs` carregando/dependo dos modulos base.
- README minimo por pacote com exemplos funcionais.
- Validação de consumidores legados é opcional e fora do escopo inicial.

## Notes

- Esta etapa atualiza apenas planejamento tecnico; nao implementa arquivos `.el` nem move codigo.
- Estrategia de monorepo permanece ativa nesta fase.
- Split para repositorios proprios e possibilidade futura condicionada a maturidade de cada pacote.

## Run batch validation

1. Torne o script executável:

chmod +x quickstart-batch.sh

2. Execute em modo batch (cria workspace em `.eaacs-quickstart-workspace` por padrão):

chmod +x quickstart-batch.sh

3. Verifique a saída do `ert-run-tests-batch` no terminal. Logs operacionais por operação aparecem em `<workspace>/.eaacs-logs/`.

4. Para usar um workspace customizado:

quickstart-batch.sh /tmp/my-eaacs-ws

5. Se houver falhas, cole a saída do terminal e os arquivos de log em `<workspace>/.eaacs-logs/` para diagnóstico.