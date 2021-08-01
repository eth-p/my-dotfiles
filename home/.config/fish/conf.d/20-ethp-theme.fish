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

my_theme --style="$TERM_BG"

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

