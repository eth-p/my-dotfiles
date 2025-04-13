# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Helpers for performing common operations.
# ==============================================================================
{ lib, ... }:
rec {

  # filterAttrsByName filters an attrset, keeping only attributes with names
  # that the filter function returns `true` for.
  #
  # filterAttrsByName :: (string -> bool) attrs -> attrs
  filterAttrsByName = f: attrs:
    builtins.listToAttrs
      (map
        (name: {
          name = name;
          value = attrs.${name};
        })
        (builtins.filter f (builtins.attrNames attrs))
      );

  # mergeAttrsList merges a list of attrsets into a single attribute, with
  # attributes being specified earlier taking precedence over those specified
  # later.
  #
  # mergeAttrList :: [attrset] -> attrset
  mergeAttrsList = attrlist: builtins.foldl' (x: y: x // y) { } attrlist;

  # getOrDefault gets an attribute from an attrset if it exists or returns
  # the default value if it does not.
  #
  # getOrDefault :: attrset string any -> any
  getOrDefault = attrs: name: default:
    if attrs ? ${name}
    then attrs.${name}
    else default;

  # mergeSystemKeyedExports merges one or more attribute sets containing
  # system names and exported values (e.g. packages, devShells) for each
  # system. This will skip any named "default".
  #
  # mergeSystemKeyedExports :: [string] [attrset] -> attrset
  mergeSystemKeyedExports = systems: list: builtins.listToAttrs (
    map
      (sys:
        let
          exports = (map (l: getOrDefault l sys { }) list);
          removeDefaultAttr = filterAttrsByName (n: n != "default");
        in
        {
          name = sys;
          value = mergeAttrsList (map removeDefaultAttr exports);
        }
      )
      systems
  );

}
