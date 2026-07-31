# machines/terra.nix — Arch Linux living room gaming PC (Hyprland + Steam Big Picture)
{ ... }:
{
  imports = [
    ../home/common.nix
    ../home/arch.nix
  ];

  dotfiles.configName = "brian@terra";

  home.username = "brian";
  home.homeDirectory = "/home/brian";
}
