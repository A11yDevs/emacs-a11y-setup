# Quickstart: 001-migracao-modulos-config-workspace

## Objetivo
Validar o fluxo tecnico minimo do `emacs-a11y-setup` para workspace isolado, handoff e diagnostico interno.

## Pre-requisitos
- Emacs com suporte a execucao em batch.
- Repositorio na branch `001-migracao-modulos-config-workspace`.

## Carregamento local do pacote

```bash
emacs --batch -Q -L . -L lisp \
  -l emacs-a11y-setup.el \
  --eval '(princ "pacote carregado\n")'
```

## Primeiro uso com workspace isolado

```bash
emacs --batch -Q -L . -L lisp \
  -l emacs-a11y-setup.el \
  --eval '(emacs-a11y-setup-first-run :workspace-path "/tmp/emacs-a11y-workspace")'
```

## Doctor interativo e batch

```bash
emacs --batch -Q -L . -L lisp \
  -l emacs-a11y-setup.el \
  --eval '(emacs-a11y-setup-doctor "/tmp/emacs-a11y-workspace" '\''iniciante)'

emacs --batch -Q -L . -L lisp \
  -l emacs-a11y-setup.el \
  --eval '(emacs-a11y-setup-doctor-batch "/tmp/emacs-a11y-workspace" '\''iniciante)'
```

## Simulacao de handoff JSON

```bash
cat > /tmp/handoff.json << 'JSON'
{
  "contract_version": "1.0",
  "platform": "macos",
  "bootstrap_mode": "recommended",
  "workspace_path": "/tmp/emacs-a11y-workspace"
}
JSON

emacs --batch -Q -L . -L lisp \
  -l emacs-a11y-setup.el \
  --eval '(prin1 (emacs-a11y-setup-bootstrap "/tmp/handoff.json"))'
```

## Fluxo de validacao manual (MVP)

1. Criar workspace em diretorio temporario (sem tocar `~/.emacs.d` e `~/.config/emacs`).
2. Executar fluxo `emacs-a11y-setup-first-run`.
3. Confirmar estrutura minima gerada:
   - `init.el`
   - `early-init.el`
   - `custom.el`
   - `config/`
   - `profiles/`
   - `logs/`
   - `reports/`
   - `backups/`
4. Simular handoff com contrato valido e executar `emacs-a11y-setup-bootstrap`.
5. Executar `emacs-a11y-setup-doctor` (interativo) e `emacs-a11y-setup-doctor-batch`.
6. Verificar relatorio textual em `reports/` e log em `logs/`.
7. Simular falha de modulo opcional e confirmar que o doctor continua acessivel.

## Execucao de testes (ERT)

Exemplo de comando batch para testes:

```bash
emacs --batch -Q \
  -L . -L lisp -L test \
  -l test/emacs-a11y-setup-workspace-tests.el \
  -l test/emacs-a11y-setup-handoff-tests.el \
  -l test/emacs-a11y-setup-doctor-tests.el \
  -l test/emacs-a11y-setup-profiles-tests.el \
  -l test/emacs-a11y-setup-modules-tests.el \
  -f ert-run-tests-batch-and-exit
```

## Criticos de validacao

- Configuracao pessoal do usuario nao alterada por padrao.
- Handoff sem `contract_version` falha com mensagem acessivel.
- Handoff com versao incompatível falha com mensagem acessivel.
- `workspace_path` ausente ou invalido falha com orientacao clara.
- Modulo opcional com falha nao bloqueia `doctor`.
- Modulos com credenciais (ex.: IA) desabilitados por padrao no perfil conservador.

## Compatibilidade futura de publicacao (FR-021)

- Esta feature nao publica pacote em MELPA/ELPA.
- O desenho atual preserva compatibilidade futura por seguir convencoes de pacote Emacs Lisp,
  expor comandos publicos estaveis e manter testes ERT em batch.
