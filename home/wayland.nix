# home/wayland.nix — Wayland/Linux desktop configuration.
#
# Imported by Linux machines with a graphical Wayland environment.
# Handles Hyprland, Quickshell, Mako, wleave, uwsm, and elephant.

{ config, pkgs, lib, ... }:

{
  home.file.".config/hypr" = {
    source = ../.config/hypr;
    recursive = true;
  };

  home.file.".config/mako" = {
    source = ../.config/mako;
    recursive = true;
  };

  # Quickshell lives in its own repo (~/code/liquidark-shell) and is
  # symlinked live so edits take effect without re-running home-manager.
  #
  # SETUP REQUIRED: clone before running home-manager switch:
  #   git clone https://github.com/bcrescimanno/liquidark-shell ~/code/liquidark-shell
  home.file.".config/quickshell" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/liquidark-shell";
  };

  home.file.".config/wleave" = {
    source = ../.config/wleave;
    recursive = true;
  };

  home.file.".config/uwsm" = {
    source = ../.config/uwsm;
    recursive = true;
  };

  home.file.".config/elephant" = {
    source = ../.config/elephant;
    recursive = true;
  };
}
