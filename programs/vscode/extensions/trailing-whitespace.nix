# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# Extension: https://marketplace.visualstudio.com/items?itemName=yahyabatulu.vscode-markdown-alert
# ==============================================================================
{ pkgs, lib, ... }:
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "tws";
    publisher = "jkiviluoto";
    version = "1.0.1";
    hash = "sha256-xRO5kjYH1nm3gweilbmcvrqa5kHl93/WF63ap1VERSo=";
  };
  meta = {
    changelog =
      "https://marketplace.visualstudio.com/items/jkiviluoto.tws/changelog";
    description = "Highlight and remove trailing whitespaces the right way!";
    downloadPage =
      "https://marketplace.visualstudio.com/items?itemName=jkiviluoto.tws";
    homepage = "https://github.com/jannek/tws";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
