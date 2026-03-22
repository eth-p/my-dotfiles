# my-dotfiles | Copyright (C) 2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
#
# Includes each per-language subdirectory as a module.
# ==============================================================================
{
  ...
}:
{
  imports = [
    ./bash
    ./go
    ./makefile
    ./markdown
    ./nix
    ./python
    ./rust
    ./toml
    ./yaml
  ];
}
