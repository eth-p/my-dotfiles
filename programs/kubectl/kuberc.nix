# my-dotfiles | Copyright (C) 2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://kubernetes.io/docs/reference/kubectl/
# ==============================================================================
{
  lib,
}:
{

  # Submodule types based on:
  # https://kubernetes.io/docs/reference/config-api/kuberc.v1beta1/
  types = {

    aliasOverride = lib.types.submodule {
      options = {
        command = lib.mkOption {
          type = lib.types.str;
          description = "name of the alias; can only include alphabetical characters, built-in commands take priorirty over user-defined ones";
        };

        description = lib.mkOption {
          # Not part of the kuberc spec; used to generate carapace overlays.
          type = lib.types.str;
          default = "";
          description = "description of the alias (carapace only)";
        };

        options = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          description = "default options (in long form, without dashes) for the command when invoked via this alias";
        };

        prependArgs = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "arguments inserted after the alias name";
        };

        appendArgs = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "arguments inserted after the cli-provided args";
        };
      };
    };

    commandDefaults = lib.types.submodule {
      options = {
        command = lib.mkOption {
          type = lib.types.str;
          description = "the command whose option's default value is changed";
        };

        options = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          description = "default options (in long form, without dashes) for the command when invoked via this alias";
        };
      };
    };
  };

  # Generates a nix attrset for the final kuberc file.
  # This must be converted to YAML when written to disk.
  #
  # generate :: { aliases, defaults } -> attrset
  generate =
    let

      # Converts the attrset-based option configuration to the list-based
      # format expected by kubectl.
      #
      # Example input (as YAML):
      #    server-side: "true"
      #
      # Example output (as YAML):
      #    - name: server-side
      #      default: "true"
      #
      # For use via `lib.attrsets.mapAttrsToList`.
      canonicalizeOption = name: value: {
        inherit name;
        default = value;
      };

      # Converts the attrset-based alias configuration to the list-based
      # format expected by kubectl.
      #
      # Example input (as YAML):
      #    gety:
      #      command: get
      #      options:
      #        output:
      #          default: "yaml"
      #
      # Example output (as YAML):
      #    - name: gety
      #      command: get
      #      options:
      #        - name: output
      #          default: "yaml"
      #
      # For use via `lib.attrsets.mapAttrsToList`.
      canonicalizeAlias =
        name: alias:
        {
          inherit name;
          inherit (alias) command;
        }
        // (lib.optionalAttrs (alias.prependArgs != [ ]) {
          inherit (alias) prependArgs;
        })
        // (lib.optionalAttrs (alias.appendArgs != [ ]) {
          inherit (alias) appendArgs;
        })
        // (lib.optionalAttrs (alias.options != { }) {
          options = lib.attrsets.mapAttrsToList canonicalizeOption alias.options;
        });

      # Converts the attrset-based defaults configuration to the list-based
      # format expected by kubectl.
      #
      # Example input (as YAML):
      #    apply:
      #      options:
      #        server-side:
      #          default: "true"
      #
      # Example output (as YAML):
      #    - command: apply
      #      options:
      #        - name: server-side
      #          default: "true"
      #
      # For use via `lib.attrsets.mapAttrsToList`.
      canonicalizeDefaults =
        name: defs:
        {
          command = name;
        }
        // (lib.optionalAttrs (defs.options != { }) {
          options = lib.attrsets.mapAttrsToList canonicalizeOption defs.options;
        });

    in
    {
      aliases,
      defaults,
    }:
    {
      apiVersion = "kubectl.config.k8s.io/v1beta1";
      kind = "Preference";
    }
    // (lib.optionalAttrs (aliases != { }) {
      aliases = lib.attrsets.mapAttrsToList canonicalizeAlias aliases;
    })
    // (lib.optionalAttrs (defaults != { }) {
      defaults = lib.attrsets.mapAttrsToList canonicalizeDefaults defaults;
    });

}
