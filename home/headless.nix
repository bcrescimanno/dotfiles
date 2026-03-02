# home/server.nix — headless server profile.
#
# Imported by machines without a graphical environment (the Pi).
# Contains only what makes sense on a headless server — no GUI app configs,
# no desktop tools, no Wayland/X11 dependencies.
#
# The common.nix module already handles zsh, neovim, tmux, and fzf
# which are all useful on a server. This file intentionally stays minimal.

{ config, pkgs, lib, ... }:

{
  # Server-specific packages — things useful for homelab management
  home.packages = with pkgs; [
    htop
    ncdu      # disk usage analyzer
    lsof
  ];
}
