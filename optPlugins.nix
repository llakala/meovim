{ pkgs, neovimPlugins }:

let
  pkgsPlugins = with pkgs.vimPlugins;
  [
    vimtex
    render-markdown-nvim
    mini-ai
  ];
in
pkgsPlugins
