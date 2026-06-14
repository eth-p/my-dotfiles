# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# Extension: https://marketplace.visualstudio.com/items?itemName=marcovr.actions-shell-scripts
# ==============================================================================
{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "devenv";
    publisher = "datakurre";
    version = "0.6.0";
    hash = "sha256-GyDiPwC7WKxQNDfa96AW3RUKV9w0FsfAiuvxjr9B3UU=";
  };
  meta = {
    changelog = "https://github.com/datakurre/devenv-vscode/blob/main/CHANGELOG.md";
    description = "Declarative developer environments for Visual Studio Code";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=datakurre.devenv";
    homepage = "https://github.com/datakurre/devenv-vscode";
    license = lib.licenses.bsd0;
    maintainers = [ ];
  };
}
