# my-dotfiles | Copyright (C) 2025 eth-p
# Repository: https://github.com/eth-p/my-dotfiles
#
# This references all the packages under this directory,
# calling a generator function for each target system.
# ==============================================================================
{ systems }:
{
  term-query-bg =
    let
      gen = import ./term-query-bg;
    in
    {
      aarch64-darwin = gen systems.inputs.aarch64-darwin;
      x86_64-darwin = gen systems.inputs.x86_64-darwin;
      aarch64-linux = gen systems.inputs.aarch64-linux;
      x86_64-linux = gen systems.inputs.x86_64-linux;
    };
}
