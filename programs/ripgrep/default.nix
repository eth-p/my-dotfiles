# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/BurntSushi/ripgrep
# ==============================================================================
{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf;
  cfg = config.my-dotfiles.ripgrep;
in
{
  options.my-dotfiles.ripgrep = {
    enable = lib.mkEnableOption "install ripgrep";
  };

  config = mkIf cfg.enable {
    programs.ripgrep.enable = true;
  };
}
