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
source "management/lib/bash.sh"

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
	# shellcheck disable=SC2016
	nix eval --impure --raw --expr '
        let
            lock = (builtins.fromJSON (builtins.readFile ./flake.lock));
            flake = lock.nodes.'"$1"';
        in "github:${flake.locked.owner}/${flake.locked.repo}?rev=${flake.locked.rev}\n"
    '
}

# nixpkgs_flake returns a reference to the locked version of the nixpkgs flake,
# prioritizing the applied nixpkgs version used by my-dotfiles, or failing
# that, the version specified in the my-dotfiles repo.
nixpkgs_flake() {
	local ref
	ref="$({
		if [[ -n "${BOOTSTRAPPED_FLAKE_DIR:-}" ]]; then
			cd "$BOOTSTRAPPED_FLAKE_DIR" || return 1
		fi

		nix_flake_ref nixpkgs
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
	ref="$(nix_flake_ref home-manager)"
	print_and_redefine "${FUNCNAME[0]}" "$ref"
}
