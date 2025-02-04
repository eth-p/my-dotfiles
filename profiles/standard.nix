# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# standard profile is my standard setup without any development tools.
# It tries to be light, only containing quality of life programs
# and settings.
# ==============================================================================
{ ... }:
{

  my-dotfiles.neovim.enable = true;

  my-dotfiles.git = {
    enable = true;
    useDelta = true;
    useDyff = true;
  };

}
