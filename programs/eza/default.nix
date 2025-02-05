# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# My eza configuration.
# ==============================================================================
{ lib, pkgs, config, ctx, ... }:
let
  inherit (lib) mkIf;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  cfg = config.my-dotfiles.eza;
in
{
  options.my-dotfiles.eza = with lib; {
    enable = mkEnableOption "install and configure eza as a replacement for ls";

    enableAliases = mkOption {
      type = types.bool;
      description = "Enable shell aliases.";
      default = true;
    };
  };

  config = mkIf cfg.enable {

    # Configure eza.
    programs.eza = {
      enable = true;
      git = true; # uses libgit2

      enableBashIntegration = cfg.enableAliases;
      enableZshIntegration = cfg.enableAliases;
      enableFishIntegration = cfg.enableAliases;
      enableIonIntegration = cfg.enableAliases;
      enableNushellIntegration = cfg.enableAliases;
    };

  };

}
