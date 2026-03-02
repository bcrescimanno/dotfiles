# home/darwin.nix — macOS-specific configuration.
#
# Imported by Mac machines only. Handles Homebrew shell integration,
# chruby, and the dev.sh toolchain from your existing .zshrc.

{ config, pkgs, lib, ... }:

{
  programs.zsh.initContent = ''
    # Homebrew shell environment
    [[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)

    # Shopify dev toolchain
    [ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh

    # chruby — lazy load to avoid slowing down shell startup
    [[ -f /opt/dev/sh/chruby/chruby.sh ]] && {
      type chruby >/dev/null 2>&1 || chruby () {
        source /opt/dev/sh/chruby/chruby.sh
        chruby "$@"
      }
    }
  '';
}
