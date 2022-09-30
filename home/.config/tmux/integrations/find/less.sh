#!/usr/bin/env bash
# my-dotfiles | Copyright (C) 2022 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This script tells less to search forwards.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   Presses the key required to enter search mode in less.
#
# =============================================================================

# The key binding to send to less.
:option: -a ICFG_FIND_LESS_BINDING 'Escape' 'Escape' '/'

# -----------------------------------------------------------------------------

tmux send-key "${ICFG_FIND_LESS_BINDING[@]}"

