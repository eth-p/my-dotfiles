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

    # library functions.
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, nixpkgs-unstable, flake-utils, home-manager, ... } @ inputs:
    let
      inherit (home-manager.lib) homeManagerConfiguration;

      # Read information from the bootstrap data.
      bootstrap = builtins.fromJSON (builtins.readFile ./bootstrap.json);
      system = bootstrap.system;

    in
    {
      # homeConfigurations declares the home-manager profiles.
      # 
      # This performs a map operation over each profile declared in
      # `./profiles` to create a corresponding per-system
      # `home-manager.lib.homeManagerConfiguration` instance.
      homeConfigurations = (
        let
          # Get the nixpkgs for the current system (platform).
          pkgs = import nixpkgs { inherit system; };
          pkgs-unstable = import nixpkgs-unstable { inherit system; };

          # Utilities to pass around.
          ctx = {
            inherit bootstrap;
            isDarwin = (builtins.elem system nixpkgs.lib.platforms.darwin);
          };

          # Get program modules.
          modules = import ./programs;

          # Get the declarative profiles.
          profiles = {
            minimal = ./profiles/minimal.nix;
            standard = ./profiles/standard.nix;
          };
        in

        # profile -> homeManagerConfiguration { (defaults), ...profile }
        builtins.mapAttrs
          (profileName: profileFile:
            homeManagerConfiguration {
              inherit pkgs;
              modules = modules ++ [ profileFile ./bootstrap.nix ./config.nix ];
              extraSpecialArgs = {
                inherit ctx;
                inherit pkgs-unstable;
              };
            }
          )
          profiles

      );
    };
}
