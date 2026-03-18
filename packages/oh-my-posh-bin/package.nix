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
  version = "29.9.0";
  downloads = {
    "x86_64-linux" = {
      url = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v${version}/posh-linux-amd64";
      hash = "sha256-g37ZDo4AZYPepMBlZ0qcQrC9Bu5/qGniUZCUFIuKuSc=";
    };
    "aarch64-linux" = {
      url = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v${version}/posh-linux-arm64";
      hash = "sha256-DW4kzFHTrKPar3bjkN9adcjHjoee6845FoNqoFFJqMs=";
    };
    "x86_64-darwin" = {
      url = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v${version}/posh-darwin-amd64";
      hash = "sha256-PY49XX0WaQy9tgn9M0MFxt+YWzSXxzGHm2HcL06mWAg=";
    };
    "aarch64-darwin" = {
      url = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v${version}/posh-darwin-arm64";
      hash = "sha256-21Hjr3kDQvHnZyLFQdLzn8zOi8jOBQVIsY1aWLbLkKc=";
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

  nativeBuildInputs = if stdenv.isLinux then [ autoPatchelfHook ] else [ ];

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
