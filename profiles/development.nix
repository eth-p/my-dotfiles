# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# develop profile is my standard setup with common development tools.
# It won't install any compilers, but it will install support tools and
# command-line programs.
# ==============================================================================
{ lib, pkgs, ... }:
{
  my-dotfiles.programs = {
    btop.enable = lib.mkDefault true;
    carapace.enable = lib.mkDefault true;
    ets.enable = lib.mkDefault true;
    eza.enable = lib.mkDefault true;
    fd.enable = lib.mkDefault true;
    fzf.enable = lib.mkDefault true;
    bat.enable = lib.mkDefault true;
    glow.enable = lib.mkDefault true;
    ripgrep.enable = lib.mkDefault true;
    zoxide.enable = lib.mkDefault true;

    direnv = {
      enable = lib.mkDefault true; # Used to activate devenv automatically.
      hideDiff = lib.mkDefault true;
    };

    devenv = {
      enable = lib.mkDefault true;
      inPrompt = lib.mkDefault true;
    };

    fish = {
      enable = lib.mkDefault true;
      isSHELL = lib.mkDefault true;
    };

    oh-my-posh = {
      enable = lib.mkDefault true;
    };

    neovim = {
      enable = lib.mkDefault true;
      integrations.git = lib.mkDefault true;
      shellAliases.yvim = lib.mkDefault true;
      shellAliases.cvim = lib.mkDefault true;

      syntax = {
        yaml = lib.mkDefault true;
        nix = lib.mkDefault true;
      };
    };

    git = {
      enable = lib.mkDefault true;
      inPrompt = lib.mkDefault true;

      fzf.fixup = lib.mkDefault true;

      useDelta = lib.mkDefault true;
      useDyff = lib.mkDefault true;
    };

    github-cli = {
      enable = lib.mkDefault true;
    };

    ranger = {
      enable = lib.mkDefault true;
      glow.forOpen = lib.mkDefault true;
      glow.forPreview = lib.mkDefault true;
    };

    vscode = {
      language.bash.enable = lib.mkDefault true;
      language.markdown.enable = lib.mkDefault true;
      language.nix.enable = lib.mkDefault true;
      todos.enable = true;
      github.enable = true;
    };

    yq = {
      enable = lib.mkDefault true;
    };

    lf = {
      enable = lib.mkDefault true;
    };

  };

  home.packages = [
    # Nix Language Server
    pkgs.nil
  ];
}
