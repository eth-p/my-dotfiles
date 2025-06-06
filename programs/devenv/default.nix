# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://devenv.sh/
# ==============================================================================
{ lib, config, pkgs, pkgs-unstable, my-dotfiles, ... } @ inputs:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.devenv;
  cfgGlobal = config.my-dotfiles.global;
  nerdOr = my-dotfiles.lib.text.nerdOr cfgGlobal.nerdfonts;
in
{
  options.my-dotfiles.devenv = {
    enable = lib.mkEnableOption "install devenv";
    inPrompt = lib.mkEnableOption "show git info in the shell prompt";
  };

  config = mkIf cfg.enable (mkMerge [

    # Configure devenv.
    {
      home.packages = [
        pkgs.devenv
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
          (nerdOr /* F1064 */ "󱁤 " "devenv")
          "{{ end }}"
        ]);
      };
    })

  ]);
}
