# home/darwin.nix — macOS-specific configuration.
#
# Imported by Mac machines only. Handles Homebrew shell integration,
# chruby, and the dev.sh toolchain from your existing .zshrc.

{ config, pkgs, lib, ... }:

{
  # `hms` comes from home/hms.nix, shared with every other machine.

  programs.zsh.initContent = ''
	# Added by tec agent
	  [[ -x /Users/brian/.local/state/tec/profiles/base/current/global/init ]] && eval "$(/Users/brian/.local/state/tec/profiles/base/current/global/init zsh)"
  '';

  # Homebrew shell environment. This belongs in .zprofile rather than .zshrc
  # because it is login-shell setup, and profileExtra is how home-manager
  # gets content into the .zprofile it generates.
  #
  # It has to be declared here rather than left to a hand-edited ~/.zprofile:
  # home-manager owns that file, so anything that writes to it directly gets
  # clobbered — or, as happened on 2026-08-25 when the tec agent replaced the
  # symlink with a real file, blocks activation entirely until the file is
  # moved aside with `home-manager switch -b backup`.
  #
  # brew shellenv does more than prepend /opt/homebrew/bin to PATH: it also
  # exports HOMEBREW_PREFIX/CELLAR/REPOSITORY, adds brew's site-functions to
  # fpath, and sets INFOPATH. The tec toolchain does not need an equivalent
  # line — its bin directory is already on PATH from the login environment.
  programs.zsh.profileExtra = ''
    [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
  '';
}
