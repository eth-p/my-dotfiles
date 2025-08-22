# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# ==============================================================================
{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkMerge;
  vscodeCfg = config.my-dotfiles.vscode;
  cfg = config.my-dotfiles.vscode.remote.devcontainer;
  extensions = pkgs.vscode-extensions;
in
{
  options.my-dotfiles.vscode.remote.devcontainer = {
    enable =
      lib.mkEnableOption "add support for running VS Code in dev containers";
  };

  config = mkIf (vscodeCfg.enable && cfg.enable) (mkMerge [

    {
      programs.vscode = {
        # Install the Devcontainers extension.
        # https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers
        profiles.default.extensions = with extensions;
          [ ms-vscode-remote.remote-containers ];

      };

      my-dotfiles.vscode.dependencies.unfreePackages = [
        "vscode-extension-ms-vscode-remote-remote-containers"
      ];
    }

  ]);
}
