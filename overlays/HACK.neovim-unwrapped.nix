# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# https://github.com/NixOS/nixpkgs/issues/402998
# A hacky fix to enable neovim from nixpkgs unstable to be used with nixpkgs
# 24.11.
# ==============================================================================
final: prev: prev.neovim-unwrapped.overrideAttrs (old: {
  meta = old.meta or { } // {
    maintainers = [ ];
  };
})
