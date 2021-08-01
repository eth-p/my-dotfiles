# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
# 
# Summary
# -------
#
#   A function which sets up environment variables to configure command
#   line programs with a dark or light theme, depending on the terminal's
#   background color.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   This is used by `~/.config/fish/conf.d/20-ethp-theme.fish` to set a
#   a theme based on the background color determined by the
#   `~/.config/fish/conf.d/3-ethp-query-term.fish` init script.
#
# =============================================================================

function my_theme
	argparse 'style=' -- $argv
	if [ -z "$_flag_style" ]
		echo "my_theme: argument '--style' is required" 1>&2
		return 1
	end

	switch "$_flag_style"
		case "dark"
			__ethp_theme_dark
			return 0

		# case "light"
			# TODO
	end
	
	# Unknown style.
	printf "my_theme: unknown style '%s'\n" "$_flag_style"
	return 1
end

function __ethp_theme_dark
	set -gx TERM_BG "$_flag_style"

	# ls/exa
	set -g THEME_EXA_COLORS "da=39:uu=37:un=33:ur=97:uw=39:ux=1;32:ue=39:tw=31:tr=33:tx=2;39:gr=2;39:gw=2;39:gx=2;39;"
	if command -vq vivid
		set -g THEME_LS_COLORS (vivid generate molokai)
	end

	# bat
	set -gx BAT_THEME "Monokai Extended"

	# prompt
	__promptfessional_theme dark
end

