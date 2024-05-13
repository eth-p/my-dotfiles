# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   When using the Visual Studio Code integrated terminal, the user's text
#   will be placed on the line after the prompt. This forces a line to be
#   drawn before the prompt, too.
#
# =============================================================================

if status is-interactive && test -n "$VSCODE_INJECTION"

	function __ethp_prompt_line_before \
		--description="Draws a newline before the prompt" \
		--on-event fish_prompt

		printf "\n"
	end

end
