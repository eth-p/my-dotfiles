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
  cfg = vscodeCfg.qol.github;
in
{
  options.my-dotfiles.vscode.qol.github = {
    enable = lib.mkEnableOption "add GitHub-centric extensions";
  };

  config = mkIf (vscodeCfg.enable && cfg.enable) (mkMerge [

    # Install GitHub Actions
    # https://marketplace.visualstudio.com/items?itemName=GitHub.vscode-github-actions
    {
      programs.vscode = {
        profiles.default.extensions = with extensions; [
          github.vscode-github-actions
        ];
      };
    }

    # GitHub Actions Shell Scripts
    # https://marketplace.visualstudio.com/items?itemName=marcovr.actions-shell-scripts
    {
      programs.vscode = {
        profiles.default.extensions = with extensions; [
          marcovr.actions-shell-scripts
        ];
      };
    }

    (mkIf vscodeCfg.language.bash.enable {
      programs.vscode.profiles.default.userSettings = {
        "actions-shell-scripts.shellcheckFolder" = vscodeCfg.language.bash.shellcheck.package + "/bin";
      };
    })

  ]);
}
