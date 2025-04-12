{ pkgs, neovimPlugins }:

let
  pkgsPlugins = with pkgs.vimPlugins;
  [
    yazi-nvim
    conform-nvim
    nvim-autopairs
  ];
in
pkgsPlugins
