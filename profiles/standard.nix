# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# standard profile is my standard setup without any development tools.
# It tries to be light, only containing quality of life programs
# and settings.
# ==============================================================================
{ ... }:
{

  my-dotfiles.btop.enable = true;
  my-dotfiles.eza.enable = true;
  my-dotfiles.fd.enable = true;
  my-dotfiles.fzf.enable = true;
  my-dotfiles.bat.enable = true;
  my-dotfiles.glow.enable = true;
  my-dotfiles.ripgrep.enable = true;
  my-dotfiles.zoxide.enable = true;

  my-dotfiles.fish = {
    enable = true;
  };

  my-dotfiles.oh-my-posh = {
    enable = true;
  };

  my-dotfiles.neovim = {
    enable = true;
    integrations.git = false;
  };

  my-dotfiles.git = {
    enable = true;
    useDelta = true;
    useDyff = true;
  };

  my-dotfiles.ranger = {
    enable = true;
    glow.forOpen = true;
    glow.forPreview = true;
  };

}
