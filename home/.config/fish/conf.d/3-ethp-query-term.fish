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
#   Additionally, this wraps the `reset` command to update the "$TERM_BG"
#   variable whenever its called.
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
		
		# Hook into the `reset` command to update the TERM_BG variable.
		if functions -q reset
			functions --copy reset __ethp_original_reset
		else
			function __ethp_original_reset
				command reset
				return $status
			end
		end

		function reset
			__ethp_original_reset
			set -l reset_status $status
			set -gx TERM_BG (
				bash "$HOME/.local/libexec/term-query-bg" 2>/dev/null \
				|| echo "dark"
			)
			return $status
		end
	end

end

