#!/usr/bin/env bash
# my-dotfiles | Copyright (C) 2022 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This script tells ranger to exit to exit.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   Presses Control-C to return to normal mode, then presses the 'q' key
#   binding to quit ranger.
#
# =============================================================================

# The key binding to send to nvim.
:option: -a ICFG_EXIT_RANGER_BINDING 'C-c' 'q'

# -----------------------------------------------------------------------------

for key in "${ICFG_EXIT_RANGER_BINDING[@]}"; do
	keys: "$key"
	sleep 0.05  # Ranger takes a little while to act.
done

