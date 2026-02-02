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
    name = "actions-shell-scripts";
    publisher = "marcovr";
    version = "1.0.1";
    hash = "sha256-LfXh6W2x2PMACMoIV3SRRFaVPPwxd1mtdUOqi92QP0E=";
  };
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/marcovr.actions-shell-scripts/changelog";
    description = "Highlight issues with ShellCheck diagnostics, run scripts directly from the editor, and streamline your CI pipeline development.";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=marcovr.actions-shell-scripts";
    homepage = "https://github.com/marcovr/actions-shell-scripts";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
