# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# standard profile is my standard setup without any development tools.
# It tries to be light, only containing quality of life programs
# and settings.
# ==============================================================================
{ lib, ... }:
{
  my-dotfiles.programs = {
    btop.enable = lib.mkDefault true;
    carapace.enable = lib.mkDefault true;
    eza.enable = lib.mkDefault true;
    fd.enable = lib.mkDefault true;
    fzf.enable = lib.mkDefault true;
    bat.enable = lib.mkDefault true;
    glow.enable = lib.mkDefault true;
    ripgrep.enable = lib.mkDefault true;
    zoxide.enable = lib.mkDefault true;

    fish = {
      enable = lib.mkDefault true;
      isSHELL = lib.mkDefault true;
    };

    oh-my-posh = {
      enable = lib.mkDefault true;
    };

    neovim = {
      enable = lib.mkDefault true;
      integrations.git = lib.mkDefault false;
      shellAliases.cvim = lib.mkDefault true;
    };

    git = {
      enable = lib.mkDefault true;
      useDelta = lib.mkDefault true;
      useDyff = lib.mkDefault true;
    };

    ranger = {
      enable = lib.mkDefault true;
      glow.forOpen = lib.mkDefault true;
      glow.forPreview = lib.mkDefault true;
    };

    lf = {
      enable = lib.mkDefault true;
    };
  };
}
