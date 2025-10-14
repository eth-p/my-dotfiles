# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# ==============================================================================
{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkMerge mkDefault;
  vscodeCfg = config.my-dotfiles.vscode;
  cfg = config.my-dotfiles.vscode.language.python;
  extensions = pkgs.vscode-extensions;
in
{
  options.my-dotfiles.vscode.language.python = {
    enable =
      lib.mkEnableOption "add python language support to Visual Studio Code";
  };

  config = mkIf (vscodeCfg.enable && cfg.enable) (mkMerge [

    {
      programs.vscode = {
        # Install the Python extension.
        # https://marketplace.visualstudio.com/items?itemName=ms-python.python
        profiles.default.extensions = with extensions;
          [ ms-python.python ];
      };

    }

  ]);
}
