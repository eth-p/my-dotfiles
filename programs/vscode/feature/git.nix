# my-dotfiles | Copyright (C) 2026 eth-p
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
  cfg = vscodeCfg.git;
in
{
  options.my-dotfiles.vscode.git = {
    enable = lib.mkEnableOption "enable git features" // {
      default = true;
    };

    blame.inEditor = lib.mkEnableOption "show git blame as an editor decoration" // {
      default = true;
    };
  };

  config = mkIf vscodeCfg.enable (mkMerge [

    {
      programs.vscode.profiles.default.userSettings = {
        "git.blame.editorDecoration.enabled" = cfg.blame.inEditor;
      };
    }

    # Disable git features if configured to.
    (mkIf (!cfg.enable) {
      programs.vscode.profiles.default.userSettings = {
        "git.enabled" = false;
      };
    })

  ]);
}
