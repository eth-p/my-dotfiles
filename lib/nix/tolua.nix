# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Helpers to convert various Nix values into Lua equivalents.
# ==============================================================================
{ lib, ... }:
with lib.strings;
let

  # string converts a string into its Lua equivalent.
  string = builtins.toJSON;

  # bool converts a boolean into its Lua equivalent.
  bool = v: if v == true then "true" else "false";

  # int converts an int into its Lua equivalent.
  int = builtins.toString;

  # nul converts a null value into its Lua equivalent.
  nul = v: "nil";

  # attrs converts an attribute set into its Lua equivalent.
  attrs = v:
    if builtins.length (builtins.attrNames v) == 0
    then "{}"
    else "{\n${_indentLines (_concatItems (_mapAttrsToList _namedValueToLua v))},\n}";

  # list converts a list into its Lua equivalent.
  list = v:
    if builtins.length v == 0
    then "{}"
    else "{\n${_indentLines (_concatItems (builtins.map _valueToLua v))},\n}";

  # _mapAttrsToList :: (f string string -> string) attrs -> list
  _mapAttrsToList = f: set:
    (builtins.map (k: f k (builtins.getAttr k set)) (builtins.attrNames set));

  # _namedValueToLua :: string any -> string
  _namedValueToLua = name: value: "${name} = ${_valueToLua value}";

  # _namedValueToLua :: any -> string
  _valueToLua = value: _fns_typeToLua."${builtins.typeOf value}" value;

  _concatItems = items: concatStringsSep ",\n" items;
  _indentLines = str: "  " + (concatStringsSep "\n  " (splitString "\n" str));

  _fns_typeToLua = {
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
