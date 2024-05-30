# my-dotfiles | Copyright (C) 2024 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   Optionally draws a newline before the fish prompt.
#
#   When using the Visual Studio Code integrated terminal, this is forced
#   enabled. The user's text will be placed on the line after the prompt,
#   and this adds much-needed separation between commands.
#
# =============================================================================

if status is-interactive

	function __ethp_prompt_line_before \
		--description="Draws a newline before the prompt" \
		--on-event fish_prompt

		if test "$ethp_prompt_inline" = "false" || \
			test -n "$VSCODE_INJECTION"
			printf "\n"
		end
	end

end

