# machines/archdesktop.nix — Arch Linux desktop
{ ... }:
{
  imports = [
    ../home/common.nix
    ../home/desktop.nix
  ];

  home.username = "brian";
  home.homeDirectory = "/home/brian";
}
