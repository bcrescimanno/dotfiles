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
  # Linking both ensures the theme and config are found regardless of which
  # path the app resolves to.
  home.file."Library/Application Support/com.mitchellh.ghostty" = {
    source = ../.config/ghostty;
    recursive = true;
  };

  programs.zsh.initContent = ''
	# Added by tec agent
	  [[ -x /Users/brian/.local/state/tec/profiles/base/current/global/init ]] && eval "$(/Users/brian/.local/state/tec/profiles/base/current/global/init zsh)"
# Homebrew shell environment
  '';
}
