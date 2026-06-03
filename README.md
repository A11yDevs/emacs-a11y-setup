# emacs-a11y-setup
Cross-platform setup toolkit for accessible Emacs programming environments using Emacs, Emacspeak and speech technologies.

Ecosystem architecture baseline:
- `emacs-a11y-installer`: external bootstrap at the operating-system layer; installs or
	locates Emacs, Emacspeak, initial speech dependencies, creates platform launchers,
	and invokes setup through a stable handoff.
- `emacs-a11y-setup`: in-Emacs control layer and logical owner of the separate workspace;
	creates, configures, maintains, diagnoses and repairs the internal Emacs environment.

Project governance and non-negotiable engineering/accessibility principles are
defined in `.specify/memory/constitution.md`.
