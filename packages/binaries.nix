{ pkgs }:

with pkgs; [
  # Language servers
  lua-language-server
  tinymist
  nil

  # Formatters
  stylua
  nixfmt
]
