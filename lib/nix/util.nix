# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Helpers for performing common operations.
# ==============================================================================
{ lib, ... }:
rec {

  # fileIsRegularWithSuffix takes a string suffix, generating a function which
  # checks if the first parameter is "regular" and the second parameter
  # has the specified suffix.
  #
  # Usage:
  #   lib.attrsets.filterAttrs
  #     (fileIsRegularWithSuffix ".nix")
  #     (builtins.readDir ./dir)
  #
  # mergeSystemKeyedExports :: string -> (string string -> bool)
  fileIsRegularWithSuffix =
    suffix: name: kind:
    kind == "regular" && (lib.strings.hasSuffix suffix name);

}
