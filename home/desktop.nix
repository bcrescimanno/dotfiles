# home/desktop.nix — desktop/GUI configuration.
#
# Imported by machines with a graphical environment. Handles Hyprland,
# Waybar, Alacritty, Ghostty, Mako, and other GUI app configs.
# This is deliberately NOT imported by headless.nix (the Pi).

{ config, pkgs, lib, ... }:

{
  # The archlinux OMZ plugin is desktop-only — it provides AUR helpers
  # and pacman aliases that aren't relevant on a server.
  programs.zsh.oh-my-zsh.plugins = [ "archlinux" ];

  # Place GUI app config directories using home.file.
  # These are symlinked from your dotfiles repo so edits are live.

  home.file.".config/alacritty" = {
    source = ../.config/alacritty;
    recursive = true;
  };

  home.file.".config/ghostty" = {
    source = ../.config/ghostty;
    recursive = true;
  };

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

  home.file.".config/waybar" = {
    source = ../.config/waybar;
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
