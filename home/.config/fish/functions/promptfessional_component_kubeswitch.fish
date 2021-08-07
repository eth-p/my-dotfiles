# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================

function promptfessional_component_kubeswitch --description 'Prompt component for Kubernetes'
	argparse 'no-cache' 'pattern=' -- $argv || return 1
	functions -q kubeswitch || return 1

	[ -n "$_flag_pattern" ] || set _flag_pattern "{color} {label}{/context_if_multiple}{/namespace}³"
	
	# Load cached info.
	set -l __cache_key "$KUBECONFIG:$KUBESWITCH_CONTEXT:$KUBESWITCH_NAMESPACE"
	set -l __cache_vars \
		ksi_label ksi_color CONFIG_NAME CONFIG_FILE ACTIVE_CONTEXT ACTIVE_NAMESPACE

	set -l ksi_label
	set -l ksi_color
	set -l CONFIG_NAME
	set -l CONFIG_FILE
	set -l ACTIVE_CONTEXT
	set -l ACTIVE_NAMESPACE

	if [ -n "$_flag_no_cache" ] || ! _promptfessional_var_cache \
		--cache-namespace="kubeswitch" --cache-key="$__cache_key" \
		$__cache_vars

		# Get information from kubeswitch.
		eval (kubeswitch show --porcelain | string replace --regex '^set -l ' 'set ')

		# Get the label and color from ksi.
		set ksi_label "$CONFIG_NAME"
		set ksi_color ""

		if command -q yq && [ -n "$KSI_YAML" ]
			set ksi_label (echo "$KSI_YAML" | yq e '.label // ""' - 2>/dev/null || echo "$CONFIG_NAME")
			set color_names (echo "$KSI_YAML" | yq e '.color // ""' - 2>/dev/null)
			if [ -n "$color_names" ]
				set ksi_color (set_color (string split ' ' -- $color_names))
			end
		end

		# Update the cache.
		if [ -z "$_flag_no_cache" ]
			_promptfessional_var_cache --update-cache \
				--cache-namespace="kubeswitch" --cache-key="$__cache_key" \
				$__cache_vars
		end
	end

	# Set up template variables.
	set -l context_if_multiple "$ACTIVE_CONTEXT"
	if [ (count $AVAILABLE_CONTEXTS) -le 1 ]
		set context_if_multiple ""
	end
	
	set -l namespace "$ACTIVE_NAMESPACE"
	set -l bold_if_namespace (set_color --bold)
	if [ "$namespace" = "default" ] || [ -z "$namespace" ]
		set namespace ""
		set bold_if_namespace ""
	end

	if [ -z "$ksi_label" ]
		set ksi_label "$CONFIG_NAME"
	end

	# Process the template.
	promptfessional util template "$_flag_pattern" \
		"color"               "$ksi_color" \
		"label"               "$ksi_label" \
		"config"              "$CONFIG_NAME" \
		"config_file"         "$CONFIG_FILE" \
		"context"             "$ACTIVE_CONTEXT" \
		"context_if_multiple" "$context_if_multiple" \
		"namespace"           "$namespace" \
		"bold_if_namespace"   "$bold_if_namespace"
end

