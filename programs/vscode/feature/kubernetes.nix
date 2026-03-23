# my-dotfiles | Copyright (C) 2025-2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# ==============================================================================
{
  lib,
  pkgs,
  config,
  my-dotfiles,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  inherit (my-dotfiles.lib.programs) vscode;
  extensions = pkgs.vscode-extensions;
  vscodeCfg = vscode.getConfig config;
  cfg = vscodeCfg.kubernetes;
in
{
  options.my-dotfiles.vscode.kubernetes = {
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
