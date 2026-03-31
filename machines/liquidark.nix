# machines/archdesktop.nix — Arch Linux desktop
{ pkgs, config, ... }:
{
  imports = [
    ../home/common.nix
    ../home/arch.nix
    ../home/terminal.nix
    ../home/wayland.nix
    ../home/red-tools.nix
  ];

  home.username = "brian";
  home.homeDirectory = "/home/brian";

  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
    # dataDir defaults to ~/.local/share/mpd — kept local, not on the NFS mount
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire"
      }

    '';
  };

  services.mpdris2.enable = true;

  home.packages = [ pkgs.rmpc ];

  home.file.".config/rmpc/config.ron".source = ../.config/rmpc/config.ron;

  # Watch the org.freedesktop.login1 PrepareForSleep D-Bus signal (sleep.target is not
  # propagated to user sessions) to turn the LG TV on/off with the PC's sleep state.
  systemd.user.services.ha-wake-office-monitor = {
    Unit = {
      Description = "Sync office TV power with PC sleep state via Home Assistant";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      Restart = "always";
      RestartSec = "5s";
      ExecStart = pkgs.writeShellScript "ha-wake-office-monitor" ''
        echo "ha-wake-office-monitor starting"
        ${pkgs.coreutils}/bin/stdbuf -oL \
          ${pkgs.glib}/bin/gdbus monitor --system \
            --dest org.freedesktop.login1 \
            --object-path /org/freedesktop/login1 |
        while IFS= read -r line; do
          echo "gdbus: $line"
          if [[ "$line" == *"PrepareForSleep"* && "$line" == *"(true,"* ]]; then
            echo "System suspending, sending HA webhook to turn off TV"
            ${pkgs.curl}/bin/curl -s -o /dev/null -X POST \
              "https://ha.theshire.io/api/webhook/-w-w6s79g0HHEqzwzAojp0eFo" \
              && echo "Webhook sent successfully" || echo "Webhook failed"
          elif [[ "$line" == *"PrepareForSleep"* && "$line" == *"(false,"* ]]; then
            echo "System woke, waiting for network"
            /usr/bin/nm-online -q -t 60
            echo "Network up, sending HA webhook to turn on TV"
            ${pkgs.curl}/bin/curl -s -o /dev/null -X POST \
              "https://ha.theshire.io/api/webhook/-1sWoVviIgzQKboQI2mJJfT20" \
              && echo "Webhook sent successfully" || echo "Webhook failed"
          fi
        done
        echo "ha-wake-office-monitor: gdbus exited"
      '';
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
