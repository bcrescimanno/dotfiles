# machines/mac.nix — macOS
{ ... }:
{
  imports = [
    ../home/common.nix
    ../home/darwin.nix
    ../home/dev-tools.nix
    ../home/terminal.nix
  ];

  dotfiles.configName = "brian@mac";

  home.username = "brian";
  home.homeDirectory = "/Users/brian";  # macOS uses /Users not /home
}
