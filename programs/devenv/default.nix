# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://devenv.sh/
# ==============================================================================
{ lib, pkgs, pkgs-unstable, config, ctx, my-dotfiles, ... } @ inputs:
let
  inherit (lib) mkIf;
  inherit (my-dotfiles.lib.withConfig inputs) nerdglyphOr;
  cfg = config.my-dotfiles.devenv;
in
{
  options.my-dotfiles.devenv = {
    enable = lib.mkEnableOption "install devenv";
    inPrompt = lib.mkEnableOption "show git info in the shell prompt";
  };

  config = mkIf cfg.enable (lib.mkMerge [

    # Configure devenv.
    {
      home.packages = [
        pkgs-unstable.devenv
      ];
    }

    # Configure oh-my-posh to show devenv info.
    (mkIf cfg.inPrompt {
      my-dotfiles.oh-my-posh.envAnnotations.devenv = {
        priority = 0;
        type = "text";

        foreground = "p:envs_fg_devenv";
        background = "p:envs_bg";

        style = "diamond";
        leading_diamond = " ";
        trailing_diamond = "";

        template = (builtins.concatStringsSep "" [
          "{{ if .Env.DEVENV_ROOT }}"
          (nerdglyphOr "EEF4" "devenv")
          "{{ end }}"
        ]);
      };
    })

  ]);
}
