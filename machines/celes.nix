# machines/celes.nix — Arch Linux laptop
{ pkgs, config, lib, ... }:
{
  imports = [
    ../home/common.nix
    ../home/arch.nix
    ../home/terminal.nix
    ../home/wayland.nix
  ];

  home.username = "brian";
  home.homeDirectory = "/home/brian";

  # Laptop display: tighter wleave margins and smaller fonts than the desktop
  wayland.wleave = {
    margins = { top = 400; bottom = 400; left = 300; right = 300; };
    fontSizeAction  = 18;
    fontSizeKeybind = 14;
  };

  home.file.".config/hypr/hyprland.lua".source = ../.config/hypr/hyprland-celes.lua;

  # Battery-aware idle policy: hypridle-smart picks hypridle-ac.conf or
  # hypridle-battery.conf based on /sys/class/power_supply/ACAD/online.
  home.file.".config/hypr/hypridle-battery.conf".source = ../.config/hypr/hypridle-battery.conf;

  home.file.".config/systemd/user/hypridle.service.d/use-smart-wrapper.conf".text = ''
    [Service]
    ExecStart=
    ExecStart=%h/.config/bin/hypridle-smart
  '';

  systemd.user.services.hypridle-power-watch = {
    Unit = {
      Description = "Restart hypridle when AC state changes";
      After = [ "hypridle.service" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "%h/.config/bin/hypridle-power-watch";
      Restart = "always";
      RestartSec = "5";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # AMD-primary hybrid laptop: no global NVIDIA GLX vars (those activate the dGPU
  # for every GTK4 app). Use __NV_PRIME_RENDER_OFFLOAD=1 per-launch for games.
  home.file.".config/uwsm/env".source = ../.config/uwsm/env-celes;

  # hyprpaper links against libGLESv2 (libglvnd), which enumerates all EGL vendor
  # ICDs at startup — including NVIDIA's, which opens /dev/nvidia0 and wakes the
  # dGPU. Restrict it to Mesa-only EGL so only the AMD render node is used.
  home.file.".config/systemd/user/hyprpaper.service.d/restrict-gpu.conf".text = ''
    [Service]
    Environment="__EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json"
  '';

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

  home.packages = [ pkgs.rmpc ];

  programs.zsh.initContent = ''
    hms() {
      if [[ -f ~/code/dotfiles/flake.nix ]]; then
        home-manager switch --flake ~/code/dotfiles#brian@celes
      else
        home-manager switch --flake github:bcrescimanno/dotfiles#brian@celes --refresh
      fi
    }

    addliveyt() {
      rmpc clear && yt-dlp -g -f 'bestaudio/best' "$1" | xargs rmpc add && rmpc play
    }
  '';

  home.file.".config/rmpc/config.ron".source = ../.config/rmpc/config.ron;

  # Generates qbt-tui config at activation time. Credentials stay encrypted in
  # secrets/celes.env (sops). Create/update with: sops secrets/celes.env
  home.activation.qbtTuiConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${config.home.homeDirectory}/.config/qbt-tui"

    secrets_file="${config.home.homeDirectory}/code/dotfiles/secrets/celes.env"
    if [ -f "$secrets_file" ]; then
      eval "$(/usr/bin/sops -d "$secrets_file")"
    fi

    cat > "${config.home.homeDirectory}/.config/qbt-tui/config.toml" << EOF
[server]
url = "http://pirateship:9091"
username = "''${QBT_USERNAME:-}"
password = "''${QBT_PASSWORD:-}"
refresh_interval = 3
EOF
    chmod 600 "${config.home.homeDirectory}/.config/qbt-tui/config.toml"
  '';
}
