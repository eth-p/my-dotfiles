# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# Program: https://github.com/JanDeDobbeleer/oh-my-posh
# This overrides oh-my-posh to use the official binary release.
# Reason for doing this is because it's updated frequently compared to nixpkgs.
# ==============================================================================
final: prev:
let
  inherit (prev) lib system stdenv;
  pkgs = prev;
  version = "v26.19.1";
  downloads = {
    "x86_64-linux" = {
      url = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/${version}/posh-linux-amd64";
      hash = "sha256-iMCWjA1MiqtQ8MFCQr/pVgvv0QtFl6gYsS2PiYhqqp4=";
    };
    "aarch64-linux" = {
      url = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/${version}/posh-linux-arm64";
      hash = "sha256-MyL+xhnIZR1E9sAS5DxfKJ9lvJVwToQS1CdZST5g+po=";
    };
    "x86_64-darwin" = {
      url = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/${version}/posh-darwin-amd64";
      hash = "sha256-EoRJ3VfY4ThsIU55iwjPoY+oXsKmxUEI5BHZBfqojRU=";
    };
    "aarch64-darwin" = {
      url = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/${version}/posh-darwin-arm64";
      hash = "sha256-vmT32mM1zHJvVnWI1e/Sl7Z9qAguNU/8n2vuDMceaJ0=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "oh-my-posh";
  inherit version;

  src = pkgs.fetchurl downloads."${system}";

  dontConfigure = true;
  dontBuild = true;
  dontUnpack = true;

  nativeBuildInputs =
    if stdenv.isLinux
    then [ pkgs.autoPatchelfHook ]
    else [ ];

  installPhase = ''
    ls -la
    runHook preInstall
    install -m755 -D $src $out/bin/oh-my-posh
    runHook postInstall
  '';

  meta = {
    description = "Prompt theme engine for any shell";
    mainProgram = "oh-my-posh";
    homepage = "https://ohmyposh.dev";
    changelog = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/tag/v${version}";
    license = lib.licenses.mit;
  };
}
