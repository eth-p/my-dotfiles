# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This init script sets up a theme using the my_theme function.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   The theme chosen will depend on the terminal's background color,
#   which is determined in the `~/.config/fish/conf.d/3-ethp-query-term.fish`
#   init script.
#
# =============================================================================

if [ -n "$TERM_BG" ]
	my_theme --style="$TERM_BG"
end

# -----------------------------------------------------------------------------
# Wrap the `reset` command to call my_theme after resetting.
# -----------------------------------------------------------------------------

if functions -q reset
	functions --copy reset __ethp_original_reset_2
else
	function reset
		command reset
		return $status
	end
end

function reset
	__ethp_original_reset_2
	set -l reset_status $status
	if [ -n "$TERM_BG" ]
		my_theme --style="$TERM_BG"
	end
	return $reset_status
end

# -----------------------------------------------------------------------------
# Use wrappers to only pass huge environment variables to commands that
# would actually use them.
# -----------------------------------------------------------------------------

function exa --wraps="exa"
	LS_COLORS="$THEME_LS_COLORS" EXA_COLORS="$THEME_EXA_COLORS" \
	command exa $argv
	return $status
end

function ls --wraps="ls"
	LS_COLORS="$THEME_LS_COLORS" \
	command ls $argv
	return $status
end

