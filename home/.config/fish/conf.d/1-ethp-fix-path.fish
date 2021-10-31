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

# Add /usr/local/bin to the path.
fish_add_path --path --prepend "/usr/local/bin"

# Add go to the path.
if [ -d "$HOME/.go/bin" ];       fish_add_path --path --prepend "$HOME/.go/bin"; end
if [ -n "$GOPATH" ] && [ -d "$GOPATH/bin" ]; fish_add_path --path --prepend "$GOPATH/bin"; end

# Add cargo to the path.
if [ -d "$HOME/.cargo/bin" ]; fish_add_path --path --prepend "$HOME/.cargo/bin"; end
if [ -n "$CARGO_HOME" ] && [ -d "$CARGO_HOME/bin" ]; fish_add_path --path --prepend "$CARGO_HOME/bin"; end

# Add ~/.local/bin to the path.
if [ -d "$HOME/.local/bin" ]; fish_add_path --path --prepend "$HOME/.local/bin"; end

# Homebrew tools.
if command -vq brew
	set brew_prefix (brew --prefix)

	# Add google-cloud-sdk to the path.
	set gcloud_path "$brew_prefix/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.fish.inc"
	if [ -f "$gcloud_path" ]; source "$gcloud_path"; end
end

