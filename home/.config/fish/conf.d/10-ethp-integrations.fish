# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This init script contains key bindings that will be sent by tmux or
#   the various `tmux-*` scripts in `~/.local/libexec`.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   The key binding sequences are sent by tmux to perform actions from the
#   context menu or from tmux's own key bindings.
#
# =============================================================================

# Leader Sequence: C-<F12>

# <Leader> ec -> Visual change directory.
# This opens `ranger` to select a new directory to change to.
bind \e'[24;5~ec' 'cd-ranger; commandline -f repaint'

# <Leader> ek -> Clear screen.
# This clears the screen.
bind \e'[24;5~ek' '__ethp_integration_clear_screen'
function __ethp_integration_clear_screen
	printf "\x1B[2J\x1B[3J\x1B[H";
	commandline -f repaint
end

