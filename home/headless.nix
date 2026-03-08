# home/headless.nix — headless server profile.
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

  # On headless servers we never edit dotfiles locally, so home-manager
  # always pulls from GitHub rather than a local clone.
  programs.zsh.initContent = ''
    hm() {
      nix run github:nix-community/home-manager -- switch \
        --flake github:bcrescimanno/dotfiles#brian@$(hostname)
    }
  '';
}
