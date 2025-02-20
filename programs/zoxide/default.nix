# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/ajeetdsouza/zoxide
# ==============================================================================
{ lib, pkgs, config, ctx, ... }:
let
  inherit (lib) mkIf;
  cfg = config.my-dotfiles.zoxide;
in
{
  options.my-dotfiles.zoxide = with lib; {
    enable = mkEnableOption "install and configure zoxide";
  };

  config = mkIf cfg.enable (lib.mkMerge [

    # Configure zoxide.
    {
      programs.zoxide = {
        enable = true;
      };
    }

  ]);
}
