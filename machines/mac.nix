# machines/mac.nix — macOS
{ ... }:
{
  imports = [
    ../home/common.nix
    ../home/darwin.nix
    ../home/dev-tools.nix
    ../home/desktop.nix
  ];

  home.username = "bcrescimanno";
  home.homeDirectory = "/Users/bcrescimanno";  # macOS uses /Users not /home
}
