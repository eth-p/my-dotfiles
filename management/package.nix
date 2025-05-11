# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Nix function to link the my-dotfiles script in this repo to somewhere in the
# PATH.
# ==============================================================================
{ pkgs, bootstrap }: pkgs.writeShellApplication {
  name = "my-dotfiles";
  runtimeInputs = [ pkgs.bash ];
  text = ''
    #shellcheck disable=SC1091
    source '${
      builtins.replaceStrings
        [ "'" ]
        [ "'\"'\"'" ]
        (bootstrap.repoDirectory + "/management/bin/my-dotfiles")
    }'
  '';
}
