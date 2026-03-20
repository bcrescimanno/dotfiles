# machines/terra.nix — Arch Linux living room gaming PC (Gnome + Steam Big Picture)
{ ... }:
{
  imports = [
    ../home/common.nix
    ../home/arch.nix
  ];

  home.username = "brian";
  home.homeDirectory = "/home/brian";
}
