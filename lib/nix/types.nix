# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Custom module option types.
# ==============================================================================
{ lib, my-dotfiles, ... }:
{

  # functionListTo is an option type that takes option values in the form of
  # `(? -> T)` and creates a list out of them.
  functionListTo =
    t:
    lib.mkOptionType {
      name = "list of functions returning ${t.name}";
      check = f: lib.isFunction f;
      merge = loc: defs: map (def: def.value) defs;
    };

  # creds is an option type for a runtime credentials provider.
  # See `creds.nix` for more details.
  creds = my-dotfiles.lib.creds.type;

}
