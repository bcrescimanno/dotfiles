  # The archlinux OMZ plugin provides arch helpers
  # and pacman aliases that aren't relevant on non-arch systems
  { pkgs, ... }:

  {
    programs.zsh.plugins = [
      {
        name = "archlinux";
        src = "${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/archlinux";
      }
    ];

    # Arch's nix package ships /etc/nix/nix.conf with `max-jobs = 1`, which
    # serialises every build (terra's first closure spent most of its time
    # waiting on one Rust link at a time). The user config overrides the system
    # file, and brian is a trusted-user there, so the daemon honours it.
    # Written raw rather than via `nix.settings`, which would require HM to
    # own `nix.package` on a system whose nix comes from pacman.
    xdg.configFile."nix/nix.conf".text = ''
      max-jobs = auto
    '';
  }
