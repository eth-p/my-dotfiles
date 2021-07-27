#!/usr/bin/env bash
# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
set -euo pipefail

HERE="$(cd "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
COPY_FROM="$1"
COPY_TO="$2"
CACHE_DIR="$(pwd)/.install/cache"
CACHE_FILE="$CACHE_DIR/$COPY_FROM"

# -----------------------------------------------------------------------------
# Functions:
# -----------------------------------------------------------------------------

# Prints a message.
msg() {
	printf "%s\n" "$@"
}

# Prints a warning message.
msg_w() {
	printf "\x1B[33m%s\x1B[0m\n" "$@"
}

# Prints a message if $VERBOSE is not empty.
vmsg() {
	if [[ -n "${VERBOSE:-}" ]]; then
		msg "$@" 1>&2
	fi
}

# Copies a file, creating the parent directories if necessary.
cp() {
	local dest_parent="$(dirname -- "$2")"
	if ! [[ -d "$dest_parent" ]]; then
		vmsg "Creating directory: $dest_parent"
		mkdir -p "$dest_parent"
	fi

	command cp "$1" "$2" || return $?
}

# Copies a cache file.
cp_cache() {
	VERBOSE= cp "$@"
}

# Copies a file, only if $INSTALL is not "dry".
cp_install() {
	if [[ "${INSTALL:-}" != "dry" ]]; then
		cp "$@" || return $?
	fi
}

# Movies a file, only if $INSTALL is not "dry".
mv_install() {
	if [[ "${INSTALL:-}" != "dry" ]]; then
		mv "$@" || return $?
	fi
}

# Prompts the user for a choice.
# $1 -- The prompt message.
# $2 -- The prompt options. The default should be in caps.
prompt() {
	local message="$1"
	local options="$2"
	local options_array
	local choice
	local option

	# Determine the default option.
	local option_default="$(sed 's/[^A-Z]//g' <<< "$options" | tr '[[:upper:]]' '[[:lower:]]')"
	if [[ "${#option_default}" -ne 1 ]]; then
		option_default=""
	fi

	# Prompt the user.
	options_array=($(tr '[[:upper:]]' '[[:lower:]]' <<< "$options" | grep -o .))
	while read -r -p "$message [$options] " choice 1>&2; do
		choice="$(tr '[[:upper:]]' '[[:lower:]]' <<< "$choice")"
		if [[ -z "$choice" ]]; then
			choice="$option_default"
		fi

		# Check the choice.
		for option in "${options_array[@]}"; do
			if [[ "$choice" = "$option" ]]; then
				echo "$choice"
				return 0
			fi
		done
	done

	printf "\n" 1>&2
	return 1
}

# A wrapper around "patch" that applies rejects in merge format.
patch() {
	# Does it support merge?
	local args=()
	local supports_merge=false
	if command patch --help 2>&1 | grep -- "--merge" &>/dev/null; then
		args+=(--merge)
		supports_merge=true
	fi

	# Patch.
	local status=0
	command patch ${args[@]} "$@" || status=$?
	if [[ "$status" -eq 0 ]]; then
		return 0
	fi

	# If it doesn't support merge, we'll do it manually.
	if ! $supports_merge; then

		# Find patched file.
		local file
		for file in "$@"; do
			if [[ "${file:0:1}" != "-" ]]; then
				break
			fi
		done

		# Apply the rejects.
		bash "${HERE}/rej-merge.sh" "$file" > "$file.merged"
		mv "$file.merged" "$file"
		rm "$file.rej"
	fi
	
	# Load the patched file into memory.
	return $status
}

# Show the user a diff.
show_diff() {
	if command -v delta &>/dev/null; then
		delta "$2" "$1"
	else
		"${PAGER:-less}" < <(diff "$2" "$1")
	fi
}

# -----------------------------------------------------------------------------
# Main:
# -----------------------------------------------------------------------------

# Skip directories.
if [[ -d "$COPY_FROM" ]]; then
	exit 0
fi

# If the file doesn't exist, copy it.
if ! [[ -e "$COPY_TO" ]]; then
	vmsg "No file at $COPY_TO, installing."
	cp_install "$COPY_FROM" "$COPY_TO"
	cp_cache "$COPY_FROM" "$CACHE_FILE"
	msg "Installed: $COPY_TO"
	exit 0
fi

# If the file hasn't been installed before, diff it.
if ! [[ -f "$CACHE_FILE" ]]; then
	# Create a diff between the current file and our copy.
	IFS= read -rd '' diff_with_existing < <({
		diff "$COPY_FROM" "$COPY_TO"
	}) || true

	# If they're the same, we'll track it.
	if [[ -z "$diff_with_existing" ]]; then
		vmsg "Tracking file: $COPY_FROM -> $COPY_TO"
		cp_cache "$COPY_FROM" "$CACHE_FILE"
		exit
	fi
	
	# If they're not, the user needs to figure that out.
	vmsg "Found file at $COPY_TO, and it isn't from here."
	msg_w "The file '${COPY_TO}' already exists."  1>&2
	while true; do
		case "$(prompt "[S]kip, [M]erge, [O]verwrite, [K]eep [D]iff, [A]bort?" "Smokda" || echo 'a')" in
			o) # Overwrite
				vmsg "Overwriting file: $COPY_FROM -> $COPY_TO"
				cp_install "$COPY_FROM" "$COPY_TO"
				cp_cache "$COPY_FROM" "$CACHE_FILE"
				msg "Overwrote: $COPY_TO"
				;;
			m) # Merge
				tempfile="$CACHE_FILE.pending"
				cp "$COPY_FROM" "$tempfile"

				sdiff -o "$tempfile" "$COPY_TO" "$COPY_FROM"

				mv_install "$tempfile" "$COPY_TO" 
				cp_cache "$COPY_FROM" "$CACHE_FILE"
				msg "Merged: $COPY_TO"
				;;
			d) # Diff
				show_diff "$COPY_FROM" "$COPY_TO" || true
				continue
				;;
			a) # Abort
				msg "Conflict: $COPY_TO"
				exit 1
				;;
			s) # Skip
				msg "Skipped: $COPY_TO"
				;;
			k) # Keep
				cp_cache "$COPY_FROM" "$CACHE_FILE"
				msg "Kept: $COPY_TO"
				;;
		esac; break
	done
	exit 0
fi

# If the file exists, diff it with the cached version.

	# Create a diff between the cache file and the latest file.
	if [[ "${INSTALL:-}" != "force" ]]; then
		if diff "$COPY_FROM" "$CACHE_FILE" &>/dev/null; then
			vmsg "Nothing to update for $COPY_TO."
			exit 0
		fi
	fi

	# Create a diff between the current file and the file when it was installed.
	IFS= read -rd '' diff_with_cache < <({
		diff "$CACHE_FILE" "$COPY_TO"
	}) || true
	
	# If there's no difference, update the current file.
	if [[ -z "$diff_with_cache" ]]; then
		is_same="$(diff "$COPY_FROM" "$COPY_TO" &>/dev/null && echo "true" || echo "false")"
		
		vmsg "Found file at $COPY_TO, but no changes."
		cp_install "$COPY_FROM" "$COPY_TO"
		cp_cache "$COPY_FROM" "$CACHE_FILE"

		if ! $is_same; then
			msg "Updated: $COPY_TO"
		fi
		exit 0
	fi

	# If there's a difference, prompt the user.
	vmsg "Found file at $COPY_TO, and it has changes."
	msg_w "The file '${COPY_TO}' has been modified."  1>&2
	while true; do
		case "$(prompt "[P]atch, [M]erge, [O]verwrite, [K]eep, [D]iff, [S]kip, [A]bort?" "Pmokdsa" || echo 'a')" in
			o) # Overwrite
				vmsg "Overwriting file: $COPY_FROM -> $COPY_TO"
				cp_install "$COPY_FROM" "$COPY_TO"
				cp_cache "$COPY_FROM" "$CACHE_FILE"
				msg "Overwrote: $COPY_TO"
				;;
			a) # Abort
				msg "Conflict: $COPY_TO"
				exit 1
				;;
			s) # Skip
				msg "Skipped: $COPY_TO"
				;;
			k) # Keep
				cp_cache "$COPY_FROM" "$CACHE_FILE"
				msg "Kept: $COPY_TO"
			d) # Diff
				show_diff "$CACHE_FILE" "$COPY_TO" || true
				continue
				;;
			p) # Patch
				tempfile="$CACHE_FILE.pending"
				cp "$COPY_FROM" "$tempfile"

				if ! patch -s "$tempfile" <<< "$diff_with_cache"; then
					msg_w "Could not patch cleanly... opening in editor." 1>&2
					"${VISUAL:-${EDITOR:-vi}}" "$tempfile"
				fi

				mv_install "$tempfile" "$COPY_TO"
				msg "Patched: $COPY_TO"
				;;
			m) # Merge
				tempfile="$CACHE_FILE.pending"
				cp "$COPY_FROM" "$tempfile"

				sdiff -o "$tempfile" "$COPY_TO" "$COPY_FROM"

				mv_install "$tempfile" "$COPY_TO" 
				cp_cache "$COPY_FROM" "$CACHE_FILE"
				msg "Merged: $COPY_TO"
				;;
		esac; break
	done

