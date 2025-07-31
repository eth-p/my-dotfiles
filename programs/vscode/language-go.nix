# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# ==============================================================================
{ lib, config, pkgs, pkgs-unstable, ... }:
let
  inherit (lib) mkIf mkMerge;
  vscodeCfg = config.my-dotfiles.vscode;
  cfg = config.my-dotfiles.vscode.language.go;
  extensions = pkgs-unstable.vscode-extensions;
in
{
  options.my-dotfiles.vscode.language.go = {
    enable =
      lib.mkEnableOption "add Go language support to Visual Studio Code";

    compiler.package = lib.mkOption {
      default = pkgs-unstable.go;
      description = "the Go compiler package";
    };

    debugger = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "install the Go debugger, dlv";
      };
      package = lib.mkOption {
        default = pkgs-unstable.delve;
        description = "the dlv package";
      };
    };

    linter = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "install golangci-lint for linting Go source code";
      };

      package = lib.mkOption {
        default = pkgs-unstable.golangci-lint;
        description = "the golangci-lint package";
      };
    };

    lsp = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "install the Go language server, gopls";
      };

      package = lib.mkOption {
        default = pkgs-unstable.gopls;
        description = "the gopls package";
      };
    };

    snippets = {
      general = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "add snippets for general language features";
      };
    };
  };

  config = mkIf (vscodeCfg.enable && cfg.enable) (mkMerge [

    # Install the Go extension and Go compiler.
    # https://marketplace.visualstudio.com/items?itemName=golang.go
    {
      programs.vscode = {
        profiles.default.extensions = with extensions;
          [
            golang.go
          ];

        profiles.default.userSettings = {
          "go.alternateTools" = {
            "go" = cfg.compiler.package + "/bin/go";
          };

          "go.survey.prompt" = false;
        };
      };
    }

    # Install the Go debugger, dlv.
    (mkIf cfg.debugger.enable {
      programs.vscode = {
        profiles.default.userSettings = {
          "go.alternateTools" = {
            "dlv" = cfg.debugger.package + "/bin/dlv";
          };
        };
      };
    })

    # Install the Go language server, gopls.
    (mkIf cfg.lsp.enable {
      programs.vscode = {
        profiles.default.userSettings = {
          "go.alternateTools" = {
            "gopls" = cfg.lsp.package + "/bin/gopls";
          };
        };
      };
    })

    # Install the Go linter, golangci-lint.
    (mkIf cfg.lsp.enable {
      programs.vscode = {
        profiles.default.userSettings = {
          "go.lintTool" = "golangci-lint-v2";
          "go.alternateTools" = {
            "golangci-lint-v2" = cfg.linter.package + "/bin/golangci-lint";
          };
        };
      };
    })

    # Add snippets for general language features.
    (mkIf cfg.lsp.enable {
      programs.vscode.profiles.default.languageSnippets.go = {
        "New interface type" = {
          "prefix" = "interface";
          "description" = "Create an interface";
          "body" = [
            "type \${1:name} interface {"
            "\t$0"
            "}"
          ];
        };

        "New struct type" = {
          "prefix" = "struct";
          "description" = "Create a struct";
          "body" = [
            "type \${1:name} struct {"
            "\t$0"
            "}"
          ];
        };

        "Receiver function" = {
          "prefix" = "impl";
          "description" = "Create a receiver function";
          "body" = [
            "func (\${1:s} *\${2:ty}) \${3:name}(\${4:params}) \${5:returns} {"
            "\t$0"
            "}"
          ];
        };

        "Assert implements" = {
          "prefix" = "assert interface";
          "description" = "Asserts that a type implements the given interface";
          "body" = [
            "var _ \${1:interface} = (*\${2:ty})(nil) // Asserts \${2} implements \${1}"
          ];
        };
      };
    })

  ]);
}
