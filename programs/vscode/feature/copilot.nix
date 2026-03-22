# my-dotfiles | Copyright (C) 2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# ==============================================================================
{
  lib,
  pkgs,
  config,
  ...
}@inputs:
let
  inherit (lib) mkIf mkMerge mkDefault;
  inherit (import ../lib inputs) vscodeCfg;
  extensions = pkgs.vscode-extensions;
  cfg = vscodeCfg.misc.copilot;
in
{
  options.my-dotfiles.vscode.misc.copilot = {
    enable = lib.mkEnableOption "add GitHub Copilot to Visual Studio Code";
  };

  config = mkIf (vscodeCfg.enable && cfg.enable) (mkMerge [

    {
      programs.vscode = {
        profiles.default.extensions = with extensions; [
          # Install the GitHub Copilot extension.
          # https://marketplace.visualstudio.com/items?itemName=github.copilot-chat
          github.copilot-chat
        ];
      };
    }

  ]);
}
