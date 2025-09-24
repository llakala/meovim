{ pkgs }:

let
  pkgsPlugins = with pkgs.vimPlugins; [
    render-markdown-nvim
  ];
in pkgsPlugins
