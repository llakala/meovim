{ pkgs, neovimPlugins }:

let
  pkgsPlugins = with pkgs.vimPlugins;
  [
    vim-textobj-user
  ];
in
pkgsPlugins
