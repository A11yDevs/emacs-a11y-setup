# Diagnostics-first checklist

Purpose: validar o ambiente antes de executar mutações em `lisp/` ou realizar instalações.

Evidence path: `specs/002-community-package-management/artifacts/diagnostics/`

Steps (execute in a clean shell on the target platform):

- [ ] Verify Emacs binary is available and record version:
  - Command: `emacs --version > specs/002-community-package-management/artifacts/diagnostics/emacs-version.txt 2>&1`
- [ ] Verify Emacs can run in batch and load library paths (basic sanity):
  - Command: `emacs -Q --batch -l lisp -f nil >/dev/null 2>&1 || true` (record failures to `emacs-batch.log`).
- [ ] Verify `package-vc-install` (or alternative) is available in target Emacs runtime:
  - Command: start Emacs and evaluate `(require 'package) (require 'package-vc-install)` capturing errors to `package-vc-install-check.txt`.
- [ ] Verify Emacspeak (or configured TTS backend) is present (if platform supports):
  - Command: check for `emacspeak` package or TTS binary and record output to `emacspeak-check.txt`.
- [ ] Network reachability check to canonical repository (GitHub):
  - Command: `curl -fI https://github.com/A11yDevs/emacs-a11y-setup > specs/002-community-package-management/artifacts/diagnostics/network-github.txt 2>&1`
- [ ] Validate workspace write permissions and isolation location:
  - Command: create temp workspace and verify it is writable; record path in `workspace-path.txt`.
- [ ] Run lightweight package install dry-run using artifact `a11y-hello` to confirm installability in isolation and capture logs to `a11y-hello-install-dryrun.log`.

Output and artifacts

- Collect the above files under `specs/002-community-package-management/artifacts/diagnostics/` and include a `SUMMARY.md` describing any failures and next steps.

Notes

- If any check fails, stop and open an issue with the artifact files attached and include platform, Emacs version and relevant logs.
