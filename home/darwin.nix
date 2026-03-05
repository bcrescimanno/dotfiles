# home/darwin.nix — macOS-specific configuration.
#
# Imported by Mac machines only. Handles Homebrew shell integration,
# chruby, and the dev.sh toolchain from your existing .zshrc.

{ config, pkgs, lib, ... }:

{
  programs.zsh.shellAliases = {
    hms = "home-manager switch --flake github:bcrescimanno/dotfiles#brian@mac --refresh";
  };

  # Ghostty on macOS uses ~/Library/Application Support/com.mitchellh.ghostty/
  # rather than ~/.config/ghostty/ (which is what desktop.nix links).
  home.file."Library/Application Support/com.mitchellh.ghostty/themes" = {
    source = ../.config/ghostty/themes;
    recursive = true;
  };

  # Generate the config from the base, bumping font-size by 1 for macOS
  # (font rendering differs from Linux — macOS needs 14 where Linux uses 13).
  home.file."Library/Application Support/com.mitchellh.ghostty/config".text =
    builtins.replaceStrings [ "font-size = 13" ] [ "font-size = 14" ]
      (builtins.readFile ../.config/ghostty/config);

  programs.zsh.initContent = ''
	# Added by tec agent
	  [[ -x /Users/brian/.local/state/tec/profiles/base/current/global/init ]] && eval "$(/Users/brian/.local/state/tec/profiles/base/current/global/init zsh)"
# Homebrew shell environment
  '';
}
