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
