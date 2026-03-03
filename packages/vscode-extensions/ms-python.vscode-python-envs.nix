# my-dotfiles | Copyright (C) 2026 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://code.visualstudio.com/
# Extension: https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-python-envs
# ==============================================================================
{
  lib,
  stdenv,
  vscode-utils,
}:

# "https://${publisher}.gallery.vsassets.io/_apis/public/gallery/publisher/${publisher}/extension/${name}/${version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage?targetPlatform=${arch}"
# ./scripts/fetch-src-hash "https://ms-python.gallery.vsassets.io/_apis/public/gallery/publisher/ms-python/extension/vscode-python-envs/1.20.1/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage?targetPlatform=darwin-arm64"
let
  supported = {
    "x86_64-linux" = {
      arch = "linux-x64";
      hash = "sha256-DN8xFxHPDtQSfS5LNYWebeT0B/4JE74Q+y3xt8zPEWM=";
    };
    "aarch64-linux" = {
      arch = "linux-arm64";
      hash = "sha256-JTKc2vYoXEqAvTTpUoUVaSn9RBbaYC3fnqlG7d8mOcw=";
    };
    "aarch64-darwin" = {
      arch = "darwin-arm64";
      hash = "sha256-Cy1GBU0U08anuRKCoPcYQYZJWyH2H+Bcn7hMxVzRfLM=";
    };
  };

  base =
    supported.${stdenv.hostPlatform.system}
      or (throw "unsupported platform ${stdenv.hostPlatform.system}");

in
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = base // {
    name = "vscode-python-envs";
    publisher = "ms-python";
    version = "1.20.1";
  };

  meta = {
    changelog = "https://marketplace.visualstudio.com/items/ms-python.vscode-python-envs/changelog";
    description = "Provides a unified python environment experience";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-python-envs";
    homepage = "https://github.com/microsoft/vscode-python-environments";
    license = lib.licenses.mit;
    platforms = builtins.attrNames supported;
    maintainers = [ ];
  };
}
