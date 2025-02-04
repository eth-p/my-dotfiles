# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# My neovim configuration.
# ==============================================================================
{ lib, pkgs, config, ... }:
let
  cfg = config.my-dotfiles.neovim;
  nvimHome = "${config.xdg.configHome}/nvim";
in
{
  options.my-dotfiles.neovim = with lib; {
    enable = mkEnableOption "neovim";
  };

  config = lib.mkIf cfg.enable {

    # Configure neovim.
    programs.neovim = {
      enable = true;
      viAlias = true; # Symlink `vi` to `nvim`
      defaultEditor = true; # Use neovim as $EDITOR
      extraLuaConfig = builtins.readFile ./init-security.lua;
    };

    # Add neovim configuration.
    home.file = {
      # "${nvimHome}/test.txt" = {
      #   text = "test";
      # };
    };

  };
}
