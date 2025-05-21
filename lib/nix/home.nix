# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Helpers for creating a home-manager flake using my-dotfiles.
# ==============================================================================
{ lib, my-dotfiles, home-manager, nixpkgs, nixpkgs-unstable, ... } @ inputs:
let inherit (my-dotfiles.lib.util) getOrDefault;
in rec {

  # profileModules maps my-dotfiles profile names to home-manager modules.
  profileModules = {
    minimal = [ ../../profiles/minimal.nix ];
    standard = [ ../../profiles/standard.nix ];
    development = [ ../../profiles/development.nix ];
  };

  # mkHomeConfiguration provides a way to create a home-manager configuration
  # without having to set up all the manual boilerplate.
  mkHomeConfiguration =
    { system
    , modules
    , profile ? null
    ,
    }:
    let
      # Add overlays.
      overlays = [
        my-dotfiles.overlay
      ];

      # Get the nixpkgs for the specified platform.
      pkgs = import nixpkgs { inherit system overlays; };
      pkgs-unstable = import nixpkgs-unstable { inherit system overlays; };

      # Get the profile module.
      profileMod = (
        if profile == null
        then [ ]
        else getOrDefault profileModules profile [ ]
      );
    in
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules =
        my-dotfiles.homeModules
        ++ profileMod
        ++ modules;
      extraSpecialArgs = {
        inherit pkgs-unstable;
        my-dotfiles = my-dotfiles // { inherit inputs; };
      };
    };

}
