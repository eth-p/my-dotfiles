# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This init script wraps a couple of commands to alter their behaviour or fix
#   up a couple small issues.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   * Makes tmux use fish as the default shell.
#   * Makes bat use 'less --quit-if-one-screen'
#
# =============================================================================

# Tmux: Use fish as the default shell
if command -vq tmux
	
	function tmux --wraps=tmux
		SHELL=(command -v fish) command tmux $argv || return $status
	end

end

# Bat: Use 'less --quit-if-one-screen'
if command -vq bat || command -vq batcat
	set -l bat_executable batcat
	if not command -vq "$bat_executable"; set bat_executable bat; end

	function bat --wraps=bat --inherit-variable='bat_executable'
		set -lx LESS "$LESS --quit-if-one-screen"
		command "$bat_executable" $argv
		return $status
	end

end

