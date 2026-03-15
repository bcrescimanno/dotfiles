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

  # Send a webhook to Home Assistant on wake from sleep to turn on the office LG TV monitor.
  # The ExecStop trick: service "runs" (no-op) when sleep.target activates, and ExecStop
  # fires on wake when sleep.target deactivates.
  systemd.user.services.ha-wake-office-monitor = {
    Unit = {
      Description = "Wake office TV via Home Assistant on resume from sleep";
      After = [ "sleep.target" ];
      StopWhenUnneeded = true;
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = "${pkgs.coreutils}/bin/true";
      ExecStop = ''${pkgs.curl}/bin/curl -s -o /dev/null -X POST "http://ha.theshire.io/api/webhook/turn-on-office-monitor-jcSb2lDHuFG9AMsf-4ky8kbt"'';
    };
    Install = {
      WantedBy = [ "sleep.target" ];
    };
  };
}
