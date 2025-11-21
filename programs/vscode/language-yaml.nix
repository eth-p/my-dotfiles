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
  cfg = vscodeCfg.language.yaml;
in
{
  options.my-dotfiles.vscode.language.yaml = {
    enable = lib.mkEnableOption "add Yaml language support to Visual Studio Code";
  };

  config = mkIf (vscodeCfg.enable && cfg.enable) (mkMerge [

    # Install the YAML extension.
    # https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml
    {
      programs.vscode = {
        profiles.default.extensions = with extensions; [
          redhat.vscode-yaml
        ];

        profiles.default.userSettings = {
          "redhat.telemetry.enabled" = false;
        };
      };
    }
  ]);
}
