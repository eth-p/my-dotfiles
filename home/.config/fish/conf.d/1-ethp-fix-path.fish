# my-dotfiles | Copyright (C) 2021 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
# =============================================================================
#
# Summary
# -------
#
#   This init script will prepend common bin directories to the $PATH
#   variable.
#
# How it's used in my-dotfiles
# ----------------------------
#
#   Some systems (e.g. macOS) come with a minimal PATH and no easy way
#   to configure it. This adds common directories back into the PATH, so
#   user-installed command line programs take priority over system ones.
#
# =============================================================================
function prepend_path
	if [ -d $argv[1] ] && [ $argv[1] != "/bin" ]
		fish_add_path --path --prepend --move $argv
	end
end

# Add Homebrew-installed binaries to the path.
prepend_path "/usr/local/bin"
prepend_path "/opt/homebrew/bin"

# Add go to the path.
prepend_path "$HOME/.go/bin"
prepend_path "$GOPATH/bin"

# Add cargo to the path.
prepend_path "$HOME/.cargo/bin"
prepend_path "$CARGO_HOME/bin"

# Add ~/.local/bin to the path.
prepend_path "$HOME/.local/bin"

# Homebrew tools.
if command -vq brew
	set brew_prefix (brew --prefix)

	# Add google-cloud-sdk to the path.
	set gcloud_path "$brew_prefix/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc"
	if [ -f "$gcloud_path" ]; source "$gcloud_path"; end

	# Add openjdk to the path.
	set openjdk_path "$brew_prefix/opt/openjdk/bin"
	if [ -d "$openjdk_path" ]; prepend_path "$openjdk_path"; end
end

# Remove the prepend_path utility.
functions -e prepend_path

