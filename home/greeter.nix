# home/greeter.nix — the greetd login screen: ReGreet inside a Hyprland greeter.
#
# Home-manager can only write under ~, and ~ is mode 700, so nothing it links
# there is readable by the `greeter` user that greetd runs the login screen
# as. This module gets around that by publishing the greeter's files as a
# Nix profile instead:
#
#   /nix/var/nix/profiles/per-user/<user>/greeter -> /nix/store/...-greeter
#
# The store is world-readable, and everything under /nix/var/nix/profiles is
# a GC root, so the greeter can read it and nix-collect-garbage won't delete
# it. Activation re-points the profile on every `hms`.
#
# The one file that cannot live in the profile is /etc/greetd/config.toml.
# greetd reads it as root, and it names the user and command the login screen
# runs, so letting a user-writable profile supply it would let anything
# running as you get root on the next boot without a sudo password. It is
# generated here but *copied* into /etc by `greeter-install`, under sudo, and
# activation warns when the installed copy has drifted from this one. It only
# points at the profile's hyprland.lua, so it rarely changes.
#
# When changes take effect:
#   * hyprland.lua, regreet.toml, regreet.css — the next time the greeter
#     starts, i.e. after logging out or rebooting. No sudo needed.
#   * config.toml — after `greeter-install`, on the next greetd start
#     (a reboot; restarting greetd kills your session).
#
# SETUP REQUIRED once per machine, after the first `hms`:
#   greeter-install
#
# Everything the greeter loads (themes, fonts, cursors, the regreet binary)
# has to come from /usr, since the greeter can't see into ~ either.
#
# The background image is the one exception, and it gets its own profile,
# <profileDir>/greeter-background. It's the same file hyprlock uses, which
# lives in ~/Pictures rather than the repo (at 25MB it would ride along on
# every machine's `hms`), so it can't be part of the evaluated config. Instead
# activation copies it into the store with `nix-store --add` and points that
# profile at it. regreet.toml names the profile, so a new image shows up on
# the next greeter start like any other change. If the file is missing,
# activation warns and the greeter falls back to its plain background.

{ config, pkgs, lib, ... }:

let
  cfg = config.dotfiles.greeter;

  profileDir = "/nix/var/nix/profiles/per-user/${config.home.username}";
  profile = "${profileDir}/greeter";

  bgProfile = "${profileDir}/greeter-background";

  regreetToml = pkgs.writeText "regreet.toml" (
    builtins.readFile ../.config/greetd/regreet.toml
    + lib.optionalString (cfg.background != null) ''

      [background]
      path = "${bgProfile}"
      fit = "Cover"
    ''
  );
  regreetCss = ../.config/greetd/regreet.css;

  # hyprland.lua names regreet's files by store path, not through the
  # profile, so each generation is self-consistent.
  hyprlandLua = pkgs.writeText "greeter-hyprland.lua" ''
    hl.on("hyprland.start", function()
    	hl.exec_cmd("regreet --config ${regreetToml} --style ${regreetCss}; hyprctl dispatch 'hl.dsp.exit()'")
    end)

    ${cfg.monitors}

    hl.config({
    	misc = {
    		disable_hyprland_logo = true,
    		disable_splash_rendering = true,
    		disable_hyprland_guiutils_check = true,
    	},
    })
  '';

  # This one goes through the profile on purpose: config.toml is installed by
  # hand, so it should never need reinstalling just because the greeter's
  # look changed.
  configToml = pkgs.writeText "greetd-config.toml" ''
    # Managed by home/greeter.nix in the dotfiles repo. Do not edit here:
    # change it there, run `hms`, then `greeter-install`.

    [terminal]
    vt = 1

    [default_session]
    command = "start-hyprland -- -c ${profile}/hyprland.lua"
    user = "greeter"
  '';

  greeter = pkgs.linkFarm "greeter" {
    "config.toml" = configToml;
    "hyprland.lua" = hyprlandLua;
    "regreet.toml" = regreetToml;
    "regreet.css" = regreetCss;
  };

  # Points both profiles at this generation's files. Shared by activation and
  # greeter-install, which runs it after creating profileDir.
  greeterPublish = pkgs.writeShellScript "greeter-publish" (''
    set -euo pipefail

    setProfile() {
      if [ "$(readlink -f "$1" || true)" != "$2" ]; then
        nix-env --profile "$1" --set "$2"
      fi
    }

    setProfile ${profile} ${greeter}
  '' + lib.optionalString (cfg.background != null) ''

    bg=${lib.escapeShellArg cfg.background}
    if [ -f "$bg" ]; then
      setProfile ${bgProfile} "$(nix-store --add "$bg")"
    else
      echo "greeter: background $bg not found; the greeter will use a plain background" >&2
    fi
  '');

  greeterInstall = pkgs.writeShellScriptBin "greeter-install" ''
    set -euo pipefail

    if [ ! -d ${profileDir} ]; then
      echo "Creating ${profileDir} (sudo)"
      sudo install -d -m 0755 -o "$(id -un)" -g "$(id -gn)" ${profileDir}
    fi

    ${greeterPublish}

    if cmp -s ${configToml} /etc/greetd/config.toml; then
      echo "/etc/greetd/config.toml is already up to date"
    else
      echo "Installing /etc/greetd/config.toml (sudo)"
      if [ -e /etc/greetd/config.toml ]; then
        sudo cp -a /etc/greetd/config.toml /etc/greetd/config.toml.bak
        echo "  previous version saved as /etc/greetd/config.toml.bak"
      fi
      sudo install -m 0644 -o root -g root ${configToml} /etc/greetd/config.toml
      echo "Takes effect the next time greetd starts (reboot)."
    fi
  '';
in
{
  options.dotfiles.greeter.background = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = ''
      Absolute path to the greeter's background image. A string, not a path,
      so it is read at activation time instead of being copied from the flake.
    '';
  };

  options.dotfiles.greeter.monitors = lib.mkOption {
    type = lib.types.lines;
    default = "";
    description = ''
      hl.monitor(...) calls for the greeter's Hyprland. Machine-specific, like
      the session's own hyprland.lua; empty means Hyprland's preferred modes.
    '';
  };

  config = {
    home.packages = [ greeterInstall ];

    home.activation.greeterProfile = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -w ${profileDir} ]; then
        run ${greeterPublish}
      else
        warnEcho "greeter: ${profileDir} does not exist yet; run greeter-install"
      fi

      if ! cmp -s ${configToml} /etc/greetd/config.toml; then
        warnEcho "greeter: /etc/greetd/config.toml differs from the managed copy; run greeter-install"
      fi
    '';
  };
}
