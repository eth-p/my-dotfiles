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

  ]);
}
