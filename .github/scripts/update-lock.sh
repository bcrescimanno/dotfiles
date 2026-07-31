#!/usr/bin/env bash
# Update the flake inputs, keeping only an update that still evaluates.
#
# Run by .github/workflows/update-lock.yml every night, but it works the same
# way locally:  ./.github/scripts/update-lock.sh
#
# nixpkgs-unstable and home-manager/master both move fast, so an update can
# land a change that breaks evaluation for one of the machines. Rather than
# committing that and finding out at the next `hms`, this validates first and
# falls back to updating a single input if the combined update is broken.
#
# Writes a summary of what moved to $UPDATE_LOG (default: ./.update-log) so
# the workflow can use it as the commit message body.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/../.."

UPDATE_LOG="${UPDATE_LOG:-$PWD/.update-log}"

# `nix flake check` only looks at the current system, and --all-systems drags
# in the darwin devshells (valgrind is marked broken on aarch64-darwin). So:
# check this system properly, then evaluate every machine's activation package
# by hand — that catches a bad update on the Mac or the Pis from any runner.
# NOTE: every failure below is checked with an explicit `|| return 1`. These
# functions are called as `if` conditions, which turns off `set -e` inside
# them — without the explicit checks a broken update would report success.
validate() {
  nix flake check --no-build || return 1

  local machines system name
  machines=$(nix eval --raw .#checks --apply \
    'cs: with builtins; concatStringsSep "\n"
       (concatMap (s: map (n: s + " " + n) (attrNames cs.${s})) (attrNames cs))') \
    || return 1

  while read -r system name; do
    [[ -n "$system" ]] || continue
    echo "checking checks.$system.\"$name\"..."
    nix eval --raw ".#checks.\"$system\".\"$name\".drvPath" >/dev/null || return 1
  done <<< "$machines"

  echo "all machines evaluate"
}

# $@ = inputs to update; no arguments updates everything.
attempt() {
  git checkout -- flake.lock || return 1
  echo "==> updating ${*:-all inputs}"
  nix flake update "$@" 2>&1 | tee "$UPDATE_LOG" || return 1
  validate
}

if attempt; then
  :
elif attempt nixpkgs; then
  echo "note: home-manager held back — the combined update failed to evaluate"
elif attempt home-manager; then
  echo "note: nixpkgs held back — the combined update failed to evaluate"
else
  echo "error: no input can be updated on its own without breaking evaluation" >&2
  git checkout -- flake.lock
  exit 1
fi

if git diff --quiet -- flake.lock; then
  echo "flake.lock already up to date"
  exit 0
fi

# Trim the log to just the "Updated input" entries so it reads well as a
# commit message body; nix mixes progress noise into the same stream.
sed -i -n '/^•/,$p' "$UPDATE_LOG"
