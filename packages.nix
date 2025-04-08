{ pkgs }:
let
  packages = with pkgs;
  [
    nixd
    jdt-language-server
    yazi
    lua-language-server
    fish-lsp
    google-java-format
    stylua
    gleam
  ];

in packages
