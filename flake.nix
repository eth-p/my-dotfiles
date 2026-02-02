# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# This flake holds my configurations.
# ==============================================================================
{
  description = ''
    Flake to configure my dotfiles and user packages.
  '';

  inputs = {
    # home-manager is used to manage dotfiles and user config.
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixpkgs is for installing packages.
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # vicinae: https://github.com/vicinaehq/vicinae
    vicinae.url = "github:vicinaehq/vicinae/v0.19.3";

    # My own packages:
    kubesel = {
      url = "github:eth-p/kubesel";
      inputs.nixpkgs.url = "nixpkgs/nixos-25.05";
    };

    # systems lists the default nix systems.
    systems.url = "github:nix-systems/default";
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      ...
    }@inputs:
    let
      defaultSystems = import systems;
      forDefaultSystems = fn: forEachSystem fn defaultSystems;
      forEachSystem = fn: systems: nixpkgs.lib.genAttrs systems (system: fn system);
    in
    rec {

      # lib provides reusable library functions.
      lib = (import ./lib/nix) (
        {
          lib = nixpkgs.lib;
          my-dotfiles = self;
        }
        // inputs
      );

      # homeModules declares reusable home-manager modules.
      #
      # A few `extraSpecialArgs` are required:
      #  - `my-dotfiles`   (this flake)
      homeModules = (import ./programs) ++ [
        ./programs/globals.nix
      ];

      # overlays exports the overlays I use to update certain packages.
      overlays = (import ./overlays (inputs // { my-dotfiles = self; }));

      # packages exports custom packages.
      packages = forDefaultSystems (
        system:
        (import ./packages) {
          pkgs = (import nixpkgs { inherit system; });
        }
      );

      # legacyPackages exports custom package sets.
      legacyPackages = forDefaultSystems (system: {
        vscode-extensions = (
          import ./packages/vscode-extensions.nix {
            pkgs = nixpkgs.legacyPackages.${system};
            my-dotfiles = self;
          }
        );
      });
    };
}
