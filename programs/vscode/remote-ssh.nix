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
  cfg = vscodeCfg.remote.ssh;
in
{
  options.my-dotfiles.vscode.remote.ssh = {
    enable = lib.mkEnableOption "add support for running VS Code over SSH" // {
      default = true;
    };
  };

  config = mkIf (vscodeCfg.enable && cfg.enable) (mkMerge [

    {
      programs.vscode = {
        # Install the Remote - SSH extension.
        # https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh
        profiles.default.extensions = with extensions; [ ms-vscode-remote.remote-ssh ];

      };

      my-dotfiles.vscode.dependencies.unfreePackages = [
        "vscode-extension-ms-vscode-remote-remote-ssh"
      ];
    }

  ]);
}
