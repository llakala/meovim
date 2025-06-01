{ pkgs }:
let
  packages = with pkgs;
  [
    # Language servers
    nixd
    jdt-language-server
    lua-language-server
    fish-lsp
    gleam
    typescript-language-server
    marksman

    # Formatters
    google-java-format
    stylua

    # Plugin dependencies
    texliveFull
    yazi
  ];

in packages
