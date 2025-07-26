{ pkgs, neovimPlugins }:

let
  pkgsPlugins = with pkgs.vimPlugins; [
    render-markdown-nvim
  ];
in pkgsPlugins
