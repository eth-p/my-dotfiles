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
  version = "v28.1.0";
  downloads = {
    "x86_64-linux" = {
      url = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/${version}/posh-linux-amd64";
      hash = "sha256-8Q6xlzSm+oW1nc3GLpXXjms67SEe92HCnJgpCkk97lM=";
    };
    "aarch64-linux" = {
      url = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/${version}/posh-linux-arm64";
      hash = "sha256-X7UoF0g7BCs7JCm6pYGnFUGstyARjIQq64B1lf0f9H8=";
    };
    "x86_64-darwin" = {
      url = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/${version}/posh-darwin-amd64";
      hash = "sha256-lkdAjpd71ic2dCEbjnIH0tX/MsAznDFXmaJH+Bnt+Eg=";
    };
    "aarch64-darwin" = {
      url = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/${version}/posh-darwin-arm64";
      hash = "sha256-nXmi8V3NNC9A/OyzLyCfByoyu3oYBz0lihEPCefdBDg=";
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

  nativeBuildInputs = if stdenv.isLinux then [ pkgs.autoPatchelfHook ] else [ ];

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
