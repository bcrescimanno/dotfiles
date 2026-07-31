# machines/pirateship.nix — Pi 5 NixOS server
{ ... }:
{
  imports = [
    ../home/common.nix
    ../home/dev-tools.nix
    ../home/headless.nix
  ];

  dotfiles.configName = "brian@pirateship";

  home.username = "brian";
  home.homeDirectory = "/home/brian";
}
