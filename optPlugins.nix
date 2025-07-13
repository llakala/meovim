{ pkgs, neovimPlugins }:

let
  pkgsPlugins = with pkgs.vimPlugins; [
    render-markdown-nvim
    mini-ai
  ];
in pkgsPlugins
