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
  inherit (lib) mkIf mkMerge mkDefault;
  inherit (import ./lib.nix inputs) vscodeCfg;
  extensions = pkgs.vscode-extensions;
  cfg = vscodeCfg.language.python;
in
{
  options.my-dotfiles.vscode.language.python = {
    enable = lib.mkEnableOption "add python language support to Visual Studio Code";
  };

  config = mkIf (vscodeCfg.enable && cfg.enable) (mkMerge [

    {
      programs.vscode = {
        # Install the Python extension.
        # https://marketplace.visualstudio.com/items?itemName=ms-python.python
        profiles.default.extensions = with extensions; [ ms-python.python ];
      };

    }

  ]);
}
