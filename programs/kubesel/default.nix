# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/eth-p/kubesel
# ==============================================================================
{ lib, config, pkgs, my-dotfiles, ... } @ inputs:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.kubesel;
  cfgGlobal = config.my-dotfiles.global;
  nerdglyphOr = my-dotfiles.lib.text.nerdglyphOr cfgGlobal.nerdfonts;
in
{
  options.my-dotfiles.kubesel = {
    enable = lib.mkEnableOption "install kubesel";
  };

  config = mkIf cfg.enable (mkMerge [

    # Install kubesel.
    {
      home.packages = [
        my-dotfiles.packages.${pkgs.stdenv.system}.kubesel
      ];

      programs.fish.shellInit = ''
        # Initialize kubesel.
        status is-interactive; and begin
          kubesel init fish | source
        end
      '';
    }

  ]);
}
