# variables defined when installed:
#  * useDelta (0/1)
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
	local printer="cat"
	if [[ "$useDelta" -eq 1 ]]; then
		printer="delta"
	fi

	git show "$1" --color=always | "$printer"
}

# Alternate entry point for showing the preview.
if [[ $# -ge 1 ]] && [[ "$1" = "_preview" ]]; then
	ui_preview "$2"
	exit 0
fi

# Main entry point.
commit="$(cut -d' ' -f1 < <(ui_show < <(ui_input)))"
if [[ "$commit" != "" ]]; then
	git commit --fixup "$commit"
fi
