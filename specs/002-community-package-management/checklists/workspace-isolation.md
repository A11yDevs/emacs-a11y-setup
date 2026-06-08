# Workspace Isolation checklist

Purpose: garantir que alterações de instalação e validação não modifiquem arquivos de configuração pessoal do usuário.

Evidence path: `specs/002-community-package-management/artifacts/isolation/`

Steps (perform using the intended installer/setup flow against an explicit workspace):

- [ ] Choose or create an isolated workspace directory (example: `/tmp/emacs-a11y-workspace-<date>`). Record path to `workdir.txt`.
- [ ] Verify that `HOME`-scoped config files are untouched before and after test steps:
  - Snapshot: `ls -la ~/.emacs.d ~/.config/emacs ~/.emacs* > specs/002-community-package-management/artifacts/isolation/pre-snapshot.txt`
- [ ] Run the test install flow targeting the isolated workspace (use `:lisp-dir` or workspace flags) and capture logs to `install-log.txt`.
- [ ] After test, snapshot the same home paths and diff against pre-snapshot; store diff as `post-diff.txt`.
- [ ] Confirm no write operations were made to `~/.emacs.d`, `~/.config/emacs`, `~/.emacs`, or other personal config files. If diffs exist, record details and abort further mutating operations.
- [ ] Verify all generated files and logs are inside the isolated workspace or `specs/.../artifacts/isolation/` and not in home directories.

Output and artifacts

- `pre-snapshot.txt`, `install-log.txt`, `post-snapshot.txt`, `post-diff.txt`, `workdir.txt` under `specs/002-community-package-management/artifacts/isolation/`.

Notes

- Use containerized or VM-based runners when possible for CI to ensure reproducibility.
- If workspace isolation checks fail, provide a remediation plan before attempting to modify `lisp/`.
