# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This init script contains common environment variables to set.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   This sets environment variables like $EDITOR.
#
# =============================================================================

# Editor
if command -vq nvim
	set -gx VISUAL nvim
else if command -vq vim
	set -gx VISUAL vim
else if command -vq vi
	set -gx VISUAL vi
end

set -gx EDITOR $VISUAL

