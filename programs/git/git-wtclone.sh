#!/usr/bin/env bash
set -euo pipefail

repo="${1?Repository URL is required as the first argument}"
dir="${2:-$(basename -- "$repo" .git)}"

# Clone the directory as a bare repository and ensure that the remote fetch
# refspec is set to fetch all branches.
# git clone --bare "$repo" "${dir}/.git"
git -C "$dir" config --local remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git -C "$dir" fetch

# Find the default branch and create a worktree for it.
def_branch="$(git -C "$dir" symbolic-ref refs/remotes/origin/HEAD | sed 's,^refs/remotes/origin/,,')"
git -C "$dir" worktree add "$def_branch" "$def_branch"
