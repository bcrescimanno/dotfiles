# home/terminal.nix — terminal emulator configuration.
#
# Cross-platform: imported by all machines with a graphical environment.
# Handles Ghostty and Alacritty config symlinking.

{ config, pkgs, lib, ... }:

let
  # Generate platform-specific ghostty config
  # Linux: JetBrainsMono Nerd Font Mono, size 13
  # macOS: JetBrainsMono Nerd Font Regular, size 14
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  fontFamily = if isDarwin then "JetBrainsMono Nerd Font Regular" else "JetBrainsMono Nerd Font Mono";
  fontSize = if isDarwin then "14" else "13";
  ghosttyConfig = ''
    font-size = ${fontSize}
    font-family = ${fontFamily}

    background-opacity = 0.95
    background-blur = true

    theme = Dracula

    window-padding-x = 10
    window-padding-y = 10

    window-height = 40
    window-width = 90
  '';
in
{
  home.file.".config/alacritty" = {
    source = ../.config/alacritty;
    recursive = true;
  };

  home.file.".config/ghostty/config" = {
    text = ghosttyConfig;
  };
}
