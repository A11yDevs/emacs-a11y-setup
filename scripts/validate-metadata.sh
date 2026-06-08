#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LISP_DIR="$ROOT_DIR/lisp"

missing=0

echo "Validating package metadata under $LISP_DIR"

if [ ! -d "$LISP_DIR" ]; then
  echo "No lisp/ directory found; skipping metadata validation." >&2
  exit 0
fi

for pkgdir in "$LISP_DIR"/*/; do
  [ -d "$pkgdir" ] || continue
  pkgname=$(basename "$pkgdir")
  echo "- Checking package: $pkgname"

  # Prefer main file matching package name, else first .el
  mainfile=""
  if [ -f "$pkgdir${pkgname}.el" ]; then
    mainfile="$pkgdir${pkgname}.el"
  else
    mainfile=$(ls "$pkgdir"*.el 2>/dev/null | head -n1 || true)
  fi

  if [ -z "$mainfile" ]; then
    echo "  ERROR: no .el files found in $pkgdir" >&2
    missing=1
    continue
  fi

  # Check lexical-binding header
  if ! grep -q "lexical-binding:.*t" "$mainfile"; then
    echo "  ERROR: missing or false lexical-binding in $(basename "$mainfile")" >&2
    missing=1
  fi

  # Check Package-Requires
  if ! grep -q "Package-Requires" "$mainfile"; then
    echo "  ERROR: missing Package-Requires header in $(basename "$mainfile")" >&2
    missing=1
  fi

  # Check provide at end
  if ! tail -n 10 "$mainfile" | grep -q "provide\s*'${pkgname}"; then
    if ! tail -n 10 "$mainfile" | grep -q "provide\s*'"; then
      echo "  ERROR: missing (provide '...) near end of $(basename "$mainfile")" >&2
      missing=1
    fi
  fi

  # Check README.md presence
  if [ ! -f "$pkgdir/README.md" ] && [ ! -f "$pkgdir/README.MD" ]; then
    echo "  WARNING: README.md missing for $pkgname" >&2
  fi
done

if [ "$missing" -ne 0 ]; then
  echo "Metadata validation failed." >&2
  exit 2
fi

echo "Metadata validation passed." 
exit 0
