# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/JanDeDobbeleer/oh-my-posh
# This overrides oh-my-posh to use the official binary release.
# Reason for doing this is because it's updated frequently compared to nixpkgs.
# ==============================================================================
{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:
let
  version = "30.6.5";
  downloads = {
    "x86_64-linux" = {
      url = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v${version}/posh-linux-amd64";
      hash = "sha256-B5/r9okydEpsjQUXmieYvKCDYTJ17KbeQbHv6cguFcg=";
    };
    "aarch64-linux" = {
      url = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v${version}/posh-linux-arm64";
      hash = "sha256-NNgdKHHNKyEYeNPjG7fI18XnAIgXDuUmviIqLmuEPE0=";
    };
    "x86_64-darwin" = {
      url = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v${version}/posh-darwin-amd64";
      hash = "sha256-DRqNZ4SKI2jXlhdB/RSM938c1aNPl7UTDUVtw6R3J/k=";
    };
    "aarch64-darwin" = {
      url = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v${version}/posh-darwin-arm64";
      hash = "sha256-J7PU1DYy8zNHJmX4rkJg9mpYuNGv6nQYc+8ki2FSGGg=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "oh-my-posh";
  inherit version;

  src = fetchurl downloads."${stdenv.hostPlatform.system}";

  dontConfigure = true;
  dontBuild = true;
  dontUnpack = true;

  nativeBuildInputs = if stdenv.hostPlatform.isLinux then [ autoPatchelfHook ] else [ ];

  installPhase = ''
    ls -la
    runHook preInstall
    install -m755 -D $src $out/bin/oh-my-posh
    runHook postInstall
  '';

  passthru.updateInfo = {
    github = "JanDeDobbeleer/oh-my-posh";
  };

  meta = {
    description = "Prompt theme engine for any shell";
    mainProgram = "oh-my-posh";
    homepage = "https://ohmyposh.dev";
    changelog = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/tag/v${version}";
    license = lib.licenses.mit;
  };
}
