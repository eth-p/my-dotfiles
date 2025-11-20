# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Helpers to convert various Nix values into Go template equivalents.
# ==============================================================================
{ lib, ... }:
with lib.strings;
let

  # string converts a string into its GoTemplate equivalent.
  string = builtins.toJSON;

  # bool converts a boolean into its GoTemplate equivalent.
  bool = v: if v == true then "true" else "false";

  # int converts an int into its GoTemplate equivalent.
  int = builtins.toString;

  # nul converts a null value into its GoTemplate equivalent.
  nul = v: "nil";

  # attrs converts an attribute set into its GoTemplate equivalent.
  attrs =
    v:
    if builtins.length (builtins.attrNames v) == 0 then
      "(dict)"
    else
      "(dict\n${_indentLines (_concatItems (_mapAttrsToList _namedValueToGoTemplate v))}\n)";

  # list converts a list into its GoTemplate equivalent.
  list =
    v:
    if builtins.length v == 0 then
      "(list)"
    else
      "(list\n${_indentLines (_concatItems (builtins.map _valueToGoTemplate v))}\n)";

  # _mapAttrsToList :: (f string string -> string) attrs -> list
  _mapAttrsToList = f: set: (builtins.map (k: f k (builtins.getAttr k set)) (builtins.attrNames set));

  # _namedValueToGoTemplate :: string any -> string
  _namedValueToGoTemplate = name: value: "${string name} ${_valueToGoTemplate value}";

  # _namedValueToGoTemplate :: any -> string
  _valueToGoTemplate = value: _fns_typeToGoTemplate."${builtins.typeOf value}" value;

  _concatItems = items: concatStringsSep "\n" items;
  _indentLines = str: "  " + (concatStringsSep "\n  " (splitString "\n" str));

  _fns_typeToGoTemplate = {
    bool = bool;
    int = int;
    string = string;
    list = list;
    set = attrs;
    null = nul;
  };

in
{
  inherit string;
  inherit bool;
  inherit int;
  inherit list;
  inherit attrs;
}
