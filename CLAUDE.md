# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Nix flake managing Home Manager configurations for multiple machines and devshells for development environments.

## Key Commands

Apply configuration to the current machine (liquidark):
```
home-manager switch --flake github:bcrescimanno/dotfiles#brian@liquidark --refresh
```
(This is also aliased as `hms` in the shell.)

Check the flake without building:
```
nix flake check --no-build
```
Note: A pre-commit hook runs `nix flake check --no-build` automatically on commits in flake repos.

Enter a devshell:
```
nix develop .#ruby    # or cpp, rust, default
```

## Architecture

### Module Composition

Machine configs in `machines/` compose `home/` modules:

- `home/common.nix` — imported by every machine: zsh, neovim, tmux, fzf, oh-my-posh, direnv, git hooks, bin scripts
- `home/arch.nix` — Arch Linux only: adds archlinux OMZ plugin, hms alias
- `home/darwin.nix` — macOS only: hms alias, Ghostty Application Support path, font-size override
- `home/terminal.nix` — all graphical machines: Ghostty, Alacritty
- `home/wayland.nix` — Linux/Wayland only: Hyprland, Quickshell, Mako, wleave, uwsm, elephant
- `home/dev-tools.nix` — dev packages (gcc, nodejs, python3, etc.) — not used on Arch to avoid conflicts with system packages
- `home/headless.nix` — headless/server profile: minimal server tools only

### Machines

| Config | System | Profile |
|---|---|---|
| `brian@liquidark` | x86_64-linux | common + arch + terminal + wayland |
| `brian@mac` | aarch64-darwin | common + darwin + dev-tools + terminal |
| `brian@pirateship` | aarch64-linux | common + headless |

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

### Unfree Packages

`pkgsFor` in `flake.nix` uses `allowUnfreePredicate` to allow `claude-code` specifically. Add other unfree package names there as needed.
