# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Wrappers and utility functions for working with Nix or running Nix commands
# before my-dotfiles is initially set up.
# ==============================================================================
# shellcheck shell=bash source-path=../../
if test -n "${__guard_lib_nix:-}"; then return 0; fi
__guard_lib_nix="${BASH_SOURCE[0]}"
# ==============================================================================
source "${REPO_DIR}/management/lib/bash.sh"

nix() {
	command nix --experimental-features 'flakes nix-command' "$@" || return $?
}

# nix_installed checks if Nix is installed.
# This uses a new login shell to ensure that Nix would be available in the path.
nix_installed() {
	local result
	result="$(
		bash -lc '
            if command -v nix; then
                echo true >&3
            else
                echo false >&3
            fi
        ' 3>&1 &>/dev/null
	)"
	test "$result" = "true" || return 1
}

# nix_install_dir prints the directory where the `nix` executable can be found.
# This uses a new login shell to ensure that Nix would be available in the path.
nix_install_dir() {
	local result
	if result="$(bash -lc 'command -v nix >&3' 3>&1 &>/dev/null)"; then
		print_and_redefine "${FUNCNAME[0]}" "$(dirname -- "$result")"
		return 0
	fi

	return 1
}

# nix_platform returns the Nix platform for the current system.
#
# This normalizes the kernel name and machine architecture names:
#   arm64 -> aarch64
#   amd64 -> x86_64
nix_platform() {
	local kernel arch
	kernel="$(uname -s | tr '[:upper:]' '[:lower:]')"
	arch="$(uname -m | sed 's/^arm64$/aarch64/; s/^amd64$/x86_64/')"
	print_and_redefine "${FUNCNAME[0]}" "${arch}-${kernel}"
}

# nix_flake_ref returns a reference to the locked version of some flake used in
# my-dotfiles.
nix_flake_ref() {
	: "${1?Requires first parameter as path to flake}"
	: "${2?Requires second parameter as node name in lockfile}"
	# shellcheck disable=SC2016
	nix eval --impure --raw --expr '
        let
            lockFile = "'"$1"'/flake.lock";
            lock = (builtins.fromJSON (builtins.readFile lockFile));
            flake = lock.nodes.'"$2"';
        in "github:${flake.locked.owner}/${flake.locked.repo}?rev=${flake.locked.rev}\n"
    '
}

# nix_flake_local_inputs returns local inputs declared in the specified flake's
# `flake.nix` file.
nix_flake_local_inputs() {
	: "${1?Requires first parameter as path to flake}"
	: "${2?Requires second parameter as delimiter between name and url}"
	# shellcheck disable=SC2016
	nix eval --impure --raw --expr '
		let
			flakeFile = "'"$1"'/flake.nix";
			flakeDef = import flakeFile;

			urlOf = input: if (builtins.typeOf input) == "string"
				then input
				else if input ? url then input.url
				else builtins.flakeRefToString input;

			inputIsLocal = url:
				let
					parts = builtins.match "^([^:]+):.*" url;
					urlProto = builtins.elemAt parts 0;
				in {
					"path" = true;
					"file" = true;
					"git+file" = true;
				} ? ${urlProto};

			inputNames = builtins.attrNames
				(if flakeDef ? inputs then flakeDef.inputs else {});

			inputEntries = builtins.map
				(n: { name = n; value = urlOf flakeDef.inputs.${n}; })
				inputNames;

			localInputEntries = builtins.filter
				({name, value}: inputIsLocal value)
				inputEntries;
		in
			builtins.concatStringsSep "\n" (
				builtins.map
					({name, value}: "${name}'"$2"'${value}")
					localInputEntries
			)
    '
	printf "\n"
}

# nixpkgs_flake returns a reference to the locked version of the nixpkgs flake,
# prioritizing the applied nixpkgs version used by my-dotfiles, or failing
# that, the version specified in the my-dotfiles repo.
nixpkgs_flake() {
	local ref
	ref="$({
		if [[ -n "${BOOTSTRAPPED_FLAKE_DIR:-}" ]]; then
			nix_flake_ref "$BOOTSTRAPPED_FLAKE_DIR" nixpkgs
		else
			nix_flake_ref "$REPO_DIR" nixpkgs
		fi
	})"

	print_and_redefine "${FUNCNAME[0]}" "$ref"
}

# nixpkgs_run executes a program from nixpkgs.
nixpkgs_run() {
	local ref
	ref="$(nixpkgs_flake)"
	nix run "${ref}#${1}" -- "${@:2}" || return $?
}

# home_manager_flake returns a reference to the locked version of the
# home-manager flake used in my-dotfiles.
home_manager_flake() {
	local ref
	ref="$(nix_flake_ref "$REPO_DIR" home-manager)"
	print_and_redefine "${FUNCNAME[0]}" "$ref"
}
