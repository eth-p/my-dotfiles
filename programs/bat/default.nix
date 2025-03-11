# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/sharkdp/bat
# ==============================================================================
{ lib, config, pkgs, pkgs-unstable, ... }:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.bat;
in
{
  options.my-dotfiles.bat = {
    enable = lib.mkEnableOption "install and configure bat";

    enableBatman = lib.mkOption {
      type = lib.types.bool;
      description = "Enable batman for reading manpages.";
      default = true;
    };
  };

  config = mkIf cfg.enable (mkMerge [

    # Configure bat.
    {
      programs.bat = {
        enable = true;
        package = pkgs-unstable.bat;
        config = {
          tabs = "4";
          pager = "less --RAW-CONTROL-CHARS";
        };
      };
    }

    # Configure batman.
    (mkIf cfg.enableBatman {
      programs.bat.extraPackages = with pkgs-unstable.bat-extras; [ batman ];

      programs.fish.shellAliases = {
        man = "batman";
      };
    })

  ]);
}
