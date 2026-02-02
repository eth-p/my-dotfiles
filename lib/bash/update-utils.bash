# my-dotfiles | Copyright (C) 2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Common bash functions used to assist with package updates.
# ==============================================================================

# latest_github_release returns the tag for the latest release of a GitHub
# repo.
#
# Args:
#   $1: The repo in `${owner}/${repo}` format.
latest_github_release() {
	local repo="${1?Repo required}"
	gh api "/repos/${repo}/releases/latest" |
		yq -r --input-format=json --output-format=yaml '.tag_name'
}

# replace_package_hash_for_system uses text replacement to replace a package's
# download hash used for a specific system.
#
# Args:
#   $1: The nix system.
#   $2: The package, as named in the flake packages output.
#   $3: The file to replace the hash in.
#   $4: The new hash to use.
replace_package_hash_for_system() {
	local system="${1?System required}"
	local package="${2?Package required}"
	local file="${3?File required}"
	local new_hash="${4?Hash required}"

	local old_hash
	old_hash=$(flake_package_attr_for_system "$system" "$package" "src.hash")

	sed -i "s~${old_hash}~${new_hash}~g" "$file"
}

# replace_package_version uses text replacement to replace a package's
# version.
#
# Args:
#   $1: The package, as named in the flake packages output.
#   $2: The file to replace the hash in.
#   $3: The new hash to use.
replace_package_version() {
	local package="${1?Package required}"
	local file="${2?File required}"
	local new_version="${3?Version required}"

	local old_version
	old_version=$(flake_package_version "$package")

	sed -i "s#\"${old_version}\"#\"${new_version}\"#g" "$file"
}
