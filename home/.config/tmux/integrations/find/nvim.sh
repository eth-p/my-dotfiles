#!/usr/bin/env bash
# my-dotfiles | Copyright (C) 2022 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This script tells nvim to search for a string in the current buffer.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   Sends a key sequence to `nvim`, which has a custom key binding that starts
#   a regular expression search.
#
# =============================================================================

# The key binding to send to nvim.
:option: -a ICFG_FIND_NVIM_BINDING 'C-S-F12' 'f'

# -----------------------------------------------------------------------------

keys: "${ICFG_FIND_NVIM_BINDING[@]}"

