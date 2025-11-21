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
  cfg = vscodeCfg.language.makefile;
in
{
  options.my-dotfiles.vscode.language.makefile = {
    enable = lib.mkEnableOption "add Makefile language support to Visual Studio Code";

    showWhitespace = lib.mkOption {
      type = lib.types.bool;
      description = "Show boundary whitespace in Makefiles.";
      default = true;
    };
  };

  config = mkIf (vscodeCfg.enable && cfg.enable) (mkMerge [

    # Install the Makefile Tools extension.
    # https://marketplace.visualstudio.com/items?itemName=ms-vscode.makefile-tools
    {
      programs.vscode = {
        profiles.default.extensions = with extensions; [
          ms-vscode.makefile-tools
        ];

        profiles.default.userSettings = {
          "[makefile]" = {
            "editor.renderWhitespace" = "boundary";
          };
        };
      };
    }
  ]);
}
