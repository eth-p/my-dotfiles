#!/usr/bin/env bash
# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
set -euo pipefail

FILE="$1"
FILE_LINES=()
FILE_LINES_OFFSET=0

OURS_LINE_NUMBER=''
OURS=()
THEIRS_LINE_NUMBER=''
THEIRS=()

# -----------------------------------------------------------------------------
# Functions:
# -----------------------------------------------------------------------------

insert() {
	local line="$1"
	IFS= local text="$2"

	# Determine the real line number after the previous inserts.
	local real_line=$((FILE_LINES_OFFSET+line)) || true

	# Perform insert.
	FILE_LINES_OFFSET=$((FILE_LINES_OFFSET+1)) || true
	FILE_LINES=(
		"${FILE_LINES[@]:0:$real_line}" \
		"$text" \
		"${FILE_LINES[@]:$real_line}"
	)
}

replace() {
	local line="$1"
	IFS= local text="$2"
	
	# Determine the real line number after the previous inserts.
	local real_line=$((FILE_LINES_OFFSET+line)) || true

	# Perform replace.
	FILE_LINES[$real_line]="$text"
}

merge_reject() {
	if [[ -z "$OURS_LINE_NUMBER" ]]; then
		return
	fi

	# Generate the text to insert.
	local str=''
	local line
	while IFS= read -r line; do
		if [[ -z "$str" ]]; then
			str="$line"
		else
			str="$str"$'\n'"$line"
		fi
	done < <({
		echo "<<<<<<< YOUR CHANGES (approximately)"
		printf "%s\n" "${THEIRS[@]}"
		echo "======="
		printf "%s\n" "${OURS[@]}"
		echo ">>>>>>> UPDATE"
	})

	# Insert the text.
	#replace "$((THEIRS_LINE_NUMBER - 1))" "$str"

	# Clear the previous reject.
	OURS=()
	OURS_LINE_NUMBER=
	THEIRS=()
	THEIRS_LINE_NUMBER=
}

# -----------------------------------------------------------------------------
# Main:
# -----------------------------------------------------------------------------
	
# Load the patched file into memory.
while read -r line; do
	FILE_LINES+=("$line")
done < "$FILE"

# Iteratively apply rejected hunks.
while read -r line; do
	case "$line" in

		# New reject:
		"***************")
			merge_reject
			;;

		# Ours line number:
		"*** "*)
			OURS_LINE_NUMBER="$(sed 's/^\*\*\* *//; ;s/,[0-9]*$//' <<< "$line")"
			;;

		# Ours line:
		"- "*)
			OURS+=("${line:2}")
			;;

		# Theirs line number:	
		"--- "*" -----")
			THEIRS_LINE_NUMBER="$(sed 's/^--- *//; s/ *-----$//; ;s/,[0-9]*$//' <<< "$line")"
			;;

		# Theirs line:
		"+ "*)
			THEIRS+=("${line:2}")
			;;
	esac
done < "$FILE.rej"
merge_reject

# Print back the file.
{
	for line in "${FILE_LINES[@]}"; do
		printf "%s\n" "$line"
	done
}

