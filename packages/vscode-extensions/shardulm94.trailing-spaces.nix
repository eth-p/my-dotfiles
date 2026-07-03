# my-dotfiles | Copyright (C) 2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# Extension: https://marketplace.visualstudio.com/items?itemName=shardulm94.trailing-spaces
# ==============================================================================
{
  lib,
  vscode-utils,
}:
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "trailing-spaces";
    publisher = "shardulm94";
    version = "0.4.4";
    hash = "sha256-L2WM021Jyyovy8KElkIspXc0MdHC9APsbPdX5hK4CIM=";
  };
  meta = {
    changelog = "https://marketplace.visualstudio.com/items/shardulm94.trailing-spaces/changelog";
    description = "Lint GitHub Actions workflow files using actionlint";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=shardulm94.trailing-spaces";
    homepage = "https://github.com/shardulm94/vscode-trailingspaces";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
