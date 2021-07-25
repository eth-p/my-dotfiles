# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles

function cd-ranger --description="Change directory using ranger"
	set -l tempfile (mktemp)
	pwd > "$tempfile"

	ranger --show-only-dirs --choosedir="$tempfile" \
		--cmd="set collapse_preview true" \
		--cmd="set preview_directories false" \
		--cmd="set preview_files false" \
		--cmd="set preview_images false" \
		--cmd="set padding_right false" \
		--cmd="set column_ratios 1,2,0"

	set -l newdir (cat "$tempfile")
	rm "$tempfile"
	cd "$newdir"
end

