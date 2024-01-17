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
#    A for running a development tool within the VS Code flatpak's instance.
#    If the tool is available outside the flatpak, this will use that instead.
#
#
# =============================================================================
set -euo pipefail
COMMAND_NAME="$(basename -- "$0")"
COMMAND_FILE="$(which -a "$COMMAND_NAME" 2>/dev/null | sed '1d' | head -n1 || true)"

# Run the native command.
if [[ -n "$COMMAND_FILE" ]]; then
	exec -a "$COMMAND_NAME" "$COMMAND_FILE" "$@"
fi

# Ensure that this was executed from a flatpak instance.
if [[ -z "${FLATPAK_INSTANCE:-}" ]]; then
	printf "%s: environment must originate from VS Code instance\n" "$COMMAND_NAME" 1>&2
	exit 128
fi

# Run the flatpak'ed command.
FLATPAK_ID="${FLATPAK_ID:-com.visualstudio.code}"
flatpak enter "$FLATPAK_INSTANCE" \
	bash -c "cd $(printf '%q' "$(pwd)"); exec $(printf '%q ' "$COMMAND_NAME" "$@")"
exit $?
