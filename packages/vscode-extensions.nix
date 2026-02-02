# my-dotfiles | Copyright (C) 2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# This references all the Visual Studio Code under ./vscode-extensions.
# ==============================================================================
{
  pkgs,
  my-dotfiles,
}:
let
  inherit (pkgs.lib.attrsets) filterAttrs mapAttrs;
  inherit (pkgs.lib.lists) groupBy;
  inherit (my-dotfiles.lib.util) fileIsRegularWithSuffix;

  allFiles = builtins.readDir ./vscode-extensions;
  packageFiles = builtins.attrNames (filterAttrs (fileIsRegularWithSuffix ".nix") allFiles);
  packageDerivations = map (f: pkgs.callPackage (./vscode-extensions + "/${f}") { }) packageFiles;
  derivationsByPublisher = groupByExtensionPublisher packageDerivations;
  vscodeExtensions = mapAttrs (publisher: genAttrsByExtensionName) derivationsByPublisher;

  # groupByExtensionPublisher groups a list of extensions by their publishers.
  #
  # groupByExtensionPublisher :: [derivation] -> {string: [derivation]}
  groupByExtensionPublisher = groupBy (d: d.vscodeExtPublisher);

  # genAttrsByExtensionName generates an attrset from a list of extensions,
  # using the extension name as the attribute name.
  #
  # genAttrsByExtensionName :: [derivation] -> {string: derivation}
  genAttrsByExtensionName =
    ds:
    builtins.listToAttrs (
      map (d: {
        name = d.vscodeExtName;
        value = d;
      }) ds
    );

in
pkgs.lib.recurseIntoAttrs vscodeExtensions
