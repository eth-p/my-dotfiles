# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   Prints the status of a Kubernetes pod.
#
# =============================================================================

function kstatus --description "View the status of a Kubernetes object"
	# Parse the arguments.
	argparse --stop-nonopt 'c/container=' 'n/namespace' -- $argv || return 1

	# Get the object kind and object name.
	set -l kind $argv[1]
	set -l target $argv[2]

	# If the second argument is empty, we need to search all objects.
	if [ -z "$target" ]
		set target "$kind"
		set kind ""

		# set -l object_kinds (kubectl api-resources -o name --namespaced=true) || return 1
		set -l object_kinds 'pod' 'configmap' 'pvc' 'deployment' 'ingress' 'sts'
		set -l object_kinds_str (string join -- ',' $object_kinds)

		set -l found_kinds (
			kubectl get "$object_kinds_str" \
				-o "jsonpath={range .items[*]}{.kind}{'\n'}{end}" \
				--field-selector metadata.name="$target"
		) || return 2

		if [ (count $found_kinds) -eq 0 ]
			echo "No object with name '$target'." 1>&2
			return 1
		end

		if [ (count $found_kinds) -gt 1 ]
			echo "Multiple object kinds found:" 1>&2
			printf "- %s\n" "$found_kinds" 1>&2
			return 1
		end

		set kind $found_kinds[1]
	end

	# Get the status.
	set -l object_yaml (kubectl get -oyaml "$kind" "$target" | string collect)
	set -l object_kind (echo "$object_yaml" | yq e '.kind' -)
	set -l line

	# Print the conditions.
	if echo "$object_yaml" | yq -e e ".status.conditions" - &>/dev/null
		set_color cyan && echo "Conditions:" && set_color normal
		__kstatus_report_conditions "$object_yaml"
	end
	
	# Print the container statuses.
	if echo "$object_yaml" | yq -e e ".status.containerStatuses" - &>/dev/null
		set_color cyan && echo "Containers:" && set_color normal
		__kstatus_report_containers "$object_yaml"
	end
end

function __kstatus_parse_variables --no-scope-shadowing
	# Parse yaml string.
	set -l __line (
		string replace --regex -- '^\s*-\s*"(.*)"$' '$1' "$argv[1]" |
		string replace --regex --all -- '\\\\([^a])' '$1'
	)

	# Parse variables from the string.
	for __line in (string split -- "\a" "$__line")
		set -l __split_line (string split --max=2 -- "=" "$__line") 
		set -l __split_var "$__split_line[1]"
		set -l __split_val "$__split_line[2]"

		eval "set yaml_$__split_var" (string escape -- "$__split_val")
	end
end

function __kstatus_report_conditions
	set -lx sep (printf "\a")
	for line in ( echo "$argv[1]" |\
		yq -I0 --unwrapScalar=true e 'strenv(sep) as $sep | .status.conditions.[] as $item ireduce ([]; . += (
			"condition=" + ($item.type) 
			+ $sep+"status="               + ($item.status) 
			+ $sep+"last_transition_time=" + ($item.lastTransitionTime) 
			+ $sep+"reason="               + ($item.reason // "")
		)) | .. style="double"' -
	)
		__kstatus_parse_variables "$line"

		# Parse the condition status.
		set -l status_text "?"
		set -l status_color ""
		switch "$yaml_status"
			case "True" "true"
				set status_text "Good"
				set status_color (set_color green)
			case "False" "false"
				set status_text "Bad "
				set status_color (set_color red)
		end

		# Parse the status reason.
		if [ -n "$yaml_reason" ]
			set yaml_reason " ($yaml_reason)"
		end

		# Print the item.
		printf "  %s%-20s%s %s%s%s%s\n" \
			"" "$yaml_condition" "" \
			"$status_color" "$status_text" (set_color normal) "$yaml_reason"
	end
end

function __kstatus_report_containers
	set -lx sep (printf "\a")
	for line in ( echo "$argv[1]" |\
		yq -I0 --unwrapScalar=true e 'strenv(sep) as $sep | .status.containerStatuses.[] as $item ireduce ([]; . += (
			"container="             + ($item.name)
			+ $sep+"started="        + ($item.started | . tag = "!!str")
			+ $sep+"ready="          + ($item.ready | . tag = "!!str")
			+ $sep+"restart_count="  + ($item.restartCount | . tag = "!!str")
			+ $sep+"restart_reason=" + ($item.lastState.terminated.reason // "")
		)) | .. style="double"' - 
	)
		__kstatus_parse_variables "$line"
		
		set -l status_text "?"
		set -l status_color ""
		set -l extra

		switch "$yaml_started:$yaml_ready"
			case "false:false"
				set status_text "Starting"
				set status_color (set_color red)
			case "true:false"
				set status_text "Started"
				set status_color (set_color yellow)
			case "true:true"
				set status_text "Running"
				set status_color (set_color green)
		end

		if [ "$yaml_restart_count" -gt 0 ]
			set extra " - $yaml_restart_count restarts ($yaml_restart_reason)"
		end

		# Print the item.
		printf "  %s%-20s%s %s%s%s%s\n" \
			"" "$yaml_container" "" \
			"$status_color" "$status_text" (set_color normal) "$extra"
	end
end
