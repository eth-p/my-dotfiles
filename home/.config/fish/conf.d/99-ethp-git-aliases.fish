# my-dotfiles | Copyright (C) 2024 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This init script will update my git aliases.
#
# Aliases
# -------
#
#   git lg      -- Print a terse git log.
#   git r       -- Interactive rebase.
#   git rc      -- Continue a rebase.
#   git ss      -- Short status.
#   git unstage -- Unstage files.
#   git web     -- Open the repo in GitHub.
#   git pr      -- Alias for `gh pr`.
#
# =============================================================================

if not status is-interactive
	return
end

# Only update when necessary.
set -l aliases_version 2
if test "$__ethp_git_aliases_version" = "$aliases_version"
	return
end

set -U __ethp_git_aliases_version "$aliases_version"

# Update aliases.
git config --global alias.lg 'log --oneline'
git config --global alias.r 'rebase -i --autosquash'
git config --global alias.rc 'rebase --continue'
git config --global alias.ss 'status -s'
git config --global alias.unstage 'reset HEAD --'

git config --global alias.web '!gh browse'
git config --global alias.pr '!gh pr'
