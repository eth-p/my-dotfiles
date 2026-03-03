# my-dotfiles | Copyright (C) 2025 eth-p
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
  inherit (import ./lib.nix inputs) vscodeCfg;
  extensions = pkgs.vscode-extensions;
  cfg = vscodeCfg.language.python;
  cfgDevenv = config.my-dotfiles.devenv;
in
{
  options.my-dotfiles.vscode.language.python = {
    enable = lib.mkEnableOption "add python language support to Visual Studio Code";
  };

  config = mkIf (vscodeCfg.enable && cfg.enable) (mkMerge [

    {
      programs.vscode = {
        profiles.default.extensions = with extensions; [
          # Install the Python extension.
          # https://marketplace.visualstudio.com/items?itemName=ms-python.python
          ms-python.python

          # Install the Python Environments extension.
          # https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-python-envs
          ms-python.vscode-python-envs
        ];
      };
    }

  ]);
}
