# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# develop profile is my standard setup with common development tools.
# It won't install any compilers, but it will install support tools and
# command-line programs.
# ==============================================================================
{ lib, pkgs, ... }:
{

  my-dotfiles.btop.enable = lib.mkDefault true;
  my-dotfiles.carapace.enable = lib.mkDefault true;
  my-dotfiles.ets.enable = lib.mkDefault true;
  my-dotfiles.eza.enable = lib.mkDefault true;
  my-dotfiles.fd.enable = lib.mkDefault true;
  my-dotfiles.fzf.enable = lib.mkDefault true;
  my-dotfiles.bat.enable = lib.mkDefault true;
  my-dotfiles.glow.enable = lib.mkDefault true;
  my-dotfiles.ripgrep.enable = lib.mkDefault true;
  my-dotfiles.zoxide.enable = lib.mkDefault true;

  my-dotfiles.direnv = {
    enable = lib.mkDefault true; # Used to activate devenv automatically.
    hideDiff = lib.mkDefault true;
  };

  my-dotfiles.devenv = {
    enable = lib.mkDefault true;
    inPrompt = lib.mkDefault true;
  };

  my-dotfiles.fish = {
    enable = lib.mkDefault true;
    isSHELL = lib.mkDefault true;
  };

  my-dotfiles.oh-my-posh = {
    enable = lib.mkDefault true;
  };

  my-dotfiles.neovim = {
    enable = lib.mkDefault true;
    integrations.git = lib.mkDefault true;
    shellAliases.yvim = lib.mkDefault true;
    shellAliases.cvim = lib.mkDefault true;

    syntax = {
      yaml = lib.mkDefault true;
      nix = lib.mkDefault true;
    };
  };

  my-dotfiles.git = {
    enable = lib.mkDefault true;
    inPrompt = lib.mkDefault true;

    fzf.fixup = lib.mkDefault true;

    useDelta = lib.mkDefault true;
    useDyff = lib.mkDefault true;
  };

  my-dotfiles.github-cli = {
    enable = lib.mkDefault true;
  };

  my-dotfiles.ranger = {
    enable = lib.mkDefault true;
    glow.forOpen = lib.mkDefault true;
    glow.forPreview = lib.mkDefault true;
  };

  my-dotfiles.vscode = {
    language.bash.enable = lib.mkDefault true;
    language.markdown.enable = lib.mkDefault true;
    language.nix.enable = lib.mkDefault true;
    qol.todo.enable = true;
    qol.github.enable = true;
  };

  my-dotfiles.yq = {
    enable = lib.mkDefault true;
  };

  my-dotfiles.lf = {
    enable = lib.mkDefault true;
  };

  home.packages = [
    # Nix Language Server
    pkgs.nil
  ];

}
