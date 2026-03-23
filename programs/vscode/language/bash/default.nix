# my-dotfiles | Copyright (C) 2025-2026 eth-p
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
  cfg = vscodeCfg.language.bash;
in
{
  options.my-dotfiles.vscode.language.bash = {
    enable = lib.mkEnableOption "add Bash language support to Visual Studio Code";

    shellcheck = {
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.shellcheck;
        description = "the shellcheck package";
      };
    };
  };

  config = mkIf (vscodeCfg.enable && cfg.enable) (mkMerge [

    # Install the Shellcheck extension.
    # https://marketplace.visualstudio.com/items?itemName=timonwong.shellcheck
    {
      programs.vscode = {
        profiles.default.extensions = with extensions; [
          timonwong.shellcheck
        ];

        profiles.default.userSettings = {
          "shellcheck.executablePath" = lib.getExe cfg.shellcheck.package;
          "shellcheck.customArgs" = [ "-x" ];
          "shellcheck.disableVersionCheck" = true;
        };
      };
    }

    # Install the shfmt extension.
    # https://marketplace.visualstudio.com/items?itemName=mkhl.shfmt
    {
      my-dotfiles.vscode.editor.editorconfig = lib.mkForce true; # dependency
      programs.vscode = {
        profiles.default.extensions = with extensions; [
          mkhl.shfmt
        ];

        profiles.default.userSettings = {
          "shfmt.executablePath" = pkgs.shfmt + "/bin/shfmt";
        };
      };
    }
  ]);
}
