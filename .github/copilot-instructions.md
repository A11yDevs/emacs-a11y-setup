<!-- SPECKIT START -->
For additional context about technologies to be used, project structure,
shell commands, and other important information, read the current plan
at specs/002-community-package-management/plan.md
<!-- SPECKIT END -->

# Default Copilot Policy

Operate in token-economy mode by default.

- Prefer minimal context.
- Prefer minimal edits.
- Prefer short answers.
- Do not scan the whole repository unless explicitly requested.
- Do not rewrite complete files unless necessary.
- Do not perform opportunistic refactoring.
- Do not run broad commands or full test suites unless requested.
- Ask for or infer the smallest relevant file set before making changes.
- In Agent Mode, stop after completing the requested unit of work.