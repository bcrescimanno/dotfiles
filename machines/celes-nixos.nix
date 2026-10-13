# machines/celes-nixos.nix — celes (ASUS Zephyrus G14 laptop) on NixOS with
# Plasma 6. Consumed by homelab-nix's hosts/celes.nix through the home-manager
# NixOS module, like terra.
#
# A separate file from machines/celes.nix on purpose: that one still serves
# the Arch install until the wipe. Once celes runs NixOS, celes.nix is deleted
# and this takes over its name.
#
# No wayland.nix: the desktop is Plasma, configured by its own defaults, so
# Hyprland, Quickshell, uwsm and the hypridle battery/AC split do not apply —
# Plasma's power settings own idle and per-source brightness now. No arch.nix.
# terminal.nix stays for the Ghostty/Alacritty/Vesktop configs; on NixOS the
# apps themselves come from home.packages below (on Arch, pacman installed
# them). The JetBrainsMono Nerd Font Ghostty asks for, and Lutris (it pulls in
# unfree Steam runtime pieces, which only the host allows), are in
# hosts/celes.nix.
{ config, pkgs, lib, ... }:
{
  imports = [
    ../home/common.nix
    ../home/terminal.nix
  ];

  dotfiles.configName = "brian@celes-nixos";

  # SSH auth + git signing through the Bitwarden desktop agent. The app is a
  # system package in hosts/celes.nix. See home/ssh-agent.nix.
  dotfiles.sshAgent = "bitwarden";

  home.username = "brian";
  home.homeDirectory = "/home/brian";

  home.packages = with pkgs; [
    ghostty
    vesktop
    yazi
    yt-dlp
    rmpc
  ];

  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
    extraConfig = ''
      bind_to_address "/tmp/mpd_socket"

      audio_output {
        type "pipewire"
        name "PipeWire"
      }

    '';
  };

  services.mpdris2.enable = true;

  programs.zsh.initContent = ''
    addliveyt() {
      rmpc clear && yt-dlp -g -f 'bestaudio/best' "$1" | xargs rmpc add && rmpc play
    }
  '';

  home.file.".config/rmpc/config.ron".source = ../.config/rmpc/config.ron;
}
