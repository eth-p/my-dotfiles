# my-dotfiles | Copyright (C) 2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# Extension: https://marketplace.visualstudio.com/items?itemName=jimeh.actionlint
# ==============================================================================
{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "actionlint";
    publisher = "jimeh";
    version = "0.1.3";
    hash = "sha256-L2fMtg58uPM3sTAF/f/7d7FogWuqZKX1qiB2BUrO5EI=";
  };
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/jimeh.actionlint/changelog";
    description = "Lint GitHub Actions workflow files using actionlint";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=jimeh.actionlint";
    homepage = "https://github.com/jimeh/vscode-actionlint";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
