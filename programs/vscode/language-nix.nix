# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# ==============================================================================
{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkMerge;
  vscodeCfg = config.my-dotfiles.vscode;
  cfg = config.my-dotfiles.vscode.language.nix;
in
{
  options.my-dotfiles.vscode.language.nix = {
    enable =
      lib.mkEnableOption "add Nix language support to Visual Studio Code";

    lsp.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "use a Language Server for Nix language support";
    };

    formatter = lib.mkOption {
      type = lib.types.enum [ "nixfmt" ];
      default = "nixfmt";
      description = "the formatter to use for Nix files";
    };
  };

  config = mkIf (vscodeCfg.enable && cfg.enable) (mkMerge [

    # Install the Nix IDE extension.
    # https://marketplace.visualstudio.com/items?itemName=jnoortheen.nix-ide
    {
      programs.vscode = {
        profiles.default.extensions = with pkgs.vscode-extensions;
          [ jnoortheen.nix-ide ];
      };
    }

    # Install `nidx` and use it as the Nix LSP.
    (mkIf cfg.lsp.enable {
      programs.vscode.profiles.default.userSettings = {
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = pkgs.nixd + "/bin/nixd";
      };
    })

    # Install `nixfmt` and use it for formatting.
    (mkIf (cfg.formatter == "nixfmt") (

      let formatter = pkgs.nixfmt + "/bin/nixfmt";
      in {
        programs.vscode.profiles.default.userSettings = {
          "nix.formatterPath" = [ formatter ];
          "nix.serverSettings".nixd.formatting.command = [ formatter ];
        };
      }
    ))

  ]);
}
