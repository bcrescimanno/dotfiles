# home/darwin.nix — macOS-specific configuration.
#
# Imported by Mac machines only. Handles Homebrew shell integration,
# chruby, and the dev.sh toolchain from your existing .zshrc.

{ config, pkgs, lib, ... }:

{
  programs.zsh.shellAliases = {
    hms = "home-manager switch --flake github:bcrescimanno/dotfiles#brian@mac --refresh";
  };

  programs.zsh.initContent = ''
	# Added by tec agent
	  [[ -x /Users/brian/.local/state/tec/profiles/base/current/global/init ]] && eval "$(/Users/brian/.local/state/tec/profiles/base/current/global/init zsh)"
# Homebrew shell environment
  '';
}
