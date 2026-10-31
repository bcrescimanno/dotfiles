#!/usr/bin/env bash
# SessionEnd hook: leave the main working tree on main.
#
# `hms` builds from whatever ~/code/dotfiles has checked out, so a session that
# ends on a stale branch silently deploys that branch's config.
#
# This never discards anything. Uncommitted changes come along to main, and if
# git refuses the switch (conflicting changes, a rebase in progress) the tree
# stays where it is with a warning. It also doesn't fetch: a session has to be
# able to end offline, or with a stale ssh ControlMaster.

# /clear and --resume end a session without ending the work in progress.
reason=$(jq -r '.reason // empty' 2>/dev/null)
case "$reason" in clear | resume) exit 0 ;; esac

# The first entry is always the main working tree, even from a linked worktree.
repo=$(git -C "${CLAUDE_PROJECT_DIR:-$PWD}" worktree list --porcelain | sed -n '1s/^worktree //p')
[[ -n "$repo" ]] || exit 0

if [[ "$(git -C "$repo" symbolic-ref --short -q HEAD)" != main ]]; then
  if ! git -C "$repo" switch --quiet main; then
    echo "return-to-main: $repo is not on main; git refused the switch" >&2
    exit 0
  fi
fi

# Pick up what the session merged, as far as the last fetch knows about it.
git -C "$repo" merge --ff-only --quiet origin/main 2>/dev/null
exit 0
