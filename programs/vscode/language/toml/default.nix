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
  cfg = vscodeCfg.language.toml;
in
{
  options.my-dotfiles.vscode.language.toml = {
    enable = lib.mkEnableOption "add TOML language support to Visual Studio Code";
  };

  config = mkIf (vscodeCfg.enable && cfg.enable) (mkMerge [

    {
      programs.vscode = {
        # Install the Even Better TOML extension.
        # https://marketplace.visualstudio.com/items?itemName=tamasfe.even-better-toml
        profiles.default.extensions = with extensions; [ tamasfe.even-better-toml ];
      };
    }

  ]);
}
