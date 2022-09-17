#!/usr/bin/env bash
# my-dotfiles | Copyright (C) 2022 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This script tells fish to change directories, using ranger to visually
#   search through the directories.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   Sends a key sequence to `fish`, which has a custom key binding that opens
#   ranger as a file picker.
#
# =============================================================================

# The key binding to send to fish.
:option: -a ICFG_OPEN_FISH_BINDING 'C-S-F12' 'o'

# -----------------------------------------------------------------------------

keys: "${ICFG_OPEN_FISH_BINDING[@]}"

