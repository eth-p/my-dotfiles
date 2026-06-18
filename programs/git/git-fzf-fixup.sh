#!/usr/bin/env bash
set -euo pipefail

branch="${1:-origin}"

ui_input() {
	git log --oneline "${branch}..HEAD" --color=always
}

ui_show() {
	fzf --ansi --scheme=history --no-sort --track --layout=reverse-list \
		--with-shell="bash -c" \
		--preview="bash $(printf "%q" "${BASH_SOURCE[0]}") _preview {1}"
}

ui_preview() {
	local previewer="cat"
	local git_show_flags=()

	previewer="$(git config pager.show)" || true
	if [[ -z "$previewer" ]]; then
		previewer="$(git config --get core.pager)" || true
	fi
	if [[ -z "$previewer" ]]; then
		previewer="less"
	fi

	echo "$previewer"
	case "$(basename -- "$previewer")" in
	delta)
		git_show_flags+=(--color=always)
		;;
	more|less|cat)
		git_show_flags+=(--color=always)
		previewer="cat"
		;;
	*)
		# Unknown tool, just try it.
		:
		;;
	esac
	
	git show "${git_show_flags[@]}" "$1" | "$previewer"
}

# Alternate entry point for showing the preview.
if [[ $# -ge 1 ]] && [[ "$1" = "_preview" ]]; then
	ui_preview "$2"
	exit 0
fi

# Main entry point.
if git diff --quiet --name-only --cached >/dev/null; then
	echo "No staged changes to fixup. Use 'git add' to stage changes first:"
	git status --short
	exit 1
fi

commit="$(cut -d' ' -f1 < <(ui_show < <(ui_input)))"
if [[ "$commit" != "" ]]; then
	git commit --fixup "$commit"
fi
