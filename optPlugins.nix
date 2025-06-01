{ pkgs, neovimPlugins }:

let
  pkgsPlugins = with pkgs.vimPlugins;
  [
    vimtex
  ];
in
pkgsPlugins
