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
    vicinae.url = "github:vicinaehq/vicinae/v0.14.5";

    # My own packages:
    kubesel = {
      url = "github:eth-p/kubesel";
      inputs.nixpkgs.url = "nixpkgs/nixos-25.05";
    };
  };

  outputs = { self, nixpkgs, ... } @ inputs: rec {

    # lib provides reusable library functions.
    lib = (import ./lib/nix) ({ lib = nixpkgs.lib; my-dotfiles = self; } // inputs);

    # homeModules declares reusable home-manager modules.
    #
    # A few `extraSpecialArgs` are required:
    #  - `my-dotfiles`   (this flake)
    homeModules = (import ./programs) ++ [
      ./programs/globals.nix
    ];

    # overlay exports the overlays I use to update certain packages.
    overlay = (import ./overlays inputs);

    # packages exports my various utility scripts (or flake-installed programs)
    # as packages, making them easier to reuse between programs.
    packages =
      let
        defaultSystems = [
          "aarch64-darwin"
          "aarch64-linux"
          "x86_64-darwin"
          "x86_64-linux"
        ];

        inputsForSystem = system: {
          system = system;
          my-dotfiles = self;

          # Get nixpkgs for the system the package is being defined for.
          pkgs = import nixpkgs { inherit system; };
        };

        # Import the packages.
        #
        # Note: I declared them as `${package}.${system}` for organization
        # purposes. This is not what Nix expects, and consequently, these
        # can't be used directly by `nix flake run`.
        packageDefs = (import ./packages) {
          systems = {
            inherit defaultSystems;
            inputsForSystem = inputsForSystem;
            inputs = builtins.listToAttrs (map
              (sys: {
                name = sys;
                value = inputsForSystem sys;
              })
              defaultSystems);
          };
        };

        # To solve the above issue, I swap the order to `${system}.${package}`.
        #
        # This involves iterating all the systems and generating a new attrset
        # containing the subset of packages which support the given system.
        collectPackagesForSystem = sys:
          let
            packageSupportsSys = (name: packageDefs."${name}" ? "${sys}");
            packageForSys = (name: packageDefs."${name}"."${sys}");
            packageNames = builtins.attrNames packageDefs;
          in
          nixpkgs.lib.attrsets.mergeAttrsList (
            map
              (name: { "${name}" = (packageForSys name); })
              (builtins.filter packageSupportsSys packageNames)
          );

      in
      builtins.listToAttrs (
        map
          (sys: {
            name = sys;
            value = collectPackagesForSystem sys;
          })
          defaultSystems
      );


  };
}
