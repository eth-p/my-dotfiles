# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# This provides a consistent environment for running development scripts.
# ==============================================================================
{ pkgs, lib, config, inputs, ... }:
{
  packages = [
    pkgs.git
  ];

  # https://devenv.sh/tasks/
  tasks = {
    "my-dotfiles:format-nix" = {
      exec = ''
        '${pkgs.fd}/bin/fd' --glob '**/*.nix' \
          --exec-batch '${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt' '{}'
      '';
    };

    "my-dotfiles:format-sh" = {
      exec = ''
        declare -a scripts
        readarray -t scripts < <({
          '${pkgs.fd}/bin/fd' --glob '*' --type=executable scripts/
          '${pkgs.fd}/bin/fd' --glob '*.sh' --hidden lib/bash/
        })

        '${pkgs.shfmt}/bin/shfmt' --write \
          --language-dialect bash \
          --indent 0 \
          --space-redirects \
          "''${scripts[@]}"
      '';
    };

    "my-dotfiles:format-lua" = {
      exec = ''
        '${pkgs.stylua}/bin/stylua' programs/neovim
      '';
    };

    "my-dotfiles:format-json" = {
      exec = ''
        '${pkgs.fd}/bin/fd' --glob '**/*.json' programs \
          --exec-batch '${pkgs.nodePackages.prettier}/bin/prettier' '--write' '{}'
      '';
    };

    "my-dotfiles:format-yaml" = {
      exec = ''
        '${pkgs.fd}/bin/fd'  --glob '**/*.{yml,yaml}' programs \
          --exec-batch '${pkgs.nodePackages.prettier}/bin/prettier' '--write' '{}'
      '';
    };

    "my-dotfiles:format" = {
      exec = "true";
      after = [
        "my-dotfiles:format-json"
        "my-dotfiles:format-yaml"
        "my-dotfiles:format-lua"
        "my-dotfiles:format-nix"
        "my-dotfiles:format-sh"
      ];
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
