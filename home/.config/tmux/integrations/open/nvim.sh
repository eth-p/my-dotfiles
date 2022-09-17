#!/usr/bin/env bash
# my-dotfiles | Copyright (C) 2022 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This script tells nvim to open a new file instead of the current buffer.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   Sends a key sequence to `nvim`, which has a custom key binding that opens
#   ranger as a file picker.
#
# =============================================================================

# The key binding to send to nvim.
:option: -a ICFG_OPEN_NVIM_BINDING 'C-S-F12' 'o'

# -----------------------------------------------------------------------------

keys: "${ICFG_OPEN_NVIM_BINDING[@]}"

