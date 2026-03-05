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

  home.file.".config/quickshell" = {
    source = ../.config/quickshell;
    recursive = true;
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
