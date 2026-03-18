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

# ./scripts/fetch-src-hash "https://ms-python.gallery.vsassets.io/_apis/public/gallery/publisher/ms-python/extension/vscode-python-envs/1.22.0/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage?targetPlatform=darwin-arm64"
let
  supported = {
    "x86_64-linux" = {
      arch = "linux-x64";
      hash = "sha256-Y2gBJw+qDR3wz2su963yqyEcDuUSvVg4tMvcGI6HBKo=";
    };
    "aarch64-linux" = {
      arch = "linux-arm64";
      hash = "sha256-RdYKGccXPPXnZNsA698Y6XSBDDN1VadpcYvuGF/ce80=";
    };
    "aarch64-darwin" = {
      arch = "darwin-arm64";
      hash = "sha256-CXZiVy+VEUXt76zAHnVo3iF54rF/TswDZ69s3FIYkgY=";
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
    version = "1.22.0";
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
