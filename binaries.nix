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
    tex-fmt # Couldn't get latexindent working

    # Plugin dependencies
    texliveFull
    yazi
  ];

in packages
