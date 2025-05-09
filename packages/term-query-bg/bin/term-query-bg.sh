#!/usr/bin/env bash
# my-dotfiles | Copyright (C) 2021-2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Summary
# -------
#
#   A bash script that will attempt to query the terminal or environment to
#   determine if the terminal is using a dark or light background color.
#
#   Supported mechanisms:
#     1. OSC 11                                             (Best)
#     2. COLORFGBG                                          (Okay)
#     3. Guessing based on the terminal emulator defaults.  (Bad)
#     4. When in doubt, assume black.                       (Worst)
#
#   If no arguments are provided, a luminosity formula will be used on the
#   query response, and "dark" or "light" will be printed to standard output.
#
# Arguments
# ---------
#
#   $1  [--dump]    # Dump query info and exit.
#
# =============================================================================
set -euo pipefail

# -----------------------------------------------------------------------------
# Queries
# -----------------------------------------------------------------------------

# OSC 11: Query background color.
# Used in xterm to report the background color.
query_with_osc11() {
	ANSI_QUERY_DA1=$'\x1B[c'
	ANSI_QUERY_BG=$'\x1B]11;?\a'

	# If we're running inside tmux, tmux won't respond to OSC 11 queries even
	# if the terminal emulator supports them.
	# https://github.com/tmux/tmux/issues/1919
	#
	# We need to ask tmux to query the terminal on our behalf.
	if [[ -n "${TMUX:-}" ]] && _tmux_version_is_older_than 3.1; then
		ANSI_QUERY_DA1=$'\x1BPtmux;\x1B\x1B[c\x1B\\'
		ANSI_QUERY_BG=$'\x1BPtmux;\x1B\x1B]11;?\a\x1B\\'
	fi

	# Enter no-echo terminal mode and send OSC11 followed by DA1.
	# https://github.com/bash/terminal-colorsaurus
	_echo_off
	printf "%s" "$ANSI_QUERY_BG" >>/dev/tty
	printf "%s" "$ANSI_QUERY_DA1" >>/dev/tty

	# Attempt to read back the response within 2 seconds.
	# The terminal will send OSC11 response (if supported), then DA1.
	{
		read -r -t1 -d'?' upto_da1_start
		read -r -t1 -d'c' upto_da1_end
	} </dev/tty

	response="${upto_da1_start}?${upto_da1_end}c"
	_echo_on

	# Did we get a response that matches the pattern:
	#   ^[]11;rgb:RRRR:GGGG:BBBB
	#   ^[]11;rgba:RRRR:GGGG:BBBB:AAAA
	if [[ "$response" =~ ^$'\x1B']11\;rgba?:([a-fA-F0-9]{2,4})/([a-fA-F0-9]{2,4})/([a-fA-F0-9]{2,4})(/[a-fA-F0-9]{2,4})? ]]; then
		BG_METHOD=osc11

		local set_fn=
		case "${#BASH_REMATCH[1]}" in
		4) set_fn=_set_rgb16_hex ;;
		3) set_fn=_set_rgb12_hex ;;
		2) set_fn=_set_rgb8_hex ;;
		*) return 1 ;;
		esac

		"$set_fn" "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" "${BASH_REMATCH[3]}"
		return 0
	fi

	# Didn't get a response.
	return 1
}

# Environment variable: COLORFGBG
# Not as useful, but it will work if the terminal won't respond to OSC 11.
query_with_colorfgbg() {
	if [[ -z "${COLORFGBG:-}" ]]; then
		return 1
	fi

	if [[ "$COLORFGBG" =~ ^([0-9]+)\;([0-9]+)$ ]]; then
		# local TEXT_FG="${BASH_REMATCH[1]}"
		local TEXT_BG="${BASH_REMATCH[2]}"

		case "$TEXT_BG" in
		0) _set_rgb8_hex '00' '00' '00' ;;  # Black
		1) _set_rgb8_hex '80' '00' '00' ;;  # Red
		2) _set_rgb8_hex '00' '80' '00' ;;  # Green
		3) _set_rgb8_hex '80' '80' '00' ;;  # Yellow
		4) _set_rgb8_hex '00' '00' '80' ;;  # Blue
		5) _set_rgb8_hex '80' '00' '80' ;;  # Magenta
		6) _set_rgb8_hex '00' '80' '80' ;;  # Cyan
		7) _set_rgb8_hex 'c0' 'c0' 'c0' ;;  # White
		8) _set_rgb8_hex '80' '80' '80' ;;  # Bright Black
		9) _set_rgb8_hex 'ff' '00' '00' ;;  # Bright Red
		10) _set_rgb8_hex '00' 'ff' '00' ;; # Bright Green
		11) _set_rgb8_hex 'ff' 'ff' '00' ;; # Bright Yellow
		12) _set_rgb8_hex '00' '00' 'ff' ;; # Bright Blue
		13) _set_rgb8_hex 'ff' '00' 'ff' ;; # Bright Magenta
		14) _set_rgb8_hex '00' 'ff' 'ff' ;; # Bright Cyan
		15) _set_rgb8_hex 'ff' 'ff' 'ff' ;; # Bright White
		*)
			printf "unknown background color: %s\n" "$TEXT_BG" 1>&2
			return 1
			;;
		esac

		BG_METHOD="colorfgbg # ansi ${TEXT_BG}"
		return 0
	fi

	# Doesn't match the expected pattern.
	return 1
}

# Try to guess based on the terminal defaults.
# Last resort query method.
query_with_guesses() {

	# macOS Terminal -> Default White
	if [[ "${TERM_PROGRAM:-}" = "Apple_Terminal" ]]; then
		BG_METHOD="guess # Terminal.app"
		_set_rgb8_hex 'FF' 'FF' 'FF'
		return 0
	fi

	# iTerm -> Default Black
	if [[ "${TERM_PROGRAM:-}" = "iTerm.app" ]]; then
		BG_METHOD="guess # iTerm.app"
		_set_rgb8_hex '00' '00' '00'
		return 0
	fi

	# Alacritty -> Default #1d1f21
	if [[ "${__CFBundleIdentifier:-}" = "io.alacritty" ]]; then
		BG_METHOD="guess # alacritty"
		_set_rgb8_hex '1d' '1f' '21'
		return 0
	fi

	# Termux -> Default Black
	if [[ -n "${TERMUX_VERSION:-}" ]]; then
		BG_METHOD="guess # termux"
		_set_rgb8_hex '00' '00' '00'
		return 0
	fi

	# No idea.
	return 1
}

# Small utility to set the BG_* variables from 3 8-bit RGB hex numbers.
# shellcheck disable=SC2317
_set_rgb8_hex() {
	BG_RED="$(((16#$1) * 257))"
	BG_GREEN="$(((16#$2) * 257))"
	BG_BLUE="$(((16#$3) * 257))"
}

# Small utility to set the BG_* variables from 3 12-bit RGB hex numbers.
# shellcheck disable=SC2317
_set_rgb12_hex() {
	BG_RED="$(((16#$1) * 16 + (16#$1) / 256))"
	BG_GREEN="$(((16#$2) * 16 + (16#$2) / 256))"
	BG_BLUE="$(((16#$3) * 16 + (16#$3) / 256))"
}

# Small utility to set the BG_* variables from 3 16-bit RGB hex numbers.
# shellcheck disable=SC2317
_set_rgb16_hex() {
	BG_RED="$((16#$1))"
	BG_GREEN="$((16#$2))"
	BG_BLUE="$((16#$3))"
}

# Small utility to enable/disable input echo.
if command -v stty &>/dev/null; then
	_echo_off() { stty -echo; }
	_echo_on() { stty echo; }
else
	_echo_off() { :; }
	_echo_on() { :; }
fi

# Small utility to check tmux version.
_tmux_version() {
	if [[ -z "${TMUX_VERSION:-}" ]]; then
		TMUX_VERSION="$(tmux -V | cut -d' ' -f2)"
	fi

	printf "%s\n" "$TMUX_VERSION"
}

_tmux_version_is_older_than() {
	local vers
	vers="$(printf "%s\n%s\n" "$1" "$(_tmux_version)" | sort -V | head -n1)"
	[[ "$vers" == "$1" ]] || return 0
	return 1
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

BG_METHOD=default
BG_RED=0
BG_GREEN=0
BG_BLUE=0

# Get the color shorts.
query_with_osc11 ||
	query_with_colorfgbg ||
	query_with_guesses ||
	true

# If $1 is '--dump', just dump the info for the consumer.
if [[ "$#" -eq 1 ]] && [[ "$1" = "--dump" ]]; then
	printf "BG_QUERY=%s\n" "$BG_METHOD"
	printf "BG_MIN=0\n"
	printf "BG_MAX=65535\n"

	printf "%s=%s\n" \
		"BG_COLOR_R" "$BG_RED" \
		"BG_COLOR_G" "$BG_GREEN" \
		"BG_COLOR_B" "$BG_BLUE"

	exit 0
fi

# Determine if the background is closer to black or white.
# Formula: (Y = 0.2126*R + 0.7152*G + 0.0722*B) < 0.5 ? black : white
#
# Since bash doesn't support decimals, we need to approximate it with fixed points.
# Using an accuracy of 4 decimal places, we end up with:
#
#   0.2126*R =~ R/(1/0.2126)  # Simplified to: R/4.7037
#   0.7152*G =~ G/(1/0.7152)  # Simplified to: G/1.3982
#   0.0722*B =~ B/(1/0.0722)  # Simplified to: G/13.8504
#
# Sum < 32767 ? black : white
FPMUL=10000
LUM_R="$(((BG_RED * FPMUL) / 47037))"
LUM_G="$(((BG_GREEN * FPMUL) / 13982))"
LUM_B="$(((BG_BLUE * FPMUL) / 138504))"

if [[ "$((LUM_R + LUM_G + LUM_B))" -ge 32767 ]]; then
	echo "light"
else
	echo "dark"
fi

exit 0
