# my-dotfiles | Copyright (C) 2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://kubernetes.io/docs/reference/kubectl/
# ==============================================================================
{
  lib,
  config,
  pkgs,
  my-dotfiles,
  ...
}@inputs:
let
  inherit (lib) mkIf mkMerge;
  cfg = config.my-dotfiles.kubectl;

  yamlFormat = pkgs.formats.yaml { };

  # Submodule types based on:
  # https://kubernetes.io/docs/reference/config-api/kuberc.v1beta1/

  kubercAliasOverride = lib.types.submodule {
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

  kubercCommandDefaults = lib.types.submodule {
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

in
{
  options.my-dotfiles.kubectl = {
    enable = lib.mkEnableOption "install kubectl";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.kubectl;
      description = "the kubectl package to install";
    };

    extraDefaults = lib.mkOption {
      type = lib.types.attrsOf kubercCommandDefaults;
      default = { };
      description = "extra default option overrides for specific kubectl subcommands";
      example = {
        apply = {
          options = {
            server-side = {
              default = "true";
            };
          };
        };
      };
    };

    extraAliases = lib.mkOption {
      type = lib.types.attrsOf kubercAliasOverride;
      default = { };
      description = "extra kubectl aliases to add to the kuberc file";
      example = {
        gety = {
          command = "get";
          options = {
            output = {
              default = "yaml";
            };
          };
        };
      };
    };
  };

  config =
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

      kubercContents =
        (lib.optionalAttrs (cfg.extraAliases != { }) {
          aliases = lib.attrsets.mapAttrsToList canonicalizeAlias cfg.extraAliases;
        })
        // (lib.optionalAttrs (cfg.extraDefaults != { }) {
          defaults = lib.attrsets.mapAttrsToList canonicalizeDefaults cfg.extraDefaults;
        });

      # ----------------------------------------------------------------------
      # Generate carapace overlay for improved auto-completion based on the
      # user-defined aliases.
      # ----------------------------------------------------------------------

      # Converts the attrset-based alias configuration into a carapace command
      # specification that bridges the alias to carapace's normal completer
      # for the underlying kubectl command.
      #
      # Example input (as YAML):
      #    get-ns:
      #      command: get
      #      description: "get a kubenetes namespace"
      #      prependArgs: [namespace]
      #
      # Example output (as YAML):
      #    name: get-ns
      #    description: "get a kubenetes namespace"
      #    completion:
      #      positionalany:
      #        - $carapace.bridge.CarapaceBin(["kubectl", "get", "namespace"])
      #
      # For use via `lib.attrsets.mapAttrsToList`.
      carapaceOverlayForAlias =
        name: alias:
        {
          inherit name;
          completion = {
            positionalany = [
              "$carapace.bridge.CarapaceBin(${
                lib.strings.toJSON ([ "kubectl" ] ++ alias.prependArgs ++ [ alias.command ])
              })"
            ];
          };
        }
        // (lib.optionalAttrs (alias.description != "") {
          inherit (alias) description;
        });

      carapaceOverlay = {
        name = "kubectl";
        commands = (lib.attrsets.mapAttrsToList carapaceOverlayForAlias cfg.extraAliases);
      };

    in
    mkIf cfg.enable (mkMerge [

      # Install and kubectl.
      {
        home.packages = [
          cfg.package
        ];
      }

      # Configure kubectl.
      (mkIf (kubercContents != { }) {
        home.file.".kube/kuberc".source = yamlFormat.generate "kubectl-kuberc" (
          {
            apiVersion = "kubectl.config.k8s.io/v1beta1";
            kind = "Preference";
          }
          // kubercContents
        );
      })

      # Add carapace overlay for custom aliases.
      (mkIf (config.programs.carapace.enable && cfg.extraAliases != { }) (
        let
          carapaceConfigDir =
            if pkgs.stdenvNoCC.targetPlatform.isDarwin then
              "Library/Application Support/carapace"
            else
              "${config.xdg.configHome}/.config/carapace";
        in
        {
          home.file."${carapaceConfigDir}/overlays/kubectl.yaml".source =
            yamlFormat.generate "kubectl-carapace-overlay" carapaceOverlay;
        }
      ))

    ]);
}
