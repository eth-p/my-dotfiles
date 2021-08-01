# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This init script contains custom key bindings for performing useful
#   or repetitive actions.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   It provides some of the key bindings that I use for certain tasks.
#   Note: other keybindings might be added elsewhere from fish plugins.
#
# =============================================================================

# M-C-K -> Clear the scrollback buffer and repaint the prompt.
bind \e\cK 'printf "\x1B[2J\x1B[3J\x1B[H"; commandline -f repaint'

# C-q -> Change directory to a ranger bookmark.
if command -vq ranger
	bind \cq 'cd-ranger --bookmark-hotkey'
end

