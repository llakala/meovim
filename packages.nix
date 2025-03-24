{ pkgs }:
let
  packages = with pkgs;
  [
    nixd
    jdt-language-server
    yazi
    lua-language-server
    gleam
    fish-lsp
    google-java-format
  ];

in packages
