# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/vicinaehq/vicinae
# ==============================================================================
{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.programs.fd;
in
{
  options.my-dotfiles.programs.vicinae = {
    enable = lib.mkEnableOption "install vicinae";
  };

  config = mkIf cfg.enable (mkMerge [

    # Configure vicinae.
    {
      programs.vicinae = {
        enable = true;
        systemd = {
          enable = true;
          autoStart = true;
        };
      };
    }

  ]);
}
