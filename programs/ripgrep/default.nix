# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/BurntSushi/ripgrep
# ==============================================================================
{ lib, pkgs, config, ctx, ... }:
let
  inherit (lib) mkIf;
  cfg = config.my-dotfiles.ripgrep;
in
{
  options.my-dotfiles.ripgrep = with lib; {
    enable = mkEnableOption "install ripgrep";
  };

  config = mkIf cfg.enable {
    programs.ripgrep.enable = true;
  };
}
