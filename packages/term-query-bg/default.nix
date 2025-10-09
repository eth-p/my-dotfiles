# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Nix function to generate the package for my term-query-bg script.
# ==============================================================================
{ pkgs, system, ... }: pkgs.writeShellApplication {
  name = "term-query-bg";

  runtimeInputs = [ pkgs.bash ];

  excludeShellChecks = [
    "SC2329" # Unused function
  ];

  text = (builtins.readFile ./bin/term-query-bg.sh);
}
