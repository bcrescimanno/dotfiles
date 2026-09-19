---
name: Hyprland reload race on new require()
description: adding a new Lua file that hyprland.lua require()s makes hms leave a stale "module not found" error — fix is hyprctl reload, not a rebuild
type: feedback
---

When a change adds a NEW file under `.config/hypr/rules/` (or anywhere) AND a
`require()` for it in `hyprland.lua`, `hms` can leave Hyprland showing
`module 'rules.<name>' not found` even though the file is deployed. Hyprland
auto-reloads the moment the new `hyprland.lua` symlink lands, before HM has
linked the new rule file, and the error overlay sticks from that moment.
Seen 2026-09-19 adding `rules/bitwarden.lua`.

**Why:** it looks exactly like the file is missing from the Nix build (e.g. an
untracked or `git add -N` file), which sends you down the wrong path.

**How to apply:** check `readlink -f ~/.config/hypr/rules/<name>.lua` exists
and `hyprctl configerrors`; if the file is there, `hyprctl reload` clears it.
Tell Brian to expect this (and to run `hyprctl reload`) whenever a change adds
a new required Lua file.
