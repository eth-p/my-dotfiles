# my-dotfiles | Copyright (C) 2025-2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Generators to convert various Nix values into a Go text/template equivalent.
# If dicts and lists are passed, the template engine must be using sprig/sprout.
# ==============================================================================
{ lib, ... }:
let
  inherit (lib)
    concatStringsSep
    mapAttrsToList
    isString
    isBool
    isInt
    isFloat
    isList
    isAttrs
    ;
in
rec {
  toGoTemplate =
    {
      multiline ? true,
      indent ? "",
    }@args:
    v:
    let
      innerIndent = "${indent}  ";
      introSpace = if multiline then "\n${innerIndent}" else " ";
      outroSpace = if multiline then "\n${indent}" else " ";
      concatItems = concatStringsSep "${introSpace}";
      innerArgs = args // {
        indent = innerIndent;
      };
    in
    if isString v || isInt v || isFloat v || isBool v then
      builtins.toJSON v
    else if isList v then
      if v == [ ] then
        "(list)"
      else
        "(list${introSpace}${concatItems (map (value: toGoTemplate innerArgs value))}${outroSpace})"
    else if isAttrs v then
      if v == { } then
        "(dict)"
      else
        "(dict${introSpace}${
          concatItems (
            mapAttrsToList (key: value: "${builtins.toJSON key} ${toGoTemplate innerArgs value}") v
          )
        }${outroSpace})"

    else
      abort "generators.toGoTemplate: type ${builtins.typeOf v} is unsupported";

}
