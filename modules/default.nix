# my-dotfiles | Copyright (C) 2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# This imports all the modules under this directory.
# ==============================================================================
{
  ...
}:
{
  imports = [
    ./globals.nix
    ./internal.nix
    ./programs
  ];
}
