# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# ==============================================================================
{
  lib,
  pkgs,
  ...
}@inputs:
let
  inherit (lib) mkIf mkMerge;
  inherit (import ./lib.nix inputs) vscodeCfg;
  extensions = pkgs.vscode-extensions;
  cfg = vscodeCfg.qol.kubernetes;
in
{
  options.my-dotfiles.vscode.qol.kubernetes = {
    enable = lib.mkEnableOption "add Kubernetes-centric extensions";
  };

  config = mkIf (vscodeCfg.enable && cfg.enable) (mkMerge [

    # Install Kubernetes
    # https://marketplace.visualstudio.com/items?itemName=ms-kubernetes-tools.vscode-kubernetes-tools
    {
      programs.vscode = {
        profiles.default.extensions = with extensions; [
          ms-kubernetes-tools.vscode-kubernetes-tools
        ];
      };
    }

  ]);
}
