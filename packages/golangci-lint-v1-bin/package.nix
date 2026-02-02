# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/golangci/golangci-lint
# This provides the binary release for the last v1 release of golangci-lint.
# ==============================================================================
{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:
let
  version = "1.64.8";
  downloads = {
    "x86_64-linux" = {
      url = "https://github.com/golangci/golangci-lint/releases/download/v${version}/golangci-lint-${version}-linux-amd64.tar.gz";
      hash = "sha256-ticGh6+xQ9AZ84fHkc0qbxyzg76bMSTSQcoRvTzi5U4=";
    };
    "aarch64-linux" = {
      url = "https://github.com/golangci/golangci-lint/releases/download/v${version}/golangci-lint-${version}-linux-arm64.tar.gz";
      hash = "sha256-pqtY68scSFcmIhRs2uwpVvVocQOKVO0RSfE4bih3iaU=";
    };
    "x86_64-darwin" = {
      url = "https://github.com/golangci/golangci-lint/releases/download/v${version}/golangci-lint-${version}-darwin-amd64.tar.gz";
      hash = "sha256-tSrruMtR4Av9WXYJkIP74sQ+9VbO+ch+WKiuZW50BEQ==";
    };
    "aarch64-darwin" = {
      url = "https://github.com/golangci/golangci-lint/releases/download/v${version}/golangci-lint-${version}-darwin-arm64.tar.gz";
      hash = "sha256-cFQ9IeWwKpQHm+iqESZ6WwYIZVg+M3/naNObXT4vrx8=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "golangci-lint-v1";
  inherit version;

  src = fetchurl downloads."${stdenv.hostPlatform.system}";

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = if stdenv.isLinux then [ autoPatchelfHook ] else [ ];

  installPhase = ''
    runHook preInstall
    tar --extract -z -f $src
    install -m755 -D ./golangci-lint $out/bin/golangci-lint-v1
    runHook postInstall
  '';

  meta = {
    description = "Fast linters Runner for Go";
    homepage = "https://golangci-lint.run/";
    changelog = "https://github.com/golangci/golangci-lint/blob/v${version}/CHANGELOG.md";
    mainProgram = "golangci-lint-v1";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
  };
}
