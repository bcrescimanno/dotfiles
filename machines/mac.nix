# machines/mac.nix — macOS
{ ... }:
{
  imports = [
    ../home/common.nix
    ../home/darwin.nix
    ../home/dev-tools.nix
    ../home/desktop.nix
  ];

  home.username = "brian";
  home.homeDirectory = "/Users/brian";  # macOS uses /Users not /home
}
