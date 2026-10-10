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
    #
    # Bounded, not `auto`: `auto` with the default `cores = 0` lets 16 jobs
    # each use every core — up to 256 compiler threads on liquidark. Thirty
    # minutes after that went live (2026-10-09), terra's closure build hard-froze
    # the machine with kernel `Bad page state` errors in cc1plus and nix-daemon.
    # memtest86+ confirmed it (2026-10-10): the EXPO I memory profile fails
    # within one pass and hard-locks; JEDEC passes. EXPO is now off in the
    # BIOS, and that was the fix — not this cap. 4 × 4 stays because it keeps
    # total build threads near nproc. If liquidark crashes under a build,
    # check first whether EXPO is back on.
    xdg.configFile."nix/nix.conf".text = ''
      max-jobs = 4
      cores = 4
    '';

    # Nothing on Arch collects Nix garbage (NixOS hosts get nix.gc from the
    # system), and this machine builds orthanc's and terra's full closures on
    # every deploy. With 219 home-manager generations pinning old closures the
    # root fs hit 100% (2026-10-09). A user timer is enough: generations live in
    # brian's profile, and the collection itself runs through the daemon.
    # nix.package is null here, so HM runs pkgs.nix's nix-collect-garbage,
    # which only speaks the daemon protocol — the pacman version is unaffected.
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
      persistent = true;
    };
  }
