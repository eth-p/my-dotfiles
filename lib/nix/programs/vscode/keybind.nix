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
    };
  };

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
}
