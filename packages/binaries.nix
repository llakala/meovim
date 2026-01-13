{ pkgs }:

with pkgs; [
  # Language servers
  nil
  lua-language-server
  tinymist

  # Formatters
  stylua
  nixfmt
]
