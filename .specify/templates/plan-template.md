# Implementation Plan: [FEATURE]

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]

**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

[Extract from feature spec: primary requirement + technical approach from research]

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: [e.g., Python 3.11, Swift 5.9, Rust 1.75 or NEEDS CLARIFICATION]

**Primary Dependencies**: [e.g., FastAPI, UIKit, LLVM or NEEDS CLARIFICATION]

**Storage**: [if applicable, e.g., PostgreSQL, CoreData, files or N/A]

**Testing**: [e.g., pytest, XCTest, cargo test or NEEDS CLARIFICATION]

**Target Platform**: [e.g., Linux server, iOS 15+, WASM or NEEDS CLARIFICATION]

**Project Type**: [e.g., library/cli/web-service/mobile-app/compiler/desktop-app or NEEDS CLARIFICATION]

**Performance Goals**: [domain-specific, e.g., 1000 req/s, 10k lines/sec, 60 fps or NEEDS CLARIFICATION]

**Constraints**: [domain-specific, e.g., <200ms p95, <100MB memory, offline-capable or NEEDS CLARIFICATION]

**Scale/Scope**: [domain-specific, e.g., 10k users, 1M LOC, 50 screens or NEEDS CLARIFICATION]

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- Accessibility gate: The plan MUST describe keyboard-first flows, screen-reader-
  friendly outputs, and no GUI-only critical path.
- Emacs/Emacspeak gate: The plan MUST define how Emacs Lisp is the primary interface
  and how Emacspeak feedback is preserved or improved.
- Installer/setup boundary gate: The plan MUST separate responsibilities between
  `emacs-a11y-installer` (external bootstrap) and `emacs-a11y-setup` (in-Emacs control
  and maintenance).
- Handoff gate: The plan MUST define a minimal, stable handoff contract between
  installer and setup, including allowed inputs, launcher ownership, and explicit
  avoidance of installer dependence on internal workspace structure.
-- Platform gate: The plan MUST analyze impact for Windows native, Linux (ex.: Debian/Ubuntu),
  macOS, Android/Termux, and WSL, with explicit justification for any exclusions.
- Workspace isolation gate: The plan MUST preserve user personal Emacs config and use
  separate emacs-a11y workspace defaults.
- Diagnostics gate: The plan MUST include doctor/check strategy before mutating setup.
- Bootstrap speaking gate: The recommended installation path MUST target a speaking
  Emacs when technically possible; if not possible automatically, the plan MUST define
  an accessible recovery path via terminal/log guidance.
- Installation modes gate: The plan MUST document scope differences for `minimal`,
  `recommended` (default), and `full` installation modes.
- Bootstrap validation gate: The plan MUST include installer-side checks (Emacs,
  batch Emacs, Emacspeak, initial TTS/server, setup invocation, handoff, launcher,
  no personal config load, accessible bootstrap report) and setup-side checks
  (workspace creation, workspace init load, internal configuration validity,
  Emacspeak in workspace, internal diagnostics/reporting).
- Modularity gate: The plan MUST isolate platform-specific logic in dedicated modules.
- Quality gate: The plan MUST include idempotency, clear error reporting, and test
  strategy for critical flows.
- Governance gate: The plan MUST map required docs, linked issues, and PR compliance
  checklist updates.

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```text
# [REMOVE IF UNUSED] Option 1: Single project (DEFAULT)
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/

# [REMOVE IF UNUSED] Option 2: Web application (when "frontend" + "backend" detected)
backend/
├── src/
│   ├── models/
│   ├── services/
│   └── api/
└── tests/

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   └── services/
└── tests/

# [REMOVE IF UNUSED] Option 3: Mobile + API (when "iOS/Android" detected)
api/
└── [same as backend above]

ios/ or android/
└── [platform-specific structure: feature modules, UI flows, platform tests]
```

**Structure Decision**: [Document the selected structure and reference the real
directories captured above]

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
