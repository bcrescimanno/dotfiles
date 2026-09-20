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
# The 1Password branch deliberately sets no gpg.ssh.program: those machines
# still carry theirs in an unmanaged ~/.gitconfig. ~/.gitconfig is read AFTER
# ~/.config/git/config and wins, so on a machine switched to Bitwarden the
# `[gpg "ssh"] program = …op-ssh-sign` lines there must be deleted or they
# silently keep signing through 1Password. That same precedence means an
# allowedSignersFile left in ~/.gitconfig also overrides the managed one
# below; it is redundant now, and it hardcodes an absolute home directory,
# so delete it too.

{ config, pkgs, lib, ... }:

let
  cfg = config.dotfiles.sshAgent;

  bitwardenSocket = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";

  bwSshSign = pkgs.writeShellScript "bw-ssh-sign" ''
    export SSH_AUTH_SOCK=${bitwardenSocket}
    exec ${pkgs.openssh}/bin/ssh-keygen "$@"
  '';

  # The public half of the signing key, and the identity it signs as. Signing
  # needs only the private half in the agent; *verifying* needs this file, and
  # without it git reports every SSH-signed commit as "N" — the same output it
  # gives for a commit with no signature at all. See allowedSignersFile below.
  signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBEjcQUPpiMkeQJFlkrERftafbT/CpjaeRzbHUv/0P2W";
  signingIdentity = "brian.crescimanno@me.com";

  allowedSigners = "${config.xdg.configHome}/git/allowed_signers";
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
    #
    # This block is unconditional. Signing is agent-specific, but *verifying*
    # is not: the allowed-signers file just maps an identity to a public key,
    # and the key is the same whichever manager holds its private half. Only
    # gpg.ssh.program varies, so only it is gated on the agent.
    {
      xdg.configFile."git/config".text = lib.generators.toGitINI {
        gpg.format = "ssh";
        gpg.ssh = {
          # Without this, `git log --format=%G?` and `git verify-commit` report
          # "N" for a perfectly good signature, because git has nothing to check
          # it against. "N" therefore means "unverifiable here", NOT "unsigned":
          # to tell the two apart, look for a gpgsig header on the raw object
          # (`git cat-file commit HEAD`). Commits GitHub signs for you — merges
          # and web edits — show "E" instead, since those are GPG web-flow
          # signatures and no SSH signers file can ever verify them. Both are
          # expected and neither means a commit failed to sign.
          allowedSignersFile = allowedSigners;
        } // lib.optionalAttrs (cfg == "bitwarden") {
          program = "${bwSshSign}";
        };
        commit.gpgsign = true;
      };

      xdg.configFile."git/allowed_signers".text = ''
        ${signingIdentity} ${signingKey}
      '';
    }
  ];
}
