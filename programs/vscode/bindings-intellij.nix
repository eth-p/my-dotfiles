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
}@inputs:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.vscode;
  extensions = pkgs.vscode-extensions;
  darwinOr = if pkgs.stdenv.isDarwin then mac: _: mac else _: other: other;
in
{
  config = mkIf (cfg.keybindings == "intellij") (mkMerge [

    # Install IntelliJ IDEA Keybindings Extension
    # https://marketplace.visualstudio.com/items?itemName=k--kato.intellij-idea-keybindings
    {
      programs.vscode.profiles.default = {
        extensions = with extensions; [ k--kato.intellij-idea-keybindings ];
      };
    }

    # Custom bindings
    {

      programs.vscode.profiles.default.keybindings = [

        # Bind "Show All Commands" to "shift shift".
        {
          "key" = "shift shift";
          "command" = "workbench.action.showCommands";
        }

      ];
    }

    # Unbind defaults: Common
    {

      programs.vscode.profiles.default.keybindings = [

        # "Show All Commands"
        {
          "key" = darwinOr "cmd+p" "ctrl+p";
          "command" = "-workbench.action.showCommands";
        }
        {
          "key" = darwinOr "cmd+shift+a" "ctrl+shift+a";
          "command" = "-workbench.action.showCommands";
        }
        {
          "key" = darwinOr "cmd+shift+p" "ctrl+shift+p";
          "command" = "-workbench.action.showCommands";
        }
        {
          "key" = "f1";
          "command" = "-workbench.action.showCommands";
        }

        # "Go to File..."
        {
          "key" = "shift shift";
          "command" = "-workbench.action.quickOpen";
        }

      ];

    }

    # Unbind defaults: MacOS-specific
    (mkIf pkgs.stdenv.isDarwin {
      programs.vscode.profiles.default.keybindings = [

        # "Show All Commands"
        {
          "key" = "cmd+p";
          "command" = "-workbench.action.showCommands";
        }

        # "Configure Task Runner"
        {
          "key" = "cmd+;";
          "command" = "-workbench.action.tasks.configureTaskRunner";
        }

        # "Git: Commit All"
        {
          "key" = "cmd+k";
          "command" = "-git.commitAll";
          "when" = "!inDebugMode && !operationInProgress && !terminalFocus";
        }
      ];
    })

    # Unbind defaults: Other (not MacOS)-specific
    (mkIf (!pkgs.stdenv.isDarwin) {
      programs.vscode.profiles.default.keybindings = [

        # "editor.action.smartSelect.grow"
        {
          "key" = "ctrl+w";
          "command" = "-editor.action.smartSelect.grow";
          "when" = "editorTextFocus";
        }

      ];
    })

  ]);
}
