# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This init script moves the first prompt line to the bottom of the
#   terminal window (or tmux pane) and draws a separator before it.
#   
# How it's used in my-dotfiles
# ----------------------------
#
#   This is good for consistency, and it helps to draw a boundary between
#   the greeting messages (if configured) and the prompt itself.
#   
# =============================================================================

if status is-interactive && test "$ethp_prompt_startup_at_bottom" = "true"

	function __ethp_prompt_at_bottom \
		--description="Move the cursor to the bottom of the screen and draw a separator"

		# Move the cursor to the bottom of the terminal.
		printf "\x1B[%s;%sH\x1B[K" (math $LINES - 1) 1

		# Draw a separator.
		printf "%s%s%s\n" \
			(printf "\x1B[2m") \
			(string repeat --count=$COLUMNS -- '-') \
			(set_color reset)

		# Clear the line.
		printf "\x1B[K"
	end

	# Before drawing the first prompt, move the cursor to the bottom
	# of the screen and draw the separator.
	function __ethp_prompt_at_bottom_on_startup --on-event='fish_prompt'
		functions -e __ethp_prompt_at_bottom_on_startup
		__ethp_prompt_at_bottom
	end

	# Hook the `fish-contextual-greeting` greetings.
	function contextual_greeting:post
		functions -e __ethp_prompt_at_bottom_on_startup
		__ethp_prompt_at_bottom
	end

	# Rewrite the end of the `__ethp_integration_clear_screen` function
	# to draw the separator whenever the clear integration is used.
	if functions --query __ethp_integration_clear_screen
		functions __ethp_integration_clear_screen \
			| sed -e '$d' \
			| sed -e '$a\
	# From ~/.config/fish/conf.d/25-ethp-greetings.fish\
	# Reset to the bottom of the terminal.\
	__ethp_prompt_at_bottom\
end' | source
	end

end

