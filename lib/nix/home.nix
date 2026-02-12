# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Helpers for creating a home-manager flake using my-dotfiles.
# ==============================================================================
{
  lib,
  my-dotfiles,
  home-manager,
  nixpkgs,
  vicinae,
  ...
}@inputs:
let
  inherit (my-dotfiles.lib.util) getOrDefault;
in
rec {

  # profileModules maps my-dotfiles profile names to home-manager modules.
  profileModules = {
    minimal = [ ../../profiles/minimal.nix ];
    standard = [ ../../profiles/standard.nix ];
    development = [ ../../profiles/development.nix ];
  };

  # mkHomeConfiguration provides a way to create a home-manager configuration
  # without having to set up all the manual boilerplate.
  mkHomeConfiguration =
    {
      system,
      modules,
      profile ? null,
      extraSpecialArgs ? { },
    }:
    let
      # Add overlays.
      overlays = [
        my-dotfiles.overlays.default
        vicinae.overlays.default
      ];

      # Get the nixpkgs for the specified platform.
      pkgs = import nixpkgs { inherit system overlays; };

      # Get the profile module.
      profileMod = (if profile == null then [ ] else getOrDefault profileModules profile [ ]);
    in
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules =
        my-dotfiles.homeModules
        ++ [
          vicinae.homeManagerModules.default
        ]
        ++ profileMod
        ++ modules;
      extraSpecialArgs = extraSpecialArgs // {
        my-dotfiles = my-dotfiles // {
          inherit inputs;
        };
      };
    };

}
