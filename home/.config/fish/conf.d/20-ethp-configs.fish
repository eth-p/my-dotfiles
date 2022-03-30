# my-dotfiles | Copyright (C) 2021-2022 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This init script will set default config vars for some fish utilities.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   This sets up bettercd.
#
# =============================================================================

if status is-interactive && functions -q session_var kubeswitch

	if not set -q bettercd_resolve; set -g bettercd_resolve "fzf,z"; end
	if not set -q bettercd_tiebreak; set -g bettercd_tiebreak "z,common,fzf"; end

end

