# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# This references all the packages under this directory.
# ==============================================================================
{
  pkgs,
}:
{
  term-query-bg = pkgs.callPackage ./term-query-bg/package.nix { };

  golangci-lint-v1-bin = pkgs.callPackage ./golangci-lint-v1-bin/package.nix { };
  oh-my-posh-bin = pkgs.callPackage ./oh-my-posh-bin/package.nix { };
}
