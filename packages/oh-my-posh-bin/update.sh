#!/usr/bin/env bash
#shellcheck source-path=../../
set -euo pipefail
cd "$(dirname -- "$(realpath -- "$0")")"
package=$(basename -- "$(pwd)")
repo=$(git rev-parse --show-toplevel)

source "${repo}/lib/bash/nix-utils.bash"
source "${repo}/lib/bash/update-utils.bash"

github_repo=$(flake_package_attr "$package" "passthru.updateInfo.github")

# Get the current and latest version.
old_version=$(flake_package_version "$package")
version=$(latest_github_release "${github_repo}" | sed 's/^v//')

if [[ "$old_version" = "$version" ]]; then
	printf "Already up-to-date: %s\n" "$version"
	exit 0
fi

# Update the source hashes.
downloads=(
	"x86_64-linux :: https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v${version}/posh-linux-amd64"
	"aarch64-linux :: https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v${version}/posh-linux-arm64"
	"x86_64-darwin :: https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v${version}/posh-darwin-amd64"
	"aarch64-darwin :: https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v${version}/posh-darwin-arm64"
)

for download in "${downloads[@]}"; do
	dl_system=$(awk '{print $1}' <<<"$download")
	dl_url=$(awk '{print $3}' <<<"$download")
	new_hash=$(fetch_source_hash_for_url "$dl_url")
	replace_package_hash_for_system "$dl_system" "$package" package.nix "$new_hash"
done

# Update the version.
replace_package_version "$package" package.nix "$version"

if [[ -n "${UPDATE_MESSAGE_FILE:-}" ]]; then
	printf "upgrade(oh-my-posh): %s -> %s\n" "$old_version" "$version" >"$UPDATE_MESSAGE_FILE"
fi
