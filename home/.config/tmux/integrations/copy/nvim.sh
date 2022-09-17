#!/usr/bin/env bash
# my-dotfiles | Copyright (C) 2022 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This script tells nvim to copy the current visual selection to the system
#   clipboard.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   Sends a key sequence to `nvim`, which has a custom key binding to handle
#   the copy integration.
#
# =============================================================================

# The key binding to send to nvim.
:option: -a ICFG_COPY_NVIM_BINDING 'F5'

# -----------------------------------------------------------------------------

keys: "${ICFG_COPY_NVIM_BINDING[@]}"

