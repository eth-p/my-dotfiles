# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# This references all the overlays under this directory.
#
# All of them must be loaded by home-manager as modules.
# ==============================================================================
{ ... } @ inputs: (final: prev: {
  oh-my-posh = (import ./oh-my-posh.nix final prev);
  neovim-unwrapped = (import ./HACK.neovim-unwrapped.nix final prev);
})
