# machines/archdesktop.nix — Arch Linux desktop
{ pkgs, ... }:
{
  imports = [
    ../home/common.nix
    ../home/arch.nix
    ../home/terminal.nix
    ../home/wayland.nix
  ];

  home.username = "brian";
  home.homeDirectory = "/home/brian";

  # Watch for system wake-from-sleep via the org.freedesktop.login1 PrepareForSleep D-Bus
  # signal (sleep.target is not propagated to user sessions). When PrepareForSleep fires
  # with "boolean false", the system just woke — send the HA webhook to turn on the LG TV.
  systemd.user.services.ha-wake-office-monitor = {
    Unit = {
      Description = "Wake office TV via Home Assistant on resume from sleep";
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
          if [[ "$line" == *"PrepareForSleep"* && "$line" == *"(false,"* ]]; then
            echo "System woke, waiting for network"
            /usr/bin/nm-online -q -t 60
            echo "Network up, sending HA webhook"
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
