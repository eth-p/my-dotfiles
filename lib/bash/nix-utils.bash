# my-dotfiles | Copyright (C) 2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Common bash functions used to interact with nix, the flake, and packages.
# ==============================================================================

# nix_current_system prints nix's "currentSystem".
nix_current_system() {
	local system
	system=$(nix eval --expr 'builtins.currentSystem' --impure --raw)
	eval "$(printf 'nix_current_system() { printf "%%s\n" %q ; }' "$system")"
	nix_current_system
}

# flake_package_version prints the version of a package in this flake.
#
# Args:
#   $1: The package name.
flake_package_version() {
	flake_package_attr_for_system "$(nix_current_system)" "$@" version
}

# flake_package_attr prints an attribute of a package in this flake.
#
# Args:
#   $1: The package name.
#   $2: The attribute path.
flake_package_attr() {
	flake_package_attr_for_system "$(nix_current_system)" "$@"
}

# flake_package_attr_for_system prints an attribute of a package for the
# specified nix system.
#
# Args:
#   $1: The nix system.
#   $2: The package name.
#   $3: The attribute path.
flake_package_attr_for_system() {
	local system="${1?System required}"
	local package="${2?Package required}"
	local attr="${3?Attribute required}"
	(
		cd "$(git rev-parse --show-toplevel)" || return $?
		nix eval "path:.#packages.${system}.${package}.${attr}" --impure --raw
	)
}

# fetch_source_hash_for_url fetches a file at the specified URL and
# returns the base32 SHA-256 nix source hash for it.
#
# This only works for single files, not repos.
#
# Args:
#   $1: The URL.
fetch_source_hash_for_url() {
	local url="${1?Url required}"
	nix-hash --type sha256 --base32 --sri --flat <(curl "$url" -fsL -o-)
}
