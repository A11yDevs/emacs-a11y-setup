#!/usr/bin/env bash
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "$0")/.."; pwd)"
WORKSPACE="${1:-$REPO_ROOT/.eaacs-quickstart-workspace}"
mkdir -p "$WORKSPACE"
export EAACS_WORKSPACE="$WORKSPACE"
emacs -Q --batch \
  --eval "(setq default-directory \"${REPO_ROOT}/\")" \
  -l "${REPO_ROOT}/lisp/emacs-a11y-setup-community-packages.el" \
  -l "${REPO_ROOT}/test/emacs-a11y-setup-community-packages-tests.el" \
  -f ert-run-tests-batch
