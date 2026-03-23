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
  vscodeCfg = vscode.getConfig config;
  cfg = vscodeCfg;
  cfgFish = config.my-dotfiles.fish;
  osName = vscode.getTerminalPlatformName pkgs;
in
{
  config = mkIf (cfg.enable && cfgFish.enable) (mkMerge [

    {
      programs.vscode.profiles.default.userSettings = {
        "terminal.integrated.profiles.${osName}" = {
          "fish" = {
            "path" = lib.getExe pkgs.fish; # TODO: Make fish package configurable
            "icon" = "terminal-bash";
          };
        };
      };
    }

    # Set fish to the default shell if it's configured to be normally.
    (mkIf cfgFish.isSHELL {
      programs.vscode.profiles.default.userSettings = {
        "terminal.integrated.defaultProfile.${osName}" = "fish";
      };
    })

  ]);
}
