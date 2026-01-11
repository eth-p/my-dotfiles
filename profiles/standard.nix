# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# standard profile is my standard setup without any development tools.
# It tries to be light, only containing quality of life programs
# and settings.
# ==============================================================================
{ lib, ... }:
{

  my-dotfiles.btop.enable = lib.mkDefault true;
  my-dotfiles.carapace.enable = lib.mkDefault true;
  my-dotfiles.eza.enable = lib.mkDefault true;
  my-dotfiles.fd.enable = lib.mkDefault true;
  my-dotfiles.fzf.enable = lib.mkDefault true;
  my-dotfiles.bat.enable = lib.mkDefault true;
  my-dotfiles.glow.enable = lib.mkDefault true;
  my-dotfiles.ripgrep.enable = lib.mkDefault true;
  my-dotfiles.zoxide.enable = lib.mkDefault true;

  my-dotfiles.fish = {
    enable = lib.mkDefault true;
    isSHELL = lib.mkDefault true;
  };

  my-dotfiles.oh-my-posh = {
    enable = lib.mkDefault true;
  };

  my-dotfiles.neovim = {
    enable = lib.mkDefault true;
    integrations.git = lib.mkDefault false;
    shellAliases.cvim = lib.mkDefault true;
  };

  my-dotfiles.git = {
    enable = lib.mkDefault true;
    useDelta = lib.mkDefault true;
    useDyff = lib.mkDefault true;
  };

  my-dotfiles.ranger = {
    enable = lib.mkDefault true;
    glow.forOpen = lib.mkDefault true;
    glow.forPreview = lib.mkDefault true;
  };

  my-dotfiles.lf = {
    enable = lib.mkDefault true;
  };

}
