# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/quexten/goldwarden
# ==============================================================================
{ lib, config, pkgs, ... } @ inputs:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.goldwarden;
in
{
  options.my-dotfiles.goldwarden = {
    enable = lib.mkEnableOption "install goldwarden";
  };

  config = mkMerge [

    # Install goldwarden.
    (mkIf cfg.enable {
      home.packages = [
        pkgs.goldwarden
      ];
    })

    # Install systemd service for goldwarden daemon (Linux only)
    (mkIf pkgs.stdenv.isLinux {
      systemd.user.services.goldwarden = {
        Unit = {
          Description = "Goldwarden daemon";
          After = [ "graphical-session.target" ];
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.goldwarden + "/bin/goldwarden"} daemonize";
        };
      };
    })

  ];
}
