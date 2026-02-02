# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# This provides a consistent environment for running development scripts.
# ==============================================================================
{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  options.fast = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };

  config = lib.mkMerge [
    {
      packages = [
        pkgs.git

        # Package update scripts
        pkgs.nix-update
        pkgs.yq-go
        pkgs.gawk
        pkgs.gnused
        pkgs.github-cli
        pkgs.bash

        # Formatters
        pkgs.treefmt
        pkgs.nodePackages.prettier
        pkgs.shfmt
        pkgs.nixfmt-rfc-style
        pkgs.stylua
      ];

      # https://devenv.sh/tasks/
      tasks = {
        "my-dotfiles:format" = {
          exec = "treefmt";
        };
      };
    }

    # Configuration applied when not using direnv.
    (lib.mkIf (!config.fast) (
      let
        system = pkgs.stdenv.system;
      in
      {
        packages = [
          inputs.nix-options-doc.packages.${system}.default
        ];

        # https://devenv.sh/tasks/
        tasks = {
          "my-dotfiles:docs" = {
            before = [ "my-dotfiles:format" ];
            exec = ''
              nix-options-doc \
                --path "." \
                --out OPTIONS.md \
                --exclude-dir "lib" \
                --exclude-dir "profiles" \
                --filter-by-prefix "options.my-dotfiles" \
                --strip-prefix "options." \
                --sort
            '';
          };
        };
      }
    ))
  ];
}
