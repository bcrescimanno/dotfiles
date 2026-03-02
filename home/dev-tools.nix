# home/dev-tools.nix — development tools managed by Nix.
#
# Imported by NixOS and macOS machines where Nix owns the user environment.
# For Arch systems, we'll leave this out to avoid conflicts

{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gcc
    gnumake
    nodejs
    python3
    curl
    wget
    unzip
    tree
    nerd-fonts.jetbrains-mono
  ];
}
