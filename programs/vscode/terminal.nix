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
  defaultShell = config._my-dotfiles.shell;
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
      programs.vscode.profiles.default.userSettings =
        let
          runDefaultShell =
            if defaultShell.package != null then lib.escapeShellArg defaultShell.executable else "\"$SHELL\"";

          # Create a wrapper that drops back into the default shell if the
          # devenv.nix flake could not be found.
          wrapper = pkgs.writeShellApplication {
            name = "devenv-in-vscode";
            text = ''
              if [[ -f devenv.nix ]]; then
                if ! ${lib.getExe pkgs.devenv} shell ${runDefaultShell} "$@"; then
                  read -rsn1
                  exit 1
                fi
              fi

              echo "error: No devenv.nix in current directory."
              exec ${runDefaultShell} "$@"
            '';
          };
        in
        {
          "terminal.integrated.profiles.${osName}" = {
            "devenv" = {
              "path" = lib.getExe wrapper;
              "icon" = "circuit-board";
            };
          };
        };
    })

  ]);
}
