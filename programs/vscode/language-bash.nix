# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# ==============================================================================
{ lib, config, pkgs, ... }@inputs:
let
  inherit (lib) mkIf mkMerge;
  vscodeCfg = config.my-dotfiles.vscode;
  cfg = config.my-dotfiles.vscode.language.bash;
  extensions = pkgs.vscode-extensions;
in
{
  options.my-dotfiles.vscode.language.bash = {
    enable =
      lib.mkEnableOption "add Bash language support to Visual Studio Code";

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
        profiles.default.extensions = with extensions;
          [
            timonwong.shellcheck
          ];

        profiles.default.userSettings = {
          "shellcheck.executablePath" = cfg.shellcheck.package + "/bin/shellcheck";
          "shellcheck.customArgs" = [ "-x" ];
          "shellcheck.disableVersionCheck" = true;
        };
      };
    }

    # Install the shfmt extension.
    # https://marketplace.visualstudio.com/items?itemName=mkhl.shfmt
    {
      my-dotfiles.vscode.editorconfig = lib.mkForce true; # dependency
      programs.vscode = {
        profiles.default.extensions = with extensions;
          [
            (import ./extensions/shfmt.nix inputs)
          ];

        profiles.default.userSettings = {
          "shfmt.executablePath" = pkgs.shfmt + "/bin/shfmt";
        };
      };
    }
  ]);
}
