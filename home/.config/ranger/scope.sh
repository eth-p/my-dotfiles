#!/usr/bin/env bash
# my-dotfiles | Copyright (C) 2022 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   Extends the functionality of ranger previews.
#
#     * Markdown: Use 'glow' to generated formatted previews.
#     * Images:   Use 'tev' to preview the image with terminal characters
#
# How it's used in my-dotfiles
# ----------------------------
#
#   This configuration file for 'ranger' will monkeypatch the real 'scope.sh'
#   used by the current installation of Ranger, adding user-specified overrides
#   for certain file types.
#
# =============================================================================
set -euo pipefail

# For documentation on what is supported by scope.sh:
#   https://github.com/ranger/ranger/blob/master/ranger/data/scope.sh

# Exit codes supported by ranger 1.9.3:
#
#   code | meaning    | action of ranger
#   -----+------------+-------------------------------------------
#   0    | success    | Display stdout as preview
#   1    | no preview | Display no preview at all
#   2    | plain text | Display the plain content of the file
#   3    | fix width  | Don't reload when width changes
#   4    | fix height | Don't reload when height changes
#   5    | fix both   | Don't ever reload
#   6    | image      | Display the image `$IMAGE_CACHE_PATH` points to as an image preview
#   7    | image      | Display the file directly as an image

# -----------------------------------------------------------------------------

my_handle_extension() {
	case "$FILE_EXTENSION_LOWER" in
		md|markdown)
			command -v glow &>/dev/null \
				&& GLOW_UNPADDED=true glow "$FILE_PATH" --width="$PV_WIDTH" --style="${TERM_BG:-dark}" \
				&& exit 0
			;;
	esac
}

my_handle_image() {
	:
}

my_handle_mime() {
	case "$mimetype" in
		image/*)
			command -v tiv &>/dev/null && tiv "$FILE_PATH" && exit 0
			;;
	esac
}




# -----------------------------------------------------------------------------
# Monkey Patcher:
# Searches for the real 'scope.sh' and patches the handler functions.
# -----------------------------------------------------------------------------

# Find the real 'scope.sh' script.
# We will be monkeypatching it to add our own overrides.
RANGER_DATA_DIR=

# Look for ranger in the Python site_packages.
# This is where it will be found on Linux distros (or if installed through pip)
while read -r site_packages; do
	if [ -d "${site_packages}/ranger" ]; then
		RANGER_DATA_DIR="${site_packages}/ranger"
		break
	fi
done < <({
	python -c 'import site; print("\n".join(site.getsitepackages()))'
	python3 -c 'import site; print("\n".join(site.getsitepackages()))'
} 2>/dev/null)

# Look for ranger from its symlink.
# This is where it will be found when installed through Homebrew.
if test -z "$RANGER_DATA_DIR" && test -L "$(command -v ranger)"; then
	RANGER_DATA_DIR="$({
		cd "$(dirname -- "$(command -v ranger)")"
		cd "$(dirname -- "$(readlink ranger)")"
		cd "../lib/python"*/"site-packages/ranger"
		pwd
	})"
fi

if test -z "$RANGER_DATA_DIR"; then
	echo "error: Unable to find the real scope.sh script"
	echo "       Fix within ~/.config/ranger/scope.sh" 
	exit 0
fi

RANGER_SCOPE_SH="${RANGER_DATA_DIR}/data/scope.sh"


# Find the line where 'scope.sh' starts performing its main purpose.
# This starts when it checks the mimetype of the file. 
main_start_line="$(awk '/^MIMETYPE="\$\(/ { print NR-1 }' "$RANGER_SCOPE_SH")"
if test -z "$main_start_line"; then
	echo "error: Unable to patch the real scope.sh script"
	echo "       Fix within ~/.config/ranger/scope.sh"
	exit 0
fi

# Load the library functions within 'scope.sh'.
set +euo pipefail
eval "$(head -n "$main_start_line" "$RANGER_SCOPE_SH")"

# Patch the library functions within 'scope.sh'.
# This will insert the 'my_*' variants before the case expression.
for func in "handle_extension" "handle_image" "handle_mime"; do
	func_def="$(type "$func" | sed '1d')"
	patch_body="$(type "my_${func}" | sed '1,3d; $d')"

	# Find the line where the 'case' starts.
	func_case_line="$(awk '/^[ \t]*case "/ { print NR-1; exit }' <<< "$func_def")"
	if test -z "$func_case_line"; then
		echo "error: Unable to patch the real scope.sh script (case in $func)"
		echo "       Fix within ~/.config/ranger/scope.sh"
		exit 0
	fi

	# Create a new function and evaluate it.
	eval "$({
		head -n "$func_case_line" <<< "$func_def"
		printf "%s\n" "$patch_body"
		sed "1,${func_case_line}d" <<< "$func_def"
	})"
done

unset func_def
unset patch_body
unset func_case_line

# Run the main part of 'scope.sh'.
eval "$(sed "1,${main_start_line}d" "$RANGER_SCOPE_SH")"
exit 1

