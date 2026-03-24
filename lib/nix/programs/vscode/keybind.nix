# my-dotfiles | Copyright (C) 2025-2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
#
# Library functions specific to Visual Studio Code configuration.
# ==============================================================================
{
  lib,
  ...
}:
let
  inherit (lib) isList;
in
rec {
  # type is the option type for a configurable keybinding in Visual Studio Code.
  # This abstracts over the keyboard shortcut JSON.
  type = lib.types.submodule {
    options = {
      key = lib.mkOption {
        description = "The key sequence to activate the shortcut";
        type = lib.types.str;
      };

      command = lib.mkOption {
        description = "The command to run when activated";
        type = lib.types.str;
      };

      args = lib.mkOption {
        description = "Arguments passed to the command";
        type = lib.types.nullOr lib.types.anything;
        default = null;
      };

      when = lib.mkOption {
        description = "Conditions for when the shortcut can be activated";
        type = lib.types.nullOr lib.types.str;
        default = null;
      };

      name = lib.mkOption {
        description = "Name for the binding (help menu only)";
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
    };
  };

  # splitChord splits a key string into its chord sequence.
  #
  # splitChord :: str -> [str]
  # splitChord :: [str] -> [str]
  splitChord = keys: if isList keys then keys else lib.strings.splitString " " keys;

  # joinChord un-splits a chord sequence into a key string.
  #
  # joinChord :: str -> str
  # joinChord :: [str] -> str
  joinChord = keys: if isList keys then lib.strings.join " " keys else keys;

  # isChord returns true if a key string is a chord.
  #
  # isChord :: str -> bool
  # isChord :: [str] -> bool
  isChord = keys: (builtins.length (splitChord keys)) > 1;

  # getChordLeader returns the leading key of the chord or null if not a chord.
  #
  # getChordLeader :: str -> (str|null)
  # getChordLeader :: [str] -> (str|null)
  getChordLeader =
    keys:
    let
      chord = splitChord keys;
    in
    if isChord chord then builtins.elemAt chord 0 else null;

  # dropChordLeader removes the leading key of the chord, failing if it
  # isn't a chord.
  #
  # dropChordLeader :: str -> str
  # dropChordLeader :: [str] -> [str]
  dropChordLeader =
    keys:
    if !(isChord keys) then
      abort "${keys} is not a key chord"
    else if isList keys then
      lib.lists.drop 1 keys
    else
      joinChord (dropChordLeader (splitChord keys));

  # generateVsCodeKeybinding generates a keyboard shortcut JSON entry from
  # the `keybind` type in this file.
  #
  # generateVsCodeKeybinding :: keybind -> attrs
  generateVsCodeKeybinding =
    binding:
    {
      key = binding.key;
      command = binding.command;
    }
    // (lib.optionalAttrs (binding.args != null) { args = binding.args; })
    // (lib.optionalAttrs (binding.when != null) { when = binding.when; });

  # generateVsCodeKeybindings generates a list of keyboard shortcuts JSON
  # entries from a list of keybinds.
  #
  # generateVsCodeKeybindings :: [keybind] -> attrs
  generateVsCodeKeybindings = map generateVsCodeKeybinding;

  # generateVsCodeKeybindings generates which-key bindings from a list of
  # `keybind`s.
  #
  # generateVsCodeKeybindings :: [keybind] -> attrs
  generateWhichKeyBindings =
    bindings:
    let
      bindingsWithKeyList = map (kb: kb // { key = splitChord kb.key; }) bindings;
      bindingTree = _generateWhichKeyBindingsTree { } bindingsWithKeyList;
    in
    bindingTree;

  # vsCodeKeyToWhichKey converts a VS Code key name into a which-key compatible
  # key symbol.
  vsCodeKeyToWhichKey =
    key:
    let
      convertModifier =
        k:
        let
          shiftTrimmed = lib.strings.removePrefix "shift+" k;
        in
        if k != shiftTrimmed then lib.strings.toUpper shiftTrimmed else k;

      special = {
        "tab" = "\t";
        "shift+tab" = "S-\t";
        "up" = "⭡";
        "down" = "⭣";
        "left" = "⭠";
        "right" = "⭢";
      };
    in
    special."${key}" or (convertModifier key);

  _generateWhichKeyBindingsTree =
    { }@params:
    kbs:
    let
      chords = lib.lists.filter (kb: isChord kb.key) kbs;
      binds = lib.lists.filter (kb: !(isChord kb.key)) kbs;

      leaderMap = lib.lists.groupBy (kb: getChordLeader kb.key) chords;
      leaderToMenu = (
        leader: subBindings: {
          key = vsCodeKeyToWhichKey leader;
          name = "...";
          type = "bindings";
          bindings = _generateWhichKeyBindingsTree params (
            map (kb: kb // { key = dropChordLeader kb.key; }) subBindings
          );
        }
      );
    in
    (_generateWhichKeyBindingConditionals params binds)
    ++ (lib.attrsets.mapAttrsToList leaderToMenu leaderMap);

  _generateWhichKeyBindingConditionals =
    { }@params:
    kbs:
    let
      keysMap = lib.lists.groupBy (kb: joinChord kb.key) kbs;
      wrapConditionals = key: bindings: {
        key = vsCodeKeyToWhichKey (joinChord key);
        name = "...";
        type = "conditional";
        bindings = map (
          kb:
          (_generateWhichKeyBindingItem kb)
          // {
            key = "when:${kb.when}";
          }
        ) bindings;
      };
    in
    lib.attrsets.mapAttrsToList (
      key: bindings:
      if (builtins.length bindings) < 2 then
        # Not conditional, use directly.
        _generateWhichKeyBindingItem (lib.lists.elemAt bindings 0)
      else
        # Conditional, wrap in group.
        wrapConditionals key bindings
    ) keysMap;

  _generateWhichKeyBindingItem =
    binding:
    let
      key = joinChord binding.key;
    in
    {
      name = if (binding.name or null) == null then binding.command else binding.name;
      key = vsCodeKeyToWhichKey key;
      command = binding.command;
    }
    // (lib.optionalAttrs (binding.args != null) { args = binding.args; });

}
