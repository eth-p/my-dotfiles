# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# ==============================================================================
{
  lib,
  pkgs,
  ...
}@inputs:
let
  inherit (lib) mkIf mkMerge mkDefault;
  inherit (import ./lib.nix inputs) vscodeCfg;
  extensions = pkgs.vscode-extensions;
  cfg = vscodeCfg.language.rust;
in
{
  options.my-dotfiles.vscode.language.rust = {
    enable = lib.mkEnableOption "add Rust language support to Visual Studio Code";

    lsp = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "install the Rust language server, rust-analyzer";
      };

      package = lib.mkOption {
        default = pkgs.rust-analyzer;
        description = "the rust-analyzer package";
      };
    };
  };

  config = mkIf (vscodeCfg.enable && cfg.enable) (mkMerge [

    {
      programs.vscode = {
        # Install the rust-analyzer extension.
        # https://marketplace.visualstudio.com/items?itemName=rust-lang.rust-analyzer
        profiles.default.extensions = with extensions; [ rust-lang.rust-analyzer ];
      };

      # In the VS Code FHS, install dependencies for compiling Rust.
      my-dotfiles.vscode.dependencies.packages = (
        pkgs: with pkgs; [
          # Compilers
          rustc
          clang

          # Tools
          cargo
          rustfmt
        ]
      );

      # Enable TOML language support.
      my-dotfiles.vscode.language.toml.enable = mkDefault true;
    }

    # Install the Rust language server, rust-analyzer.
    (mkIf cfg.lsp.enable {
      programs.vscode = {
        profiles.default.userSettings = {
          "rust-analyzer.server.path" = cfg.lsp.package + "/bin/rust-analyzer";
        };
      };
    })

  ]);
}
