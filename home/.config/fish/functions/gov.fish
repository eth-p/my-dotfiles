# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   Selects a Go version using homebrew.
#
# Synopsis
# --------
#
#   Change the current Go version:
#
#     gov 1.18 some-pod-1 bash
#
# =============================================================================

function gov --description "Select a Go version"
	set -x HOMEBREW_NO_AUTO_UPDATE 1
	switch "$argv[1] $argv[2]"
	
	# Command: gov show paths
	# Prints the path to all installed toolchains.
	case "show toolchain-paths"
		# Get the list of installed Go versions.
		if [ -z "$__gov_brew_prefix_cache" ]
			set -g __gov_brew_prefix_cache (brew config --quiet | grep '^HOMEBREW_PREFIX:' | sed 's/^HOMEBREW_PREFIX: //')

		end
		set -l brew_prefix "$__gov_brew_prefix_cache"
		set -l brew_installs "$brew_prefix/opt"
		set -l go_install
		for go_install in $brew_installs/go $brew_installs/go@*
			if [ -f "$go_install/bin/go" ]
				echo "$go_install"
			end
		end
		return 0

	# Command: gov show toolchains
	# Prints the paths and versions of all installed toolchains.
	case "show toolchains"
		gov show toolchain-paths \
			| xargs -I '{}' sh -c 'printf "%s => %s\n" "$1" "`"$1/bin/go" version`"' -- '{}' \
			| sed 's/^\(.*\) => go version \(devel \)*go\([^ ]*\).* \([^ ]\{1,\}\)$/\1 => \4 \3/'
		return 0

	# Command: gov show installed
	# Prints the versions of all installed toolchains.
	case "show installed"
		gov show toolchains | sed 's/^.* => //' | cut -d' ' -f2 | cut -d'.' -f1-2 | cut -d'-' -f1 | sort -Vu
		return 0

	# Command: gov show available
	# Prints the toolchains available on Homebrew.
	case "show available"
		begin
			brew search '/^go@/' | grep -v '^==>' | sed 's/^go@//'
			gov show installed
		end | sort -V
		return 0
	
	# Command: gov show
	# Prints the current toolchain info.
	case "show "
		printf '\x1B[34m%-12s \x1B[0m%s\n' \
			'Toolchain:' (which go) \
			'Details:'   (go version) \
			'Version:'   (go version | sed 's/^go version \(devel \)*go\([^ .-]*\.[^ .-]*\).*$/\2/')
		return 0
	end

	switch "$argv[1]"

	# Command: modify-path
	# Internal command used to modify the PATH to select a Go toolchain.
	case "modify-path"
		set -l path_component
		set -l go_toolchains (gov show toolchain-paths | sed 's/$/\/bin/')
		set -l go_prefix (dirname (which go))
		set -l new_path
		for path_component in $PATH
			if contains "$path_component" $go_toolchains
				continue
			end

			set --append new_path "$path_component"
		end

		set PATH "$argv[2]" $new_path
		printf "\x1B[32mChanged Go toolchain.\x1B[0m\n"
		gov show
		return 0


	# Command: select
	# Interactively select a specific version.
	case "" select
		return 1
	
	# Command: [version]
	# Select a specific version.
	case "*"
		# Try to use an existing toolchain.
		set -l go_install
		for go_install in (gov show toolchain-paths)
			if ! [ -f "$go_install/bin/go" ]; continue; end
			set -l go_install_version ("$go_install/bin/go" version | sed 's/^go version \(devel \)*go\([^ .-]*\.[^ .-]*\).*$/\2/')
			if [ "$go_install_version" = "$argv[1]" ]
				gov modify-path "$go_install/bin"
				return $status
			end
		end

		# Try to use a toolchain from Homebrew.
		if gov show available | grep -F "$argv[1]" &>/dev/null
			printf "\x1B[33m%s\x1B[0m\n" \
				"Toolchain for '$argv[1]' is not installed, and will be installed through Homebrew." \
				"If you wish to cancel, press Ctrl+C within 5 seconds." \
				""
			
			sleep 5 || return 1
			brew install "go@$argv[1]"
			if [ $status -ne 0 ]
				return 1
			end

			gov "$argv[1]"
			return $status
		end

		# Unknown version.
		printf "\x1B[31mUnknown go version: %s\x1B[0m\n" "$argv[1]"
		return 1
	end
end

