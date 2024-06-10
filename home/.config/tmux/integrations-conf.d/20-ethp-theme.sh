# my-dotfiles | Copyright (C) 2022 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   Customizes the theme of the integrations.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   Changes the theme to match my tmux config more closely.
#
# =============================================================================

# shellcheck disable=SC2034
case "${TERM_BG:-dark}" in
dark) {
	INTEGRATION_ERROR_STYLE='bg=colour52 fill=colour52 fg=colour252'
	ICFG_EXIT_PROMPT_STYLE='bg=colour94 fill=colour94 fg=colour254'
} ;;

light) {
	: # TODO
} ;;
esac

