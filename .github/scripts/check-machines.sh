#!/usr/bin/env bash
# Evaluate every machine's home-manager configuration.
#
# Run by .github/workflows/check.yml on every push, and by update-lock.sh
# before it accepts a flake.lock update. Works locally too:
#   ./.github/scripts/check-machines.sh
#
# `nix flake check` on its own only covers the system it runs on, and
# --all-systems doesn't work here — the cpp devshell pulls in valgrind, which
# nixpkgs marks broken on aarch64-darwin. So check this system properly, then
# evaluate each machine's activation package by hand. Evaluation is
# cross-platform even though building isn't, so one Linux runner can catch a
# change that breaks the Mac or the Pis.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/../.."

nix flake check --no-build

machines=$(nix eval --raw .#checks --apply \
  'cs: with builtins; concatStringsSep "\n"
     (concatMap (s: map (n: s + " " + n) (attrNames cs.${s})) (attrNames cs))')

while read -r system name; do
  [[ -n "$system" ]] || continue
  echo "checking checks.$system.\"$name\"..."
  nix eval --raw ".#checks.\"$system\".\"$name\".drvPath" >/dev/null || exit 1
done <<< "$machines"

echo "all machines evaluate"
