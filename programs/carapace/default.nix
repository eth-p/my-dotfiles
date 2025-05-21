# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://carapace.sh/
# ==============================================================================
{ lib, config, pkgs, pkgs-unstable, ... }:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.carapace;
in
{
  options.my-dotfiles.carapace = {
    enable = lib.mkEnableOption "install and configure carapace";
  };

  config = mkIf cfg.enable (mkMerge [

    # Configure carapace.
    {
      programs.carapace = {
        enable = true;
        enableFishIntegration = true;

        package = lib.mkDefault pkgs.carapace;
      };
    }

  ]);
}
