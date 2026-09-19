# home/ssh-agent.nix — which password manager holds the SSH key.
#
# The key lives in a password manager, never on disk, and the manager's agent
# does both SSH auth and git commit signing. Each machine picks the manager
# with `dotfiles.sshAgent`; the default is 1Password so machines that have not
# been migrated keep working untouched.
#
# Bitwarden (desktop app → Settings → Enable SSH agent) listens on
# ~/.bitwarden-ssh-agent.sock. That is the path for the native Linux package
# and the macOS direct-download build. The Mac App Store build is sandboxed and
# uses ~/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock
# instead, and the Flatpak cannot expose the socket usefully at all — install
# the native package.
#
# Git signing needs more than IdentityAgent. `ssh-keygen -Y sign`, which git
# runs for gpg.format=ssh, finds its agent through $SSH_AUTH_SOCK and ignores
# ~/.ssh/config entirely — and on the Arch desktops $SSH_AUTH_SOCK is GNOME
# Keyring's gcr agent, which does not hold the key. 1Password solves this with
# its own op-ssh-sign binary; for Bitwarden, bw-ssh-sign below does the same
# thing by pointing SSH_AUTH_SOCK at the Bitwarden socket for that one call,
# leaving the rest of the session alone.
#
# The 1Password branch deliberately sets no git config: those machines still
# carry gpg.ssh.program in their unmanaged ~/.gitconfig. ~/.gitconfig is read
# AFTER ~/.config/git/config and wins, so on a machine switched to Bitwarden
# the `[gpg "ssh"] program = …op-ssh-sign` lines there must be deleted or they
# silently keep signing through 1Password.

{ config, pkgs, lib, ... }:

let
  cfg = config.dotfiles.sshAgent;

  bitwardenSocket = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";

  bwSshSign = pkgs.writeShellScript "bw-ssh-sign" ''
    export SSH_AUTH_SOCK=${bitwardenSocket}
    exec ${pkgs.openssh}/bin/ssh-keygen "$@"
  '';
in

{
  options.dotfiles.sshAgent = lib.mkOption {
    type = lib.types.enum [ "1password" "bitwarden" ];
    default = "1password";
    description = "Password manager whose SSH agent handles SSH auth and git signing.";
  };

  config = lib.mkMerge [
    {
      programs.ssh.settings."*".IdentityAgent =
        if cfg == "bitwarden" then "~/.bitwarden-ssh-agent.sock"
        else if pkgs.stdenv.hostPlatform.isDarwin
        then "~/Library/Group\\ Containers/2BUA8C4S2C.com.1password/t/agent.sock"
        else "~/.1password/agent.sock";
    }

    # Written as a raw file, NOT via programs.git.settings: programs.git is
    # not enabled in this repo (common.nix sets settings but never `enable`),
    # so those settings are never rendered. Enabling it would also start
    # applying common.nix's global core.hooksPath, which bypasses every
    # repo's own .git/hooks — a separate decision. If programs.git is ever
    # enabled, move this into programs.git.settings; HM will refuse to build
    # with both defining git/config, so the clash cannot go unnoticed.
    (lib.mkIf (cfg == "bitwarden") {
      xdg.configFile."git/config".text = lib.generators.toGitINI {
        gpg.format = "ssh";
        gpg.ssh.program = "${bwSshSign}";
        commit.gpgsign = true;
      };
    })
  ];
}
