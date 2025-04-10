# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# develop profile is my standard setup with common development tools.
# It won't install any compilers, but it will install support tools and
# command-line programs.
# ==============================================================================
{ ... }:
{

  my-dotfiles.btop.enable = true;
  my-dotfiles.carapace.enable = true;
  my-dotfiles.eza.enable = true;
  my-dotfiles.fd.enable = true;
  my-dotfiles.fzf.enable = true;
  my-dotfiles.bat.enable = true;
  my-dotfiles.glow.enable = true;
  my-dotfiles.ripgrep.enable = true;
  my-dotfiles.zoxide.enable = true;

  my-dotfiles.direnv = {
    enable = true; # Used to activate devenv automatically.
    hideDiff = true;
  };

  my-dotfiles.devenv = {
    enable = true;
    inPrompt = true;
  };

  my-dotfiles.fish = {
    enable = true;
    isSHELL = true;
  };

  my-dotfiles.oh-my-posh = {
    enable = true;
  };

  my-dotfiles.neovim = {
    enable = true;
    integrations.git = true;
    shellAliases.yvim = true;
    shellAliases.cvim = true;

    syntax = {
      yaml = true;
    };
  };

  my-dotfiles.git = {
    enable = true;
    inPrompt = true;

    github = true;
    fzf.fixup = true;

    useDelta = true;
    useDyff = true;
  };

  my-dotfiles.ranger = {
    enable = true;
    glow.forOpen = true;
    glow.forPreview = true;
  };

}
