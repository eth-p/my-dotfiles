# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/fish-shell/fish-shell
# ==============================================================================
{ lib, ... }: rec {
  privateIdentPrefix = "__mydotfiles";

  # privateIdent converts a public identifier to a private identifier.
  # This should be used to reference a function created with
  # `mkPrivateFishFunction`.
  #
  # privateIdent :: string -> string
  privateIdent = name: "${privateIdentPrefix}_${name}";

  # mkPrivateFishFunction generates a home-manager file for a lazy-loading
  # fish function.
  #
  # As a private function, its name will be prefixed. The fish function can
  # be referenced through the `privateIdent` Nix function.
  #
  # mkPrivateFishFunction :: string (attrset -> string) attrset -> attrset
  mkPrivateFishFunction = name: gen: template_vars: {
    name = "fish/functions/${privateIdent name}.fish";
    value = {
      text = gen ({
        inherit privateIdent;
        name = privateIdent name;
      } // template_vars);
    };
  };

  # mkFishFunction generates a home-manager file for a lazy-loading
  # fish function.
  #
  # mkFishFunction :: string (attrset -> string) attrset -> attrset
  mkFishFunction = name: gen: template_vars: {
    name = "fish/functions/${name}.fish";
    value = {
      text = gen ({ inherit privateIdent name; } // template_vars);
    };
  };
}
