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
      extensionOverlay = file: (import file final prev);
    in
    {
      vscode-extensions = prev.vscode-extensions // {
        marcovr.actions-shell-scripts = extensionOverlay ./vscode-extensions/marcovr.actions-shell-scripts.nix;
        yahyabatulu.vscode-markdown-alert = extensionOverlay ./vscode-extensions/yahyabatulu.vscode-markdown-alert.nix;
      };
    };
}
