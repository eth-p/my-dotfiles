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
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixpkgs is for installing packages.
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, home-manager, ... } @ inputs: {

    # lib provides reusable library functions.
    lib = (import ./lib/nix) { lib = nixpkgs.lib; } // inputs;

    # homeConfigurations declares the home-manager profiles.
    #
    # This performs a map operation over each profile declared in
    # `./profiles` to create a corresponding per-system
    # `home-manager.lib.homeManagerConfiguration` instance.
    homeConfigurations = (
      let

        # Read system-specific settings generated by the bootstrap script.
        bootstrap = builtins.fromJSON (builtins.readFile ./bootstrap.json);
        system = bootstrap.system;

        # Get the nixpkgs for the current platform.
        pkgs = import nixpkgs { inherit system; };
        pkgs-unstable = import nixpkgs-unstable { inherit system; };

        # Get program modules.
        modules = import ./programs;

        # Get the declarative profiles.
        profiles = {
          minimal = ./profiles/minimal.nix;
          standard = ./profiles/standard.nix;
          development = ./profiles/development.nix;
        };

      in

      # profile -> homeManagerConfiguration { (defaults), ...profile }
      builtins.mapAttrs
        (profileName: profileFile:
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = modules ++ [
              ./programs/globals.nix
              profileFile
              ./bootstrap.nix
              ./config.nix
            ];
            extraSpecialArgs = {
              inherit pkgs-unstable;
              my-dotfiles = self // {
                inherit bootstrap;
              };
            };
          }
        )
        profiles

    );
  };
}
