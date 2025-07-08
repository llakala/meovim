{ pkgs }:
let
  packages = with pkgs; [
    # Language servers
    nixd
    jdt-language-server
    lua-language-server
    fish-lsp
    typescript-language-server
    basedpyright
    ruff
    marksman

    # Formatters
    google-java-format
    stylua
    tex-fmt # Couldn't get latexindent working

    # Plugin dependencies
    # texliveBasic
    # texlivePackages.latexmk
    # texlivePackages.biber
    yazi
  ];

in packages
