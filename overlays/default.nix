# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# This references all the overlays.
# ==============================================================================
{ ... }@inputs:
rec {
  default = final: prev: (packages final prev);

  packages =
    final: prev:
    let
      packageOverlay = file: (import file final prev);
    in
    {
      oh-my-posh = packageOverlay ./packages/oh-my-posh.nix;
      golangci-lint-v1 = packageOverlay ./packages/golangci-lint-v1.nix;
    };
}
