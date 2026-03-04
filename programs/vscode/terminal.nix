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
  inherit (import ./lib.nix inputs) vscodeCfg;
  cfg = vscodeCfg;
  cfgFish = config.my-dotfiles.fish;
  cfgDevenv = config.my-dotfiles.devenv;
  osName = if pkgs.stdenv.isDarwin then "osx" else "linux";
  defaultShellPkg = if cfgFish.enable && cfgFish.isSHELL then pkgs.fish else null;
in
{
  config = mkIf (cfg.enable) (mkMerge [

    {
      programs.vscode.profiles.default.userSettings = {
        "terminal.integrated.allowedLinkSchemes" =
          cfg.config.allowedLinkSchemes.extras
          ++ (lib.optional cfg.config.allowedLinkSchemes.includeDefaults [
            "file"
            "http"
            "https"
            "mailto"
            "vscode"
            "vscode-insiders"
          ]);
      };
    }

    # Configure to support the `fish` shell.
    (mkIf cfgFish.enable {
      programs.vscode.profiles.default.userSettings = {
        "terminal.integrated.profiles.${osName}" = {
          "fish" = {
            "path" = lib.getExe pkgs.fish;
            "icon" = "terminal-bash";
          };
        };
      };
    })

    (mkIf (cfgFish.enable && cfgFish.isSHELL) {
      programs.vscode.profiles.default.userSettings = {
        "terminal.integrated.defaultProfile.${osName}" = "fish";
      };
    })

    # Configure to support `devenv shell`.
    (mkIf (cfgDevenv.enable) {
      programs.vscode.profiles.default.userSettings = {
        "terminal.integrated.profiles.${osName}" = {
          "devenv" = {
            "path" = lib.getExe pkgs.devenv;
            "icon" = "circuit-board";
            "args" = [
              "shell"
            ]
            ++ (lib.optionals (defaultShellPkg != null) [
              (lib.getExe defaultShellPkg)
            ]);
          };
        };
      };
    })

  ]);
}
