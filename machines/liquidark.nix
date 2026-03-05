# machines/archdesktop.nix — Arch Linux desktop
{ ... }:
{
  imports = [
    ../home/common.nix
    ../home/arch.nix
    ../home/terminal.nix
    ../home/wayland.nix
  ];

  home.username = "brian";
  home.homeDirectory = "/home/brian";
}
