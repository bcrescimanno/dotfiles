# machines/rivendell.nix — Pi 5 NixOS server
{ ... }:
{
  imports = [
    ../home/common.nix
    ../home/headless.nix
  ];

  dotfiles.configName = "brian@rivendell";

  home.username = "brian";
  home.homeDirectory = "/home/brian";
}
