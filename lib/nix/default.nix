# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# This references all of my Nix library functions.
# ==============================================================================
{ ... }@inputs:
{
  generators = {
    inherit (import ./generators/gotemplate.nix inputs) toGoTemplate;
  };

  creds = (import ./creds.nix) inputs;
  tolua = (import ./tolua.nix) inputs;
  theming = (import ./theming.nix) inputs;
  text = (import ./text.nix) inputs;
  types = (import ./types.nix) inputs;
  util = (import ./util.nix) inputs;
  home = (import ./home.nix) inputs;
}
