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

# Validation lives in check-machines.sh so this and the push-triggered
# workflow can't drift apart. Running it as a separate process also keeps it
# honest: `attempt` is called as an `if` condition, which turns off `set -e`
# inside it, but the child script has its own.
#
# NOTE: for the same reason, every failure below needs an explicit
# `|| return 1` — without it a broken update would report success.
#
# $@ = inputs to update; no arguments updates everything.
attempt() {
  git checkout -- flake.lock || return 1
  echo "==> updating ${*:-all inputs}"
  nix flake update "$@" 2>&1 | tee "$UPDATE_LOG" || return 1
  ./.github/scripts/check-machines.sh
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
