# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://carapace.sh/
# ==============================================================================
{ lib, pkgs, config, ctx, ... }:
let
  inherit (lib) mkIf;
  cfg = config.my-dotfiles.carapace;
in
{
  options.my-dotfiles.carapace = {
    enable = lib.mkEnableOption "install and configure carapace";
  };

  config = mkIf cfg.enable (lib.mkMerge [

    # Configure carapace.
    {
      programs.carapace = {
        enable = true;
        enableFishIntegration = true;
      };
    }

  ]);
}
