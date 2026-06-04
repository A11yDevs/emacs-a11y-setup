# emacs-a11y-setup
Cross-platform setup toolkit for accessible Emacs programming environments using Emacs, Emacspeak and speech technologies.

Ecosystem architecture baseline:
- `emacs-a11y-installer`: external bootstrap at the operating-system layer; installs or
	locates Emacs, Emacspeak, initial speech dependencies, creates platform launchers,
	and invokes setup through a stable handoff.
- `emacs-a11y-setup`: in-Emacs control layer and logical owner of the separate workspace;
	creates, configures, maintains, diagnoses and repairs the internal Emacs environment.
- The ecosystem SHOULD prefer a multi-repository organization: `emacs-a11y-installer` for
	external bootstrap, `emacs-a11y-setup` for the Emacs Lisp package, and an optional
	distribution repository such as `emacs-a11y` for packaging, launchers and operating
	system integration.

Project governance and non-negotiable engineering/accessibility principles are
defined in `.specify/memory/constitution.md`.

## Local package loading

For local development, load the package with the repository root and `lisp/` on
the load path:

```bash
emacs -Q --batch \
	-L . -L lisp \
	-l emacs-a11y-setup.el \
	--eval '(princ "emacs-a11y-setup loaded\n")'
```

To run the first isolated workspace flow in batch mode:

```bash
emacs -Q --batch \
	-L . -L lisp \
	-l emacs-a11y-setup.el \
	--eval '(emacs-a11y-setup-first-run :workspace-path "/tmp/emacs-a11y-workspace")'
```
