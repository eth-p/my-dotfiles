# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/ajeetdsouza/zoxide
# ==============================================================================
{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.zoxide;
in
{
  options.my-dotfiles.zoxide = {
    enable = lib.mkEnableOption "install and configure zoxide";
  };

  config = mkIf cfg.enable (mkMerge [

    # Configure zoxide.
    {
      programs.zoxide = {
        enable = true;
      };
    }

  ]);
}
