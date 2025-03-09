# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# This references all nix files this directory.
# ==============================================================================
{ ... } @ inputs: {
  tolua = (import ./tolua.nix) inputs;
  theming = (import ./theming.nix) inputs;
  withConfig = (import ./with-config.nix);
}
