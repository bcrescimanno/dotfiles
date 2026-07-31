# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Nix flake managing Home Manager configurations for multiple machines and devshells for development environments.

## Key Commands

Apply configuration to the current machine:
```
hms
```
`hms` is defined in `home/hms.nix` and works the same on every machine: it builds from `~/code/dotfiles` if that clone exists (fast-forwarding it first, unless the tree is dirty) and otherwise from GitHub with `--refresh`. The underlying command is:
```
home-manager switch --flake github:bcrescimanno/dotfiles#brian@<machine> --refresh
```

Check every machine, including the Mac and the Pis (evaluation is cross-platform even though building isn't):
```
./.github/scripts/check-machines.sh
```
Check only the current system:
```
nix flake check --no-build
```
`--all-systems` does not work here — the `cpp` devshell pulls in valgrind, which nixpkgs marks broken on aarch64-darwin. That's why `check-machines.sh` evaluates each machine explicitly instead. To evaluate just one:
```
nix eval --raw '.#checks.aarch64-darwin."brian@mac".drvPath'
```
Note: A pre-commit hook runs `nix flake check --no-build` automatically on commits in flake repos, so it only covers x86_64-linux — a change that breaks the Mac gets caught by CI, not by the hook. The hook reads the git tree, so `git add -N` new files first or they'll appear missing.

Enter a devshell:
```
nix develop .#ruby    # or cpp, rust, default
```

## Architecture

### Module Composition

Machine configs in `machines/` compose `home/` modules:

- `home/common.nix` — imported by every machine: zsh, neovim, tmux, fzf, oh-my-posh, direnv, git hooks, bin scripts
- `home/hms.nix` — imported by common.nix: defines `hms`. Each machine sets `dotfiles.configName = "brian@<machine>"` so it knows what to build
- `home/arch.nix` — Arch Linux only: adds archlinux OMZ plugin
- `home/darwin.nix` — macOS only: Ghostty Application Support path, font-size override
- `home/terminal.nix` — all graphical machines: Ghostty, Alacritty
- `home/wayland.nix` — Linux/Wayland only: Hyprland, Quickshell, Mako, wleave, uwsm, elephant
- `home/dev-tools.nix` — dev packages (gcc, nodejs, python3, etc.) — not used on Arch to avoid conflicts with system packages
- `home/headless.nix` — headless/server profile: minimal server tools only

### Machines

| Config | System | Profile |
|---|---|---|
| `brian@liquidark` | x86_64-linux | common + arch + terminal + wayland + red-tools |
| `brian@celes` | x86_64-linux | common + arch + terminal + wayland |
| `brian@terra` | x86_64-linux | common + arch |
| `brian@orthanc` | x86_64-linux | common + dev-tools + headless |
| `brian@mac` | aarch64-darwin | common + darwin + dev-tools + terminal |
| `brian@pirateship` | aarch64-linux | common + dev-tools + headless |
| `brian@rivendell` | aarch64-linux | common + headless |
| `brian@mirkwood` | aarch64-linux | common + headless |

Adding a machine means three edits: a file in `machines/` (including `dotfiles.configName`), and both a `homeConfigurations` and a `checks` entry in `flake.nix`. The `checks` entry is what makes CI validate it.

### Config Files

`.config/` contains the raw config files for GUI apps (Hyprland, Ghostty, Alacritty, etc.). These are linked into `~/.config/` via `home.file`. Editing them in the repo takes effect after `home-manager switch`.

Two configs live in separate repos and are symlinked via `mkOutOfStoreSymlink` so edits are live without re-running home-manager:

- **Neovim** — `~/code/kickstart.nvim` → `~/.config/nvim`
  ```
  git clone https://github.com/bcrescimanno/kickstart.nvim ~/code/kickstart.nvim
  ```
- **Quickshell** — `~/code/liquidark-shell` → `~/.config/quickshell`
  ```
  git clone https://github.com/bcrescimanno/liquidark-shell ~/code/liquidark-shell
  ```

### CI

Two workflows, both driven by scripts in `.github/scripts/` that also run locally.

**`check.yml`** runs `check-machines.sh` on every push to `main`, on pull requests, and on demand. It evaluates all eight machines, so an edit that only breaks the Mac or a Pi fails here rather than surfacing the next time that machine runs `hms`.

**`update-lock.yml`** runs `update-lock.sh` at 09:00 UTC nightly (and on `workflow_dispatch`), then commits the new `flake.lock` straight to `main`. Combined with `hms` using `--refresh`, running `hms` on any machine picks up the latest packages without anyone updating the lock by hand.

`update-lock.sh` only keeps an update that still evaluates — it validates with the same `check-machines.sh`. If the combined update fails it retries with only `nixpkgs`, then only `home-manager`, and pushes the first that works. If none do, nothing is pushed and the workflow fails (GitHub emails on failed scheduled runs).

Note that the nightly job's own push does not trigger `check.yml`: GitHub does not fire workflows for pushes made with `GITHUB_TOKEN`. That's fine, since `update-lock.sh` has already run the same check before pushing.

### Unfree Packages

`pkgsFor` in `flake.nix` uses `allowUnfreePredicate` to allow `claude-code` specifically. Add other unfree package names there as needed.
