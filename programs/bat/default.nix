# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/sharkdp/bat
# ==============================================================================
{ lib, pkgs, config, ctx, ... }:
let
  inherit (lib) mkIf;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  cfg = config.my-dotfiles.bat;
in
{
  options.my-dotfiles.bat = with lib; {
    enable = mkEnableOption "install and configure bat";

    enableBatman = mkOption {
      type = types.bool;
      description = "Enable batman for reading manpages.";
      default = true;
    };
  };

  config = mkIf cfg.enable (lib.mkMerge [

    # Configure bat.
    {
      programs.bat = {
        enable = true;
        config = {
          tabs = "4";
          pager = "less --RAW-CONTROL-CHARS";
        };
      };
    }

    # Configure batman.
    (mkIf cfg.enableBatman {
      programs.bat.extraPackages = with pkgs.bat-extras; [ batman ];

      # TODO: shell alias from `man` -> `batman`
    })

  ]);
}
