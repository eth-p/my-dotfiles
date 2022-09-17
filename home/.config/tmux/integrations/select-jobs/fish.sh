#!/usr/bin/env bash
# my-dotfiles | Copyright (C) 2022 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This script opens the job selector in the fish shell.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   Sends a key sequence to `fish`, which has a custom key binding that opens
#   a dialog for bringing background jobs to the foreground.
#
# =============================================================================

# The key binding to send to fish.
:option: -a ICFG_SELECT_JOBS_FISH_BINDING 'C-S-F12' 'j'

# -----------------------------------------------------------------------------

keys: "${ICFG_SELECT_JOBS_FISH_BINDING[@]}"

