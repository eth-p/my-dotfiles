# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Helpers for creating a home-manager flake using my-dotfiles.
# ==============================================================================
{ lib, my-dotfiles, home-manager, nixpkgs, nixpkgs-unstable, ... }:
{

  # mkHomeConfiguration provides a way to create a home-manager configuration
  # without having to set up all the manual boilerplate.
  mkHomeConfiguration =
    { system
    , modules
    ,
    }:
    let
      pkgs = import nixpkgs { inherit system overlays; };
      pkgs-unstable = import nixpkgs-unstable { inherit system overlays; };
      overlays = [ my-dotfiles.overlay ];
    in
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = my-dotfiles.homeModules ++ modules;
      extraSpecialArgs = {
        inherit my-dotfiles pkgs-unstable;
      };
    };

}
