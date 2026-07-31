# machines/mirkwood.nix — Pi 5 NixOS server
{ ... }:
{
  imports = [
    ../home/common.nix
    ../home/headless.nix
  ];

  dotfiles.configName = "brian@mirkwood";

  home.username = "brian";
  home.homeDirectory = "/home/brian";
}
