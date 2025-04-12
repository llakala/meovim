{ pkgs, neovimPlugins }:

let
  pkgsPlugins = with pkgs.vimPlugins;
  [
    yazi-nvim
  ];
in
pkgsPlugins
