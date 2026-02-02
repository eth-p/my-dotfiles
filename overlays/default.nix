# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# This references all the overlays.
# ==============================================================================
{ my-dotfiles, ... }@inputs:
rec {
  default = final: prev: (packages final prev) // (vscode-extensions final prev);

  packages =
    final: prev:
    let
      system = final.stdenv.hostPlatform.system;
      packages = my-dotfiles.packages.${system};
    in
    {
      oh-my-posh = packages.oh-my-posh-bin;
      golangci-lint-v1 = packages.golangci-lint-v1-bin;
    };

  vscode-extensions =
    final: prev:
    let
      system = final.stdenv.hostPlatform.system;
      extensions = my-dotfiles.legacyPackages.${system}.vscode-extensions;
    in
    {
      vscode-extensions = prev.vscode-extensions // extensions;
    };
}
