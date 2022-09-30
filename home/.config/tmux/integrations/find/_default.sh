#!/usr/bin/env bash
# my-dotfiles | Copyright (C) 2022 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This script opens tmux copy mode and searches backwards.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   Tells tmux to enter copy mode and sends the key sequence for searching.
#
# =============================================================================

# The key binding to send to tmux.
:option: -a ICFG_FIND_TMUX_BINDING '?'

# -----------------------------------------------------------------------------

tmux copy-mode
tmux send-key "${ICFG_FIND_TMUX_BINDING[@]}"

