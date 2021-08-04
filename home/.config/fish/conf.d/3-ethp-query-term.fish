# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This init script will query the background color of the user's terminal
#   emulator, and set the "$TERM_BG" color to either "dark" or "light"
#   depending on what the query returned.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   This allows TUI programs to smartly adapt to different background colors.
#
# =============================================================================

if status is-interactive

	if [ -f "$HOME/.local/libexec/term-query-bg" ]
		set -gx TERM_BG (
			bash "$HOME/.local/libexec/term-query-bg" 2>/dev/null \
			|| echo "dark"
		)
	end

end

