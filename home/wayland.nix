# home/wayland.nix — Wayland/Linux desktop configuration.
#
# Imported by Linux machines with a graphical Wayland environment.
# Handles Hyprland, Quickshell, Mako, wleave, uwsm, and elephant.

{ config, pkgs, lib, ... }:

let
  walkerTheme = "dracula";

  wleaveTheme = "dracula";

  wleaveThemeColors = {
    dracula = {
      window_bg = "rgba(40, 42, 54, 0.9)";
      text_fg = "#f8f8f2";
      btn_bg = "#44475a";
      btn_border = "#6272a4";
      btn_hover = "#6272a4";
      btn_focus = "#bd93f9";
      btn_active = "#bd93f9";
      btn_active_text = "#282a36";
      shutdown = "#ff5555";
      hibernate = "#8be9fd";
      reboot = "#50fa7b";
      lock = "#f1fa8c";
      logout = "#ffb86c";
      suspend = "#ff79c6";
    };
    catppuccin-mocha = {
      window_bg = "rgba(30, 30, 46, 0.9)";
      text_fg = "#cdd6f4";
      btn_bg = "#313244";
      btn_border = "#45475a";
      btn_hover = "#585b70";
      btn_focus = "#b4befe";
      btn_active = "#b4befe";
      btn_active_text = "#1e1e2e";
      shutdown = "#f38ba8";
      hibernate = "#89b4fa";
      reboot = "#a6e3a1";
      lock = "#f9e2af";
      logout = "#fab387";
      suspend = "#f5c2e7";
    };
  };

  wleaveCurrentTheme = wleaveThemeColors.${wleaveTheme};
in
{
  home.file.".config/hypr" = {
    source = ../.config/hypr;
    recursive = true;
  };

  home.file.".config/mako" = {
    source = ../.config/mako;
    recursive = true;
  };

  # Quickshell lives in its own repo (~/code/liquidark-shell) and is
  # symlinked live so edits take effect without re-running home-manager.
  #
  # SETUP REQUIRED: clone before running home-manager switch:
  #   git clone https://github.com/bcrescimanno/liquidark-shell ~/code/liquidark-shell
  home.file.".config/quickshell" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/liquidark-shell";
  };

  # Generate walker config with configurable theme
  # Theme can be "dracula" or "catppuccin-mocha"
  home.file.".config/walker/config.toml" = {
    text = "theme = \"${walkerTheme}\"\n";
  };

  home.file.".config/walker/themes/${walkerTheme}/style.css" = {
    source = ../.config/walker/themes/${walkerTheme}/style.css;
  };

  # wleave layout (static) + generated theme CSS
  home.file.".config/wleave/layout.json" = {
    source = ../.config/wleave/layout.json;
  };

  home.file.".config/wleave/style.css" = {
    text = ''
      /* ${wleaveTheme} theme for wleave */

      * {
          font-family: monospace;
      }

      window {
          background-color: ${wleaveCurrentTheme.window_bg};
      }

      button {
          color: ${wleaveCurrentTheme.text_fg};
          background-color: ${wleaveCurrentTheme.btn_bg};
          border: 2px solid ${wleaveCurrentTheme.btn_border};
          border-radius: 8px;
          padding: 10px;
      }

      button label.action-name {
          font-size: 24px;
      }

      button label.keybind {
          font-size: 20px;
          font-family: monospace;
          color: ${wleaveCurrentTheme.btn_border};
      }

      button:hover label.keybind,
      button:focus label.keybind {
          opacity: 1;
          color: ${wleaveCurrentTheme.text_fg};
      }

      button:focus,
      button:hover {
          background-color: ${wleaveCurrentTheme.btn_hover};
          border-color: ${wleaveCurrentTheme.btn_focus};
      }

      button:active {
          background-color: ${wleaveCurrentTheme.btn_active};
          color: ${wleaveCurrentTheme.btn_active_text};
      }

      button#shutdown {
          color: ${wleaveCurrentTheme.shutdown};
      }

      button#hibernate {
          color: ${wleaveCurrentTheme.hibernate};
      }

      button#reboot {
          color: ${wleaveCurrentTheme.reboot};
      }

      button#lock {
          color: ${wleaveCurrentTheme.lock};
      }

      button#logout {
          color: ${wleaveCurrentTheme.logout};
      }

      button#suspend {
          color: ${wleaveCurrentTheme.suspend};
      }
    '';
  };

  home.file.".config/uwsm" = {
    source = ../.config/uwsm;
    recursive = true;
  };

  home.file.".config/elephant" = {
    source = ../.config/elephant;
    recursive = true;
  };

  # Prevent ALSA audio devices from suspending after idle, which causes
  # crackling/dropout on resume.
  home.file.".config/wireplumber/wireplumber.conf.d/disable-suspension.conf" = {
    source = ../.config/wireplumber/wireplumber.conf.d/disable-suspension.conf;
  };

  # Route portal requests to hyprland (screenshots/screencasting) and gtk
  # (file chooser, print, notifications, etc.) now that xdg-desktop-portal-gnome
  # is no longer present.
  home.file.".config/xdg-desktop-portal/portals.conf" = {
    source = ../.config/xdg-desktop-portal/portals.conf;
  };
}
