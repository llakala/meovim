{ pkgs, neovimPlugins }:

let
  pkgsPlugins = with pkgs.vimPlugins;
  [
    which-key-nvim
  ];
in
pkgsPlugins
