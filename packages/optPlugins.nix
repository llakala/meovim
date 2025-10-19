{ pkgs }:

let
  pkgsPlugins = with pkgs.vimPlugins; [
  ];
in pkgsPlugins
