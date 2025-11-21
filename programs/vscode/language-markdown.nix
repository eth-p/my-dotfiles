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
  cfg = vscodeCfg.language.markdown;
in
{
  options.my-dotfiles.vscode.language.markdown = {
    enable = lib.mkEnableOption "add Markdown language extensions to Visual Studio Code" // {
      default = true;
    };
  };

  config = mkIf (vscodeCfg.enable && cfg.enable) (mkMerge [

    # Install extensions from GitHub Markdown Preview pack.
    #
    # https://marketplace.visualstudio.com/items?itemName=yahyabatulu.vscode-markdown-alert
    # https://marketplace.visualstudio.com/items?itemName=bierner.markdown-checkbox
    # https://marketplace.visualstudio.com/items?itemName=bierner.markdown-footnotes
    # https://marketplace.visualstudio.com/items?itemName=bierner.markdown-mermaid
    # https://marketplace.visualstudio.com/items?itemName=bierner.markdown-emoji
    {
      programs.vscode.profiles.default.extensions = with extensions; [
        yahyabatulu.vscode-markdown-alert
        bierner.markdown-checkbox
        bierner.markdown-footnotes
        bierner.markdown-mermaid
        bierner.markdown-emoji
      ];
    }

    # Disable format-on-save for Markdown.
    {
      programs.vscode.profiles.default.userSettings = {
        "[markdown]" = {
          "editor.formatOnSave" = false;
        };
      };
    }

  ]);
}
