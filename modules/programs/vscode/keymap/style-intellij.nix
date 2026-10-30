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
  inherit (pkgs.stdenv.targetPlatform) isDarwin;
  extensions = pkgs.vscode-extensions;
  vscodeCfg = vscode.getConfig config;
  cfg = vscodeCfg.keymap;
in
{
  config = mkIf (cfg.style == "intellij") (mkMerge [

    # Install IntelliJ IDEA Keybindings Extension
    # https://marketplace.visualstudio.com/items?itemName=k--kato.intellij-idea-keybindings
    {
      programs.vscode.profiles.default = {
        extensions = with extensions; [ k--kato.intellij-idea-keybindings ];
      };
    }

    # Custom bindings
    {

      # Intentionally use the direct config to bind shift-shift.
      # We don't want this to end up as a which-key.
      programs.vscode.profiles.default.keybindings = [

        # Bind "Show All Commands" to "shift shift".
        {
          key = "shift shift";
          command = "workbench.action.showCommands";
        }

      ];
    }

    # Unbind defaults: Common
    # Unbinding should be done against the config directly.
    {
      programs.vscode.profiles.default.keybindings = [

        # "Show All Commands"
        {
          key = if isDarwin then "cmd+p" else "ctrl+p";
          command = "-workbench.action.showCommands";
        }
        {
          key = if isDarwin then "cmd+shift+a" else "ctrl+shift+a";
          command = "-workbench.action.showCommands";
        }
        {
          key = if isDarwin then "cmd+shift+p" else "ctrl+shift+p";
          command = "-workbench.action.showCommands";
        }
        {
          key = "f1";
          command = "-workbench.action.showCommands";
        }

        # "Go to File..."
        {
          key = "shift shift";
          command = "-workbench.action.quickOpen";
        }

      ];

    }

    # Unbind defaults: MacOS-specific
    # Unbinding should be done against the config directly.
    (mkIf isDarwin {
      programs.vscode.profiles.default.keybindings = [

        # "Show All Commands"
        {
          key = "cmd+p";
          command = "-workbench.action.showCommands";
        }

        # "Configure Task Runner"
        {
          key = "cmd+;";
          command = "-workbench.action.tasks.configureTaskRunner";
        }

        # "Git: Commit All"
        {
          key = "cmd+k";
          command = "-git.commitAll";
          when = "!inDebugMode && !operationInProgress && !terminalFocus";
        }
      ];
    })

    # Unbind defaults: Other (not MacOS)-specific
    # Unbinding should be done against the config directly.
    (mkIf (!isDarwin) {
      programs.vscode.profiles.default.keybindings = [

        # "editor.action.smartSelect.grow"
        {
          key = "ctrl+w";
          command = "-editor.action.smartSelect.grow";
          when = "editorTextFocus";
        }

      ];
    })

  ]);
}
