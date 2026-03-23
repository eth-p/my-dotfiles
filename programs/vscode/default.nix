# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# ==============================================================================
{
  lib,
  pkgs,
  config,
  my-dotfiles,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  inherit (lib.strings) concatStringsSep;
  inherit (my-dotfiles.lib.programs) vscode;
  extensions = pkgs.vscode-extensions;
  vscodeCfg = vscode.getConfig config;
  cfg = vscodeCfg;
in
{
  imports = [
    ./keymap
    ./feature
    ./language

    ./editor.nix
    ./terminal.nix
    ./terminal-integration-fish.nix
    ./terminal-integration-devenv.nix
    ./theme.nix
  ];

  options.my-dotfiles.vscode = {
    enable = lib.mkEnableOption "install and configure Visual Studio Code";
    onlyConfigure = lib.mkEnableOption "do not install Visual Studio Code, only configure it";

    fhs.enabled = lib.mkOption {
      type = lib.types.bool;
      description = "Use a FHS environment for VS Code.";
      default = false;
      readOnly = !pkgs.stdenv.isLinux;
    };

    dependencies.packages = lib.mkOption {
      type = my-dotfiles.lib.types.functionListTo lib.types.package;
      description = "Extra packages to install.";
      example = (
        pkgs: with pkgs; [
          gcc
          rustc
        ]
      );
      default = (pkgs: [ ]);
    };

    dependencies.unfreePackages = lib.mkOption {
      visible = false;
      type = lib.types.listOf lib.types.str;
      description = "Unfree packages to allow.";
      example = [ "vscode-extension-ms-vscode-remote-remote-ssh" ];
      default = [ ];
    };
  };

  config = mkIf cfg.enable (mkMerge [

    # Install Visual Studio Code.
    (
      let
        mkPkgList = pkgs: builtins.foldl' (a: b: a ++ (b pkgs)) [ ] cfg.dependencies.packages;
        mkWrapProgramPathPrependArgs = (p: "--prefix PATH : ${p + /bin}");

      in
      {
        programs.vscode = {
          enable = true;
          package =
            if cfg.fhs.enabled then
              (pkgs.vscode.fhsWithPackages mkPkgList)
            else
              (pkgs.vscode.overrideAttrs (
                old:
                let
                  wrapProgramArgs = concatStringsSep " \\\n" (map mkWrapProgramPathPrependArgs (mkPkgList pkgs));
                in
                {
                  postFixup = ''
                    ${old.postFixup}
                    wrapProgram $out/bin/code \
                      ${wrapProgramArgs}
                  '';
                }
              ));

          mutableExtensionsDir = false;
          profiles.default = {
            enableUpdateCheck = false;
            enableExtensionUpdateCheck = false;

            userSettings = {
            };
          };
        };

        nixpkgs.config.allowUnfreePredicate =
          pkg:
          builtins.elem (lib.getName pkg) (
            [
              "vscode"
              "code"
            ]
            ++ cfg.dependencies.unfreePackages
          );
      }
    )

    # If using a FHS environmment, shim a sudo-esque command that uses `run0`.
    (mkIf cfg.fhs.enabled {
      my-dotfiles.vscode.dependencies.packages = _: [
        (pkgs.writeShellApplication {
          name = "fhs-sudo";

          runtimeInputs = with pkgs; [
            bash
            coreutils # pwd
            util-linux # nsenter
            systemdMinimal # run0
          ];

          text = ''
            # shellcheck disable=SC2016
            run0 \
              nsenter --mount=/proc/$$/ns/mnt \
              env PATH="$PATH" \
              sh -c 'cd "$1" && shift && exec "$@"' -- "$(pwd)" \
              "$@"
            exit $?
          '';
        })
      ];
    })

    # Optionally set the Visual Studio Code package to an empty package.
    (mkIf cfg.onlyConfigure {
      programs.vscode.package = lib.mkForce (
        pkgs.stdenv.mkDerivation {
          pname = "vscode";
          name = "vscode";
          version = "1.74.0"; # must be at least 1.74.0 for extensions.json to be generated
          unpackPhase = ":";
          buildPhase = ''
            mkdir $out
          '';
        }
      );
    })

  ]);
}
