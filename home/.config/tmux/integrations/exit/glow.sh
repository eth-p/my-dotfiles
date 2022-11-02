#!/usr/bin/env bash
# my-dotfiles | Copyright (C) 2022 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This script tells glow to exit with the 'q' key.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   Presses "q" to exit glow.
#
# =============================================================================

# The key binding to send to nvim.
:option: -a ICFG_EXIT_GLOW_BINDING 'q'

# -----------------------------------------------------------------------------

keys: "${ICFG_EXIT_GLOW_BINDING[@]}"

