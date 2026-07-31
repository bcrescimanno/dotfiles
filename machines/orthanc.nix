# machines/orthanc.nix — x86_64 NixOS tower (remote builder, Minecraft server)
{ ... }:
{
  imports = [
    ../home/common.nix
    ../home/dev-tools.nix
    ../home/headless.nix
  ];

  dotfiles.configName = "brian@orthanc";

  home.username = "brian";
  home.homeDirectory = "/home/brian";
}
