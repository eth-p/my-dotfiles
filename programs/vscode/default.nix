# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# ==============================================================================
{ lib, config, pkgs, pkgs-unstable, ... } @ inputs:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.vscode;
  extensions = pkgs-unstable.vscode-extensions;
in
{
  imports = [
    ./language-bash.nix
    ./language-go.nix
    ./language-makefile.nix
    ./language-markdown.nix
    ./language-nix.nix
  ];

  options.my-dotfiles.vscode = {
    enable = lib.mkEnableOption "install and configure Visual Studio Code";
    editorconfig = lib.mkEnableOption "install the EditorConfig extension" // { default = true; };
  };

  config = mkIf cfg.enable (mkMerge [

    # Install Visual Studio Code.
    {
      programs.vscode = {
        enable = true;
        mutableExtensionsDir = false;
        profiles.default = {
          enableUpdateCheck = false;
          enableExtensionUpdateCheck = false;
        };
      };

      nixpkgs.config.allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [ "vscode" ];
    }

    # Install EditorConfig extension.
    # https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig
    (mkIf cfg.editorconfig {
      programs.vscode.profiles.default.extensions = with extensions;
        [
          editorconfig.editorconfig
        ];
    })

    # Install Markdown Preview for Github Alerts
    # https://marketplace.visualstudio.com/items?itemName=yahyabatulu.vscode-markdown-alert
    {
      programs.vscode.profiles.default.extensions = [
        (import ./extensions/vscode-markdown-alert.nix inputs)
      ];
    }

    # Configure to use `fish` as the shell.
    (mkIf (config.my-dotfiles.fish.enable && config.my-dotfiles.fish.isSHELL) {
      programs.vscode.profiles.default.userSettings =
        let os = if pkgs.stdenv.isDarwin then "osx" else "linux";
        in {
          "terminal.integrated.defaultProfile.${os}" = "fish";
          "terminal.integrated.profiles.${os}" = {
            "fish" = {
              "path" = pkgs.fish + "/bin/fish";
              "icon" = "terminal-bash";
            };
          };
        };
    })

  ]);
}
