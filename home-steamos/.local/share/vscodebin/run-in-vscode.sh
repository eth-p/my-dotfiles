#!/usr/bin/env bash
# my-dotfiles | Copyright (C) 2024 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Warning
# -------
#
#    This script is meant to run on a Steam Deck!
#    DO NOT INSTALL IT ON OTHER SYSTEMS.
#
# Summary
# -------
#
#    A for running a development tool within the VS Code Flatpak's instance.
#    If the tool is available outside the Flatpak, this will use that instead.
#
#
# =============================================================================
set -euo pipefail
source "${HOME}/.local/lib/ethp-flatpak-utils.sh"

FLATPAK_ID="${FLATPAK_ID:-com.visualstudio.code}"
COMMAND_NAME="$(basename -- "$0")"
COMMAND_FILE="$(which -a "$COMMAND_NAME" 2>/dev/null | sed '1d' | head -n1 || true)"

# Run the native command.
if [[ -n "$COMMAND_FILE" ]]; then
	exec -a "$COMMAND_NAME" "$COMMAND_FILE" "$@"
fi

# Fetch the correct Flatpak instance, if not already provided.
if [[ -z "${FLATPAK_INSTANCE:-}" ]]; then
	if ! flatpak:is_running "$FLATPAK_ID"; then
		printf "%s: Visual Studio Code is not running" "$COMMAND_NAME" 1>&2
		exit 128
	fi

	FLATPAK_INSTANCE="$(flatpak:instances "$FLATPAK_ID" | head -n1)"
fi

# Run the command provided within the Flatpak instance.
FLATPAK_ID="${FLATPAK_ID:-com.visualstudio.code}"
flatpak enter "$FLATPAK_INSTANCE" \
	bash -c "cd $(printf '%q' "$(pwd)"); exec $(printf '%q ' "$COMMAND_NAME" "$@")"
exit $?
