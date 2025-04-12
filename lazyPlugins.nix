{ pkgs, neovimPlugins }:

let
  pkgsPlugins = with pkgs.vimPlugins;
  [
    yazi-nvim
    conform-nvim
  ];
in
pkgsPlugins
