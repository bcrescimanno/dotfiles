# machines/archdesktop.nix — Arch Linux desktop
{ pkgs, config, lib, ... }:
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
    # Clear the queue, add a YouTube stream URL, and play it immediately.
    # Usage: addliveyt <youtube-url>
    addliveyt() {
      rmpc clear && yt-dlp -g -f 'bestaudio/best' "$1" | xargs rmpc add && rmpc play
    }
  '';

  home.file.".config/rmpc/config.ron".source = ../.config/rmpc/config.ron;

  # Generate qbt-tui config at activation time by decrypting secrets/liquidark.env
  # with sops. The non-secret parts live here; credentials stay encrypted in the repo.
  # To create/update credentials: sops secrets/liquidark.env (add QBT_USERNAME, QBT_PASSWORD)
  home.activation.qbtTuiConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${config.home.homeDirectory}/.config/qbt-tui"

    secrets_file="${config.home.homeDirectory}/code/dotfiles/secrets/liquidark.env"
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
