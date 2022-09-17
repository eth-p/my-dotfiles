#!/usr/bin/env bash
# my-dotfiles | Copyright (C) 2022 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This script tells nvim to save the current buffer.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   Sends a key sequence to `nvim`, which has a custom key binding that saves
#   the current file and returns to the mode it was in previously.
#
# =============================================================================

# The key binding to send to nvim.
:option: -a ICFG_SAVE_NVIM_BINDING 'C-S-F12' s

# -----------------------------------------------------------------------------

keys: "${ICFG_SAVE_NVIM_BINDING[@]}"

