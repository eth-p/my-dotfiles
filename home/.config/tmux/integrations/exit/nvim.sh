#!/usr/bin/env bash
# my-dotfiles | Copyright (C) 2022 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This script tells nvim to exit with the ':q' command.
#   If the buffer is not saved, nvim will respectfully refuse to exit.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   Presses escape twice to return to normal mode, then enters command mode
#   with the command ':q'` and presses enter to run it.
#
# =============================================================================

# The key binding to send to nvim.
:option: -a ICFG_EXIT_NVIM_BINDING 'Escape' 'Escape' ':q' 'Enter'

# -----------------------------------------------------------------------------

keys: "${ICFG_EXIT_NVIM_BINDING[@]}"

