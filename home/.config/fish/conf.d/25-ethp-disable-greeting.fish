# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This init script will disable the fish greeting whenever a new pane is
#   created in tmux. The greeting will only be showed when tmux starts.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   When `~/.local/libexec/tmux-new-window` creates a new shell instance,
#   the environment variable $INIT_TMUX_PANE_CREATOR (or $TMUX_PANE_CREATOR)
#   is set. The existence of this variable tells the script that the new shell
#   instance is not the first tmux pane, and therefore should not have a
#   greeting message. 
#
# =============================================================================

if [ -n "$TMUX_PANE_CREATOR" ] || [ -n "$INIT_TMUX_PANE_CREATOR" ]
	function fish_greeting
		# This shell instance was created from tmux split-pane or tmux 
		# create-window, and should not have a greeting message.
		#
		# Disabled by ~/.config/fish/conf.d/25-ethp-disable-greeting.fish
	end
end

