# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Helpers for resolving credentials at runtime.
# ==============================================================================
{ lib, ... }:
rec {

  # type is the option type for a runtime credentials provider.
  type = lib.mkOptionType {
    name = "runtime credentials provider";
    check = isCreds;
  };

  # isCreds checks if the value is a runtime credentials provider.
  #
  # isCreds :: creds -> bool
  isCreds = v: v._type == "my-dotfiles.creds";

  # fromOnePassword creates a runtime credentials provider that pulls
  # credentials from a 1Password vault.
  fromOnePassword =
    {
      vault,
      item,
      username-field ? null,
      password-field,
    }:
    rec {
      _type = "my-dotfiles.creds";
      inherit
        vault
        item
        username-field
        password-field
        ;
      mkFetcher =
        pkgs:
        (
          pkgs.writeShellApplication {
            name = "credentials-from-onepassword";

            runtimeInputs = [
              pkgs._1password-cli
            ];

            text = ''
              case "$1" in
              username)
                op read ${pkgs.lib.escapeShellArg "op://${vault}/${item}/${username-field}"}
                ;;
              password)
                op read ${pkgs.lib.escapeShellArg "op://${vault}/${item}/${password-field}"}
                ;;
              *)
                exit 1
                ;;
              esac
            '';
          }
          + "/bin/credentials-from-onepassword"
        );
    };

}
