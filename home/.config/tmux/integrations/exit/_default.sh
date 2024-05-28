#!/usr/bin/env bash
# my-dotfiles | Copyright (C) 2022 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This script tries to kill a tmux pane.
#
#   If there are any "unsafe" processes running under the pane, the user will
#   be prompted to confirm first.
#
# =============================================================================

# Grace period in seconds before killing programs forcefully.
:option: ICFG_EXIT_SAFE_GRACE 5

# Programs that are safe to kill without confirmation.
:option: ICFG_EXIT_SAFE_PROGRAMS '-*' 'fish' 'ssh' "$(basename -- "$SHELL")"

# The color to use when prompting the user about killing a program.
:option: ICFG_EXIT_PROMPT_STYLE ''

# -----------------------------------------------------------------------------

# Recursively prints the names of children commands.
#   $1  - The parent pid.
#   $2  - The pid to stop at.
CACHED_PS="$(ps ax -o pid,ppid,comm)"
children_of() {
	if [ "$1" = "$2" ]; then
		return 0
	fi

	local command_pid
	local command
	while read -r command_pid command; do
		printf "%s\n" "$command"
		children_of "$command_pid" "$2"
	done < <(awk '$2 == '"$1"' { print $1" "$3 }' <<< "$CACHED_PS")
}

# -----------------------------------------------------------------------------

# Get the pane shell's PID.
pane_pid="$(tmux display-message -p -F "#{pane_pid}" -t "$INTEGRATION_PANE")"

# Find all of the child processes of the pane and its children.
# If a single one of them isn't allowed, we need to ask.
need_prompt=false
need_prompt_command=""
while read -r child; do
	for allowed_command in "${ICFG_EXIT_SAFE_PROGRAMS[@]}"; do

		# shellcheck disable=SC2053
		# Note: This is intentional, we want to glob.
		if [[ "$(basename -- "$child")" = $allowed_command ]]; then
			continue 2
		fi
	done

	need_prompt=true
	need_prompt_command="$(basename -- "$child")"
	echo "Found command '${need_prompt_command}' that is not safe to kill."
	break
done < <(children_of "$pane_pid" "$$")

# Was there any unsafe program?
# If so, prompt the user about killing the pane.
if "$need_prompt"; then
	confirm: "Pane is running '$need_prompt_command'. Close it?" \
		--style="$ICFG_EXIT_PROMPT_STYLE" \
		|| cancelled=$?

	# Exit if the user cancelled.
	if [ "$cancelled" -ne 0 ]; then
		echo "User cancelled the operation"
		exit 0
	fi
fi

# Otherwise, no prompt needed.
# Try to safely kill it first, then force kill it in 5 seconds.
if [[ -n "$ICFG_EXIT_SAFE_GRACE" ]] && 
	[[ "$ICFG_EXIT_SAFE_GRACE" -gt 0 ]]; then
	pane_pid="$(tmux display-message -t "$INTEGRATION_PANE" -p '#{pane_pid}')"

	# Kill the pane with SIGHUP.
	echo "Trying to exit the pane safely..."
	kill -1 "$pane_pid"

	# Hide the pane for UX.
	tmux break-pane -s "$INTEGRATION_PANE" -d 2>/dev/null || true

	# Wait for it to exit.
	timer=0
	while [[ "$timer" -lt "$ICFG_EXIT_SAFE_GRACE" ]]; do
		timer="$((timer + 1))"
		sleep 1
		echo "  ${timer} of ${ICFG_EXIT_SAFE_GRACE} seconds passed..."

		if ! kill -0 "$pane_pid" &>/dev/null; then
			# The pane is finished. Now remove it, in case the remain-on-exit
			# option was enabled for it.
			tmux kill-pane -t "$INTEGRATION_PANE" &>/dev/null || true	
			echo "  Pane has exited!"
			exit 0
		fi
	done
fi

# Force kill the pane.
echo "Killing the pane..."
tmux kill-pane -t "$INTEGRATION_PANE"

