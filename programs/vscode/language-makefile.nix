# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# ==============================================================================
{ lib, config, pkgs, pkgs-unstable, ... }:
let
  inherit (lib) mkIf mkMerge;
  vscodeCfg = config.my-dotfiles.vscode;
  cfg = config.my-dotfiles.vscode.language.makefile;
  extensions = pkgs-unstable.vscode-extensions;
in
{
  options.my-dotfiles.vscode.language.makefile = {
    enable =
      lib.mkEnableOption "add Makefile language support to Visual Studio Code";
  };

  config = mkIf (vscodeCfg.enable && cfg.enable) (mkMerge [

    # Install the Makefile Tools extension.
    # https://marketplace.visualstudio.com/items?itemName=ms-vscode.makefile-tools
    {
      programs.vscode = {
        profiles.default.extensions = with extensions;
          [
            ms-vscode.makefile-tools
          ];

        profiles.default.userSettings = { };
      };
    }
  ]);
}
