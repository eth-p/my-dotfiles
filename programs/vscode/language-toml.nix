# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# ==============================================================================
{ lib, config, pkgs, pkgs-unstable, ... }:
let
  inherit (lib) mkIf mkMerge;
  vscodeCfg = config.my-dotfiles.vscode;
  cfg = config.my-dotfiles.vscode.language.toml;
  extensions = pkgs-unstable.vscode-extensions;
in
{
  options.my-dotfiles.vscode.language.toml = {
    enable =
      lib.mkEnableOption "add TOML language support to Visual Studio Code";
  };

  config = mkIf (vscodeCfg.enable && cfg.enable) (mkMerge [

    {
      programs.vscode = {
        # Install the Even Better TOML extension.
        # https://marketplace.visualstudio.com/items?itemName=tamasfe.even-better-toml
        profiles.default.extensions = with extensions;
          [ tamasfe.even-better-toml ];
      };
    }

  ]);
}
