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
    programs.zsh.shellAliases = {
      hms = "home-manager switch --flake github:bcrescimanno/dotfiles#brian@liquidark --refresh";
    };
  }

