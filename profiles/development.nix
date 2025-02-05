# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# develop profile is my standard setup with common development tools.
# It won't install any compilers, but it will install support tools and
# command-line programs.
# ==============================================================================
{ ... }:
{

  my-dotfiles.neovim = {
    enable = true;
    integrations.git = true;
  };

  my-dotfiles.git = {
    enable = true;
    useDelta = true;
    useDyff = true;
  };

}
