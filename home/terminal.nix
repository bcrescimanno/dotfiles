# home/terminal.nix — terminal emulator configuration.
#
# Cross-platform: imported by all machines with a graphical environment.
# Handles Ghostty and Alacritty config symlinking.

{ config, pkgs, lib, ... }:

{
  home.file.".config/alacritty" = {
    source = ../.config/alacritty;
    recursive = true;
  };

  home.file.".config/ghostty" = {
    source = ../.config/ghostty;
    recursive = true;
  };
}
