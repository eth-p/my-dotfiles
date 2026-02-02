# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# Extension: https://marketplace.visualstudio.com/items?itemName=yahyabatulu.vscode-markdown-alert
# ==============================================================================
{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "vscode-markdown-alert";
    publisher = "yahyabatulu";
    version = "0.0.4";
    hash = "sha256-dCaSMPSntYo0QLr2pcs9GfJxOshfyeXbs8IMCwd+lqw=";
  };
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/yahyabatulu.vscode-markdown-alert/changelog";
    description = "Add GitHub markdown alerts to the markdown preview";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=yahyabatulu.vscode-markdown-alert";
    homepage = "https://github.com/ByPikod/vscode-markdown-alert";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
