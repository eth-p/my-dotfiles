# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# ==============================================================================
{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  vscodeCfg = config.my-dotfiles.vscode;
  cfg = config.my-dotfiles.vscode.qol.todo;
  extensions = pkgs.vscode-extensions;
  darwinOr = if pkgs.stdenv.isDarwin then mac: _: mac else _: other: other;
in
{
  options.my-dotfiles.vscode.qol.todo = {
    enable = lib.mkEnableOption "improve TODO support";
  };

  config = mkIf (vscodeCfg.enable && cfg.enable) (mkMerge [

    # Install Todo Tree
    # https://marketplace.visualstudio.com/items?itemName=Gruntfuggly.todo-tree
    {
      programs.vscode = {
        profiles.default.extensions = with extensions; [
          gruntfuggly.todo-tree
        ];

        profiles.default.userSettings = {
          "todo-tree.general.automaticGitRefreshInterval" = 30;
          "todo-tree.filtering.ignoreGitSubmodules" = true;
          "todo-tree.tree.flat" = true;
          "todo-tree.tree.groupedByTag" = true;
          "todo-tree.regex.regex" = "(//|#|<!--|;|/\\*|^|^[ \\t]*(-|\\d+.))\\s*($TAGS)(?:\\([a-z]+\\))?:";
          "todo-tree.tree.labelFormat" = "\${filename}:\${line} — \${after}";
          "todo-tree.tree.showCurrentScanMode" = false;
          "todo-tree.tree.tagsOnly" = true;
          "todo-tree.tree.buttons.groupByTag" = false;
          "todo-tree.tree.buttons.viewStyle" = false;
          "todo-tree.regex.subTagRegex" = "(?:\\(([a-z]+)\\))?(?:: *)";
          "todo-tree.tree.showCountsInTree" = true;
          "todo-tree.tree.hideIconsWhenGroupedByTag" = false;

          "todo-tree.general.tags" = [
            "TODO"
            "FIXME"
            "BUG"
            "HACK"
          ];

          "todo-tree.general.tagGroups" = {
            "FIXME" = [
              "FIX"
              "FIXIT"
              "FIXME"
            ];
          };

          "todo-tree.highlights.defaultHighlight" = {
            "type" = "tag-and-subTag";
          };

          "todo-tree.highlights.customHighlight" = {
            "TODO" = {
              "background" = "#eaea75";
              "foreground" = "#000";
              "iconColour" = "#7e7e00";
            };
            "BUG" = {
              "background" = "#ffb22c";
              "foreground" = "#ffffff";
              "icon" = "bug";
              "iconColour" = "#ffb22c";
            };
            "HACK" = {
              "background" = "#d10000";
              "foreground" = "#ffb8b8";
              "iconColour" = "#d10000";
              "icon" = "dependabot";
            };
            "FIXME" = {
              "background" = "#b52424";
              "foreground" = "#fff";
              "iconColour" = "#d10000";
              "icon" = "tools";
            };
          };
        };
      };
    }

    # Keybindings
    {
      programs.vscode.profiles.default.keybindings = [


        # View: Show TODOs
        {
          "key" = darwinOr "cmd+k g t" "ctrl+k g t";
          "command" = "workbench.view.extension.todo-tree-container";
        }

      ];
    }

  ]);
}
