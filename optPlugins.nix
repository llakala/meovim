{ pkgs, neovimPlugins }:

let
  pkgsPlugins = with pkgs.vimPlugins;
  [
    vimtex
    which-key-nvim
  ];
in
pkgsPlugins
