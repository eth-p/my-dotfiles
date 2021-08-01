# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   Executes a command in a Kubernetes conatiner.
#
# Synopsis
# --------
#
#   Execute bash in a pod with only one container:
#
#     kexec some-pod-1 bash
#
#   Execute bash in a specific container of a pod:
#
#     kexec some-pod-1 -c mysql bash
#
# =============================================================================

function kexec --description "Execute a command in a Kubernetes container"
	# Parse the arguments.
	argparse --stop-nonopt 'c/container=' 'n/namespace' -- $argv || return 1

	# Extract the pod name and arguments.
	set -l pod $argv[1]
	set -l command $argv[2..-1]
	set -l namespace $_flag_namespace
	set -l container "$_flag_container"

	# If the second argument starts with a -, the arguments follow the pod name.
	# In this case, parse again.
	if [ (string sub --length=1 -- "$argv[2]") = "-" ]
		argparse --stop-nonopt 'c/container=' 'n/namespace' -- $argv[2..-1]
		set command $argv
		if [ -n "$_flag_namespace" ]; set namespace "$_flag_namespace"; end
		if [ -n "$_flag_container" ]; set container "$_flag_container"; end
	end

	# If the namespace was provided, turn it into (-n $namespace).
	if [ -n "$namespace" ]
		set namespace '-n' "$namespace"
	end

	# If we didn't explicitly specify a container, we find a list of them.
	# If there's one, we use that. If there's more, we tell the user.
	if [ -z "$container" ]
		set -l containers (kubectl get pod $namespace -oyaml $pod | yq e '.status.containerStatuses[].name' -)

		if [ (count $containers) -eq 1 ]
			set container $containers[1]
		end

		if [ (count $containers) -gt 1 ]
			printf -- "Which container?\n"
			printf -- "- %s\n" $containers
			return 1
		end
	end
	 
	# No command provided?
	# Tell them the usage.
	if [ (count command) -lt 1 ]
		echo "usage: kexec [pod] (-c [container]) command ..."
		return 1
	end
	
	# kubectl exec
	kubectl exec -it "$pod" -c "$container" -- $command
	return $status
end

