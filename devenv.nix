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
  packages = [
    pkgs.git

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

    "my-dotfiles:docs" = {
      exec = ''
        nix run github:Thunderbottom/nix-options-doc?rev=2caa4b5756a8666d65d70122f413e295f56886e7 -- \
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
