# my-dotfiles | Copyright (C) 2026 eth-p
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
  cfg = vscodeCfg.copilot;
in
{
  options.my-dotfiles.vscode.copilot = {
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
