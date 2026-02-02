#!/usr/bin/env bash
# my-dotfiles | Copyright (C) 2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# ==============================================================================
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

# Ensure repo does not have staged changes.
git diff --quiet --staged --ignore-submodules HEAD || {
	printf "\x1B[31merror: my-nixos repo has staged changes, cannot proceed\x1B[m\n" 1>&2
	exit 1
}

# ------------------------------------------------------------------------------
# Trap exit to run cleanup function.
cleanup() {
	if [[ -n "${UPDATE_MESSAGE_FILE:-}" ]] && [[ -f "${UPDATE_MESSAGE_FILE}" ]]; then
		rm "$UPDATE_MESSAGE_FILE"
	fi
}

update_package() {
	truncate -s 0 "$UPDATE_MESSAGE_FILE"
	local package_name="$1"
	local package_dir="packages/${package_name}"
	local package_update_script="${package_dir}/update.sh"

	bash "$package_update_script" >/dev/null || {
		printf "\x1B[31merror: package %s could not be updated\x1B[m\n" "$package_name" 1>&2
		return 1
	}

	if git diff --quiet --ignore-submodules HEAD "$package_dir"; then
		printf "\x1B[33mNothing to update.\x1B[m\n\n" 1>&2
		return 0
	fi

	# Normalize the commit message.
	commit_message="$(cat "$UPDATE_MESSAGE_FILE")"
	if ! [[ "$commit_message" =~ ^upgrade\( ]]; then
		commit_message="$(sed -E 's/^([^:]+):/upgrade(\1):/' <<<"$commit_message")"
	fi

	# Add the changes and commit.
	local git_commit_cmd=(commit)
	if [[ -n "$commit_message" ]]; then
		git_commit_cmd+=(-m "$commit_message")
	fi

	git add "$package_dir"
	git "${git_commit_cmd[@]}"
}

# ------------------------------------------------------------------------------
# Main:

trap cleanup EXIT

export UPDATE_MESSAGE_FILE=''
UPDATE_MESSAGE_FILE=$(mktemp)

# Collect the list of packages that can be updated.
packages=()
for package_file in ./packages/*/package.nix; do
	package_dir=$(dirname -- "$package_file")
	package_name=$(basename -- "$package_dir")
	if ! [[ -f "${package_dir}/update.sh" ]]; then
		continue
	fi

	git diff --quiet --ignore-submodules HEAD "$package_dir" || {
		printf "\x1B[31merror: package %s has uncommitted changes, cannot proceed\x1B[m\n" "$package_name" 1>&2
		exit 1
	}

	packages+=("$package_name")
done

# Update the packages.
for package_name in "${packages[@]}"; do
	printf "\x1B[1;34m==> \x1B[0;34mUpdating %s\x1B[m\n" "$package_name" 1>&2
	update_package "$package_name"
done
