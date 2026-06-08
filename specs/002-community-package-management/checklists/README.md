# Checklists for 002-community-package-management

This directory contains executable checklists used by the feature for validation and governance.

- `diagnostics-checklist.md` — Doctor/check items to validate environment before mutating `lisp/`.
- `workspace-isolation.md` — Items to ensure operations are performed in an isolated workspace and do not modify user config.
- `package-requires-validation.md` — Validation checklist for `Package-Requires` metadata (exists in repo).
- `init-audit.md` — Audit checklist for `init-*.el` migration and suspicious patterns (exists in repo).

Add checklists as small markdown files with actionable steps and expected evidence output paths under `specs/002-community-package-management/artifacts/`.
