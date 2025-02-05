{ ... }:
let

  # Converts a boolean into its Lua equivalent.
  bool = v: if v == true then "true" else "false";

in
{
  inherit bool;
}
