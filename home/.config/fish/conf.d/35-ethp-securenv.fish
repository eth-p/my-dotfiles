# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This init script wraps various commands to include sensitive environment
#   variables that they will need.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   This adds shell command aliases.
#
# =============================================================================

if functions -q securenv

	set -l variables (securenv list --porcelain)

	if contains "GITHUB_TOKEN" $variables
		securenv wrap goreleaser GITHUB_TOKEN
	end

end

