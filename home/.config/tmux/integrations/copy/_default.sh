#!/usr/bin/env bash
# my-dotfiles | Copyright (C) 2022 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This script will either copy the current selection in tmux's copy mode, or
#   enter copy mode if tmux is not active.
#
# =============================================================================

tmux if-shell -t "$INTEGRATION_PANE" -F "#{selection_active}" \
	"send-keys -t '$INTEGRATION_PANE' -X copy-selection-and-cancel" \
	"copy-mode -t '$INTEGRATION_PANE'"

