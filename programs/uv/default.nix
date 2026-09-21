# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/ajeetdsouza/zoxide
# ==============================================================================
{
  lib,
  config,
  my-dotfiles,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.uv;
  cfgGlobal = config.my-dotfiles.global;
  nerdOr = my-dotfiles.lib.text.nerdOr cfgGlobal.nerdfonts;
in
{
  options.my-dotfiles.uv = {
    enable = lib.mkEnableOption "install and configure uv";
    inPrompt = lib.mkEnableOption "show Python venv info in the shell prompt" // {
      default = true;
    };
  };

  config = mkIf cfg.enable (mkMerge [

    # Configure uv.
    {
      programs.uv = {
        enable = true;
      };
    }

    # Configure oh-my-posh to show Python venv info.
    (mkIf cfg.inPrompt {
      my-dotfiles.oh-my-posh.envAnnotations.venv = {
        priority = 0;
        type = "python";

        foreground = "p:envs_fg_venv";
        background = "p:envs_bg";

        style = "diamond";
        leading_diamond = " ";
        trailing_diamond = "";

        display_mode = "environment"; # Only show within a venv.
        display_default = false;
        fetch_virtual_env = false;
        cache_duration = "30s";
        tooling = [ "uv" ];

        template = (
          builtins.concatStringsSep "" [
            (
              # EC39
              nerdOr " " "Py "
            )
            "{{ .Major }}.{{ .Minor }}"
          ]
        );
      };
    })

  ]);
}
