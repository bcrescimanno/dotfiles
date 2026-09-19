---
name: programs.git is not enabled
description: common.nix sets programs.git.settings but never enable, so HM renders no git config; ssh-agent.nix writes git/config as a raw file instead
type: project
---

`home/common.nix` sets `programs.git.settings` (core.hooksPath, core.excludesFile)
but never `programs.git.enable`, so Home Manager renders NO git config on any
machine — those settings have never applied. Found 2026-09-19. The flake-check
pre-commit hook works only because each repo carries its own copy in `.git/hooks`.

`home/ssh-agent.nix` therefore writes `~/.config/git/config` via `xdg.configFile`
(Bitwarden machines only) instead of `programs.git.settings`.

**Why not just enable it:** that would apply `core.hooksPath` globally on every
machine, which makes git ignore every repo's own `.git/hooks`. Brian has not
decided on that.

**How to apply:** if programs.git is ever enabled, move the ssh-agent.nix git
settings into `programs.git.settings` in the same change — HM refuses to build
with both defining `git/config`. Also remember the unmanaged `~/.gitconfig` is
read after the XDG file and wins; a machine switched to Bitwarden must have its
`gpg.ssh.program` line removed there.
