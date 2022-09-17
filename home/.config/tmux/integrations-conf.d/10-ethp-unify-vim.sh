# my-dotfiles | Copyright (C) 2022 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   Rewrite the `$INTEGRATION_PROGRAM` so that `vi`, `vim`, and `nvim` are all
#   treated as `nvim`.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   This makes sure all the integration scripts behave the same for vim/nvim.
#
# =============================================================================

case "$INTEGRATION_PROGRAM" in
	vi|vim|nvim) INTEGRATION_PROGRAM="nvim" ;;
esac

