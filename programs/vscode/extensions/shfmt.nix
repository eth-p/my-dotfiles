# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# Extension: https://marketplace.visualstudio.com/items?itemName=mkhl.shfmt
# ==============================================================================
{ pkgs, lib, ... }:
pkgs.vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "shfmt";
    publisher = "mkhl";
    version = "1.3.1";
    hash = "sha256-V7pXPwabmUJLC/T0X4dsc52IZa7SaN70zd4mCjqk4X4=";
  };
  meta = {
    description = "Extension uses shfmt to provide a formatter for shell script documents";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=mkhl.shfmt";
    homepage = "https://codeberg.org/mkhl/vscode-shfmt";
    license = lib.licenses.bsd0;
    maintainers = [ ];
  };
}
