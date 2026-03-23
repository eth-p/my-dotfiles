# my-dotfiles | Copyright (C) 2025 eth-p
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
  cfg = vscodeCfg.editor;
in
{
  options.my-dotfiles.vscode.editor = {
    editorconfig = lib.mkEnableOption "install the EditorConfig extension" // {
      default = true;
    };

    rulers = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      description = "Column numbers to draw a ruler at.";
      default = [
        80
        120
      ];
    };

    whitespace.showTrailing = lib.mkOption {
      type = lib.types.bool;
      description = "Highlight trailing whitespace.";
      default = true;
    };
  };

  config = mkIf vscodeCfg.enable (mkMerge [

    {
      programs.vscode.profiles.default.userSettings = {
        "editor.rulers" = cfg.rulers;
      };
    }

    # Install EditorConfig extension.
    # https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig
    (mkIf cfg.editorconfig {
      programs.vscode.profiles.default.extensions = with extensions; [
        editorconfig.editorconfig
      ];
    })

    # Install Trailing Whitespace extension.
    # https://marketplace.visualstudio.com/items?itemName=shardulm94.trailing-spaces
    (mkIf cfg.whitespace.showTrailing {
      programs.vscode.profiles.default.extensions = with extensions; [
        shardulm94.trailing-spaces
      ];

      programs.vscode.profiles.default.userSettings = {
        "trailing-spaces.backgroundColor" = "rgba(255, 0, 179, 0.3)";
        "trailing-spaces.borderColor" = "rgba(255, 88, 205, 0.15)";
        "trailing-spaces.trimOnSave" = false;
      };
    })

  ]);
}
