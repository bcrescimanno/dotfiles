# machines/terra.nix — NixOS living-room games console (Jovian-NixOS: Steam
# Gaming Mode, Plasma 6 behind "Switch to Desktop"). Consumed by homelab-nix's
# hosts/terra.nix through the home-manager NixOS module, like orthanc.
#
# Deliberately just common: the desktop is Plasma, configured by its own
# defaults, so none of terminal/wayland (Hyprland, Quickshell, Ghostty) apply.
# No arch.nix since the 2026-10-09 migration off Arch.
{ ... }:
{
  imports = [
    ../home/common.nix
  ];

  dotfiles.configName = "brian@terra";

  home.username = "brian";
  home.homeDirectory = "/home/brian";
}
