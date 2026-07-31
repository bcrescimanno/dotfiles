# home/hms.nix — the `hms` command, defined once for every machine.
#
# Imported by common.nix, so every machine gets the same `hms`. Each machine
# file only has to say which homeConfigurations entry it is:
#
#   dotfiles.configName = "brian@liquidark";
#
# `hms` is meant to always mean "switch me to the latest dotfiles", which is
# why it goes out of its way to defeat caching:
#
#   * On a machine with no clone it builds straight from GitHub with
#     --refresh. Without that, nix reuses its cached copy of the flake for
#     tarball-ttl (an hour by default) and you'd silently get a stale build.
#     The nightly .github/workflows/update-lock.yml job keeps the flake.lock
#     on main fresh, so "latest on GitHub" also means "latest packages".
#
#   * On a machine with a clone at ~/code/dotfiles the clone wins — that's a
#     machine where dotfiles get edited, and building from GitHub would throw
#     away uncommitted work. It fast-forwards the clone first so `hms` still
#     picks up the nightly lock update, but it never touches a dirty tree and
#     never does anything that could lose a commit: a --ff-only pull either
#     works or is skipped with a warning.
#
# home-manager is normally on PATH (programs.home-manager.enable in
# common.nix), but on a machine that has never switched yet it isn't, so
# fall back to `nix run` to bootstrap.

{ config, lib, ... }:

{
  options.dotfiles.configName = lib.mkOption {
    type = lib.types.str;
    example = "brian@liquidark";
    description = ''
      The homeConfigurations attribute in flake.nix that describes this
      machine. Used by `hms`. This is not always derivable from the hostname
      (the Mac is "brian@mac"), so each machine states it explicitly.
    '';
  };

  config.programs.zsh.initContent = ''
    hms() {
      local flake="github:bcrescimanno/dotfiles"
      local repo="$HOME/code/dotfiles"
      local -a refresh=(--refresh)

      if [[ -f "$repo/flake.nix" ]]; then
        # --untracked-files=no: an untracked file is not work a fast-forward
        # can lose. If one is genuinely in the way, the pull below fails and
        # takes the same "build it as-is" path.
        if [[ -n "$(git -C "$repo" status --porcelain --untracked-files=no)" ]]; then
          echo "hms: $repo has uncommitted changes, building it as-is" >&2
        elif ! git -C "$repo" pull --ff-only --quiet; then
          echo "hms: could not fast-forward $repo, building it as-is" >&2
        fi
        flake="$repo"
        refresh=()   # a local path is read fresh every time
      fi

      if command -v home-manager >/dev/null 2>&1; then
        home-manager switch --flake "$flake#${config.dotfiles.configName}" "''${refresh[@]}"
      else
        nix run github:nix-community/home-manager -- \
          switch --flake "$flake#${config.dotfiles.configName}" "''${refresh[@]}"
      fi
    }
  '';
}
