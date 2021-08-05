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

# Add ~/.local/bin to the path.
[ -d "$HOME/.local/bin" ] && fish_add_path --path --prepend "$HOME/.local/bin"

