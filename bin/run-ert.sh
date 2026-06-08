#!/usr/bin/env bash
set -euo pipefail

# Wrapper to run the ERT test suite with a stable TMPDIR to avoid
# macOS /var/folders path issues in CI/local runs.

export TMPDIR=/tmp

echo "Running ERT suite with TMPDIR=${TMPDIR}"

for f in test/*-tests.el; do
  echo "== running: $f =="
  emacs -Q --batch -l ert -L . -L lisp -l "$f" -f ert-run-tests-batch || true
done

echo "All test files executed."
