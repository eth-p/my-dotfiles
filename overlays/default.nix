# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# This references all the overlays.
# ==============================================================================
{ ... }@inputs:
rec {
  default = final: prev: (packages final prev) // (vscode-extensions final prev);

  packages =
    final: prev:
    let
      packageOverlay = file: (import file final prev);
    in
    {
      oh-my-posh = packageOverlay ./packages/oh-my-posh.nix;
      golangci-lint-v1 = packageOverlay ./packages/golangci-lint-v1.nix;
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
