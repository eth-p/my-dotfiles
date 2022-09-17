#!/usr/bin/env bash
# my-dotfiles | Copyright (C) 2022 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This script clears the current tmux pane while the fish shell is the
#   frontmost program, making sure to re-render the prompt.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   Sends a key sequence to `fish`, which has a custom key binding that will
#   send ANSI escape sequences to clear the scrollback buffer and screen.
#
# =============================================================================

# The key binding to send to fish.
:option: -a ICFG_CLEAR_FISH_BINDING 'C-S-F12' 'k'

# -----------------------------------------------------------------------------

keys: "${ICFG_CLEAR_FISH_BINDING[@]}"

