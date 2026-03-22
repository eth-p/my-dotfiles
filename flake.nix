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
    vicinae.url = "github:vicinaehq/vicinae/v0.20.1";

    # My own packages:
    kubesel.url = "github:eth-p/kubesel";

    # systems lists the default nix systems.
    systems.url = "github:nix-systems/default";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      systems,

      vicinae,
      kubesel,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;

      defaultSystems = import systems;
      forDefaultSystems = fn: forEachSystem fn defaultSystems;
      forEachSystem = fn: systems: lib.genAttrs systems (system: fn system);

      selfLibOnly = { inherit (self) lib; };
      selfLibPackages = { inherit (self) lib packages legacyPackages; };

      # Default home-manager overlays and modules.
      hmOverlays = [
        self.overlays.default
        vicinae.overlays.default
        kubesel.overlays.default
      ];

      hmModules = [
        self.homeManagerModules.default
        vicinae.homeManagerModules.default
      ];

      myProfiles = {
        minimal = [ ./profiles/minimal.nix ];
        standard = [ ./profiles/standard.nix ];
        development = [ ./profiles/development.nix ];
      };

      # mkHomeConfiguration provides a way to create a home-manager configuration
      # without having to set up all the manual boilerplate.
      mkHomeConfiguration =
        {
          system,
          modules,
          profile ? null,
          overlays ? [ ],
          extraSpecialArgs ? { },
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            overlays = hmOverlays ++ overlays;
          };

          modules = hmModules ++ modules ++ (if profile == null then [ ] else myProfiles."${profile}");
          extraSpecialArgs = extraSpecialArgs // {
            my-dotfiles = selfLibPackages;
          };
        };

      # The library functions exported from this flake.
      # It only has access to the nixpkgs lib and itself.
      my-dotfiles-lib = (import ./lib/nix) {
        inherit lib;
        my-dotfiles = selfLibOnly;
      };
    in
    {

      # lib provides reusable library functions.
      #
      # These rely on the nixpkgs standard library.
      lib = my-dotfiles-lib // {
        home = { inherit mkHomeConfiguration; }; # alias
        inherit mkHomeConfiguration;
      };

      # overlays exports overlays used to insert the packages exported from
      # this flake into the standard `pkgs` variable accessible in home-manager
      # modules.
      overlays = (import ./overlays) {
        inherit lib;
        my-dotfiles = selfLibPackages;
      };

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

      # homeManagerModules declares reusable home-manager modules.
      #
      # In the `default` module set, `extraSpecialArgs` must contain this flake
      # passed through as `my-dotfiles`.
      homeManagerModules = {
        default = {
          imports = (import ./programs) ++ [
            ./programs/globals.nix
          ];
        };
      };
    };
}
